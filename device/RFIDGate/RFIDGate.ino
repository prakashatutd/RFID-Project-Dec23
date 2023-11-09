/*
  RFID Gate Firmware
*/

#include <IPAddress.h>
#include <WiFiS3.h>

#include "SparkFun_UHF_RFID_Reader.h"
#include "TagCache.h"

#define EPC_OFFSET 31

#define BUZZER1 9
#define BUZZER2 10

#define WRITE_COMMAND "write"
#define SETPOWER_COMMAND "gain"
#define DEBUG_COMMAND "debug"
#define STATS_COMMAND "stats"

// WiFi variables
IPAddress serverIP(192, 168, 1, 133);
WiFiClient wifiClient;

// RFID variables
bool debug = false;
bool gateReading = false;
TagCache<32> tagCache;
RFID nano;

// Establish connection between Arduino and RFID module at specified baud rate
// Return true if connection established, false otherwise
bool setupNano(long baudRate)
{
  // The Uno R4 WiFi has two serial ports:
  // 1) Serial is exposed via USB-C
  // 2) Serial1 is exposed via RX/TX pins (D0/D1)
  // We use Serial for debugging and Serial1 for Arduino <-> module communication

  nano.begin(Serial1);
  Serial1.begin(baudRate);
  while (!Serial1); // Wait for port to open

  //About 200ms from power on module will send its firmware version at 115200bps, ignore it
  while (Serial1.available())
    Serial1.read();

  nano.getVersion();

  if (nano.msg[0] == ERROR_WRONG_OPCODE_RESPONSE)
  {
    // Wrong opcode indicates that module is already doing a continuous read, so tell it to stop
    nano.stopReading();
    Serial.println("Module continuously reading. Asking it to stop...");
    delay(1500);
  }
  else
  {
    // Module did not respond so assume that it is on and communicating at 115200bps
    Serial1.begin(115200);
    // Now change the baud rate
    nano.setBaud(baudRate);
    Serial1.begin(baudRate);
    delay(250);
  }

  nano.getVersion();

  if (nano.msg[0] != ALL_GOOD)
    return false;

  nano.setTagProtocol(); // Set protocol to Gen2
  nano.setAntennaPort(); // Set TX/RX antenna ports to 1
  nano.setRegion(REGION_NORTHAMERICA);
  return true;
}

// Attempt to connect to local network
bool connectWifi()
{
  if (WiFi.status() == WL_NO_MODULE)
  {
    Serial.println("Communication with WiFi module failed!");
    return false;
  }

  int status = 0;

  // Repeatedly try to connect until successful
  while (status != WL_CONNECTED)
  {
    Serial.print("Attempting to connect to WPA SSID: ");
    Serial.println(WIFI_SSID);
    status = WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
    delay(10000); // wait 10 seconds between retries
  }

  return true;
}

void setup()
{
  Serial.begin(115200);
  while (!Serial); // Wait for port to open

  pinMode(BUZZER1, OUTPUT);
  pinMode(BUZZER2, OUTPUT);
  digitalWrite(BUZZER2, LOW);

  // Configure nano to run at 115200bps
  if (!setupNano(115200))
  {
    Serial.println("Module not connected!");
    while (true);
  }

  Serial.println("Module connected!");
  nano.setReadPower(500);
  Serial.println("Antenna gain set to 5.00 dBm");
  startReading();
}

bool startReading()
{
  if (!gateReading)
  {
    nano.startReading();
    gateReading = true;
    return true;
  }
  return false;
}

bool stopReading()
{
  if (gateReading)
  {
    nano.stopReading();
    delay(1600);
    gateReading = false;
    return true;
  }
  return false;
}

// Write string to tag
bool writeTag(const char* data)
{
  if (!data)
    return false;

  char buffer[12] = { 0 };

  for (size_t i = 0; i < sizeof(buffer) * 2; ++i)
  {
    char c = *data++;
    if (c >= '0' && c <= '9')
      c = c - '0';
    else if (c >= 'a' && c <= 'f')
      c = c - 'a' + 10;
    else if (c >= 'A' && c <= 'F')
      c = c - 'A' + 10;
    else if (!c || c == ' ')
      break;
    else
      return false;

    if (i % 2 == 0)
      buffer[i / 2] = c << 4;
    else
      buffer[(i - 1) / 2] += c;
  }

  bool wasReading = stopReading();
  bool ret = nano.writeTagEPC(buffer, sizeof(buffer), 5000) == RESPONSE_SUCCESS;

  if (wasReading)
    startReading();
  
  return ret;
}

const char* skipWhitespace(const char* str) {
  if (!str)
    return str;
  
  while (*str && *str == ' ')
    ++str;
    
  return str;
}

// Essentially only four commands:
// - write [tag data]
// - setpower [num]
// - stats (temperature, power, etc)
// - debug

void loop()
{
  static char inputBuffer[33];

  if (Serial.available())
  {
    size_t readCount = Serial.readBytesUntil('\n', inputBuffer, sizeof(inputBuffer) - 1);

    // Add null terminator
    inputBuffer[readCount] = 0;

    // Flush input buffer until next newline
    if (readCount == sizeof(inputBuffer) - 1)
    {
      char c;
      do
        c = Serial.read();
      while (c != -1 && c != '\n');
    }

    Serial.println(inputBuffer);

    if (!strncmp(inputBuffer, WRITE_COMMAND, sizeof(WRITE_COMMAND) - 1))
    {
      const char* tagData = skipWhitespace(inputBuffer + sizeof(WRITE_COMMAND) - 1);
      if (writeTag(tagData))
        Serial.println("Successfully wrote to tag!");
      else
        Serial.println("Error writing to tag!");
    }
    else if (!strncmp(inputBuffer, SETPOWER_COMMAND, sizeof(SETPOWER_COMMAND) - 1))
    {
      char* end;
      const long gain = strtol(inputBuffer + sizeof(SETPOWER_COMMAND), &end, 10);

      if (end == inputBuffer)
        Serial.println("Invalid gain value!");

      if (gain == 0)
        stopReading();
      else if (gain > 0 || gain <= 2700)
      {
        bool wasReading = stopReading();
        nano.setReadPower(gain);
        nano.setWritePower(gain);

        if (wasReading)
          startReading();
      }
      else
        Serial.println("Gain value must be in range [0, 2700]");

      Serial.print("Antenna gain set to ");
      Serial.print((float)gain / 100);
      Serial.println(" dBm");
    }
    else if (!strncmp(inputBuffer, DEBUG_COMMAND, sizeof(DEBUG_COMMAND) - 1))
    {
      if (debug)
      {
        nano.disableDebugging();
        debug = false;
        Serial.println("Debug mode disabled!");
      }
      else
      {
        nano.enableDebugging();
        debug = true;
        Serial.println("Debug mode enabled!");
      }
    }
    else if (!strncmp(inputBuffer, STATS_COMMAND, sizeof(STATS_COMMAND) - 1))
    {
      /*Serial.println("RFID module stats:");
      Serial.print("Antenna gain: ");
      Serial.println("PLACEHOODER");
      Serial.print("Temperature: ");*/
      // print stats
      Serial.println("<stats placeholder>");
    }
    else
      Serial.println("Unknown command!");
  }

  if (gateReading && nano.check())
  {
    uint8_t responseType = nano.parseResponse();

    if (responseType == RESPONSE_IS_TAGFOUND)
    {
      uint8_t epcLength = nano.getTagEPCBytes();
      if (tagCache.insert(nano.msg + EPC_OFFSET, epcLength, 3000))
      {
        tone(BUZZER1, 1800, 100);
        Serial.print("Tag data: ");
        for (size_t i = EPC_OFFSET; i < EPC_OFFSET + epcLength; ++i)
          Serial.print(nano.msg[i], HEX);

        Serial.print(" (");
        Serial.print(epcLength);
        Serial.print(" bytes");
        Serial.println(')');
      }
    }
  }
}

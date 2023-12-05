#include <IPAddress.h>
#include <WiFiS3.h>

#include "SparkFun_UHF_RFID_Reader.h"
#include "TagCache.h"

#define EPC_OFFSET 31
#define WIFI_SSID "RFID-ICS"
#define WIFI_PASSWORD "RFID-ICS"
#define INTERNAL_ID "1"
#define SERVER_PORT 8000

#define BUZZER1 9
#define BUZZER2 10

// WiFi variables
IPAddress serverIP(192, 168, 1, 133);
WiFiClient wifiClient;
unsigned long lastMessageTime = 0;

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

void sendProductCodes()
{
  //wifiClient.println("PATCH /api/gate/scan/ HTTP/1.0");
  //wifiClient.println("{\"internal_id\":\"0\",");

  for (size_t i = 0; i < tagCache.capacity(); ++i)
  {
    uint32_t productId;
    uint32_t productCode;

    if (!tagCache.remove(i, &productId, &productCode))
      continue;
    
    //wifiClient.print("\"");
    //for (size_t j = 0; j < EPC_LENGTH; ++j)
    //  wifiClient.print(epc[j], HEX);
    //wifiClient.print("\",");
  }

  wifiClient.print("]}");
  wifiClient.println();
}

void sendKeepAlive()
{
  wifiClient.println("PATCH /api/gate/status/ HTTP/1.0");
  wifiClient.println("{\"internal_id\":\"0\"}");
}

void setup()
{
  Serial.begin(115200);
  while (!Serial); // Wait for port to open

  pinMode(BUZZER1, OUTPUT);
  pinMode(BUZZER2, OUTPUT);
  digitalWrite(BUZZER2, LOW);

  //connectWifi();
  //Serial.println("WiFi connected!");

  //wifiClient.connect(serverIP, SERVER_PORT);

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

bool writeTag(uint32_t productId, uint32_t productSerialNumber)
{
  char buffer[12] = { 0 };
  memcpy(buffer, &productId, sizeof(productId));
  memcpy(buffer + sizeof(productId), &productSerialNumber, sizeof(productSerialNumber));

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

    uint32_t productId = 0;
    uint32_t productSerialNumber = 0;
    long gain = 0;

    if (sscanf(inputBuffer, "write %u %u", &productId, &productSerialNumber) == 2)
    {
        if (writeTag(productId, productSerialNumber))
          Serial.println("Successfully wrote to tag!");
        else
          Serial.println("Error writing to tag!");
    }
    else if (sscanf(inputBuffer, "gain %d", &gain) == 1)
    {
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
    else if (!strncmp(inputBuffer, "debug", sizeof("debug") - 1))
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
    else
      Serial.println("Unknown command!");
  }

  if (gateReading && nano.check())
  {
    uint8_t responseType = nano.parseResponse();

    if (responseType == RESPONSE_IS_TAGFOUND)
    {
      uint8_t epcLength = nano.getTagEPCBytes();
      uint8_t* epcStart = nano.msg + EPC_OFFSET;

      uint32_t productId;
      uint32_t productSerialNumber;
      memcpy(&productId, epcStart, sizeof(productId));
      memcpy(&productSerialNumber, epcStart + sizeof(productId), sizeof(productSerialNumber));

      if (tagCache.insert(productId, productSerialNumber))
      {
        tone(BUZZER1, 1800, 100);
        Serial.print("Product ID: ");
        Serial.print(productId);
        Serial.print(" Product serial number: ");
        Serial.println(productSerialNumber);
      }
    }
  }

  // if (millis() - lastMessageTime > 5000 && tagCache.size() > 0)
  // {
  //   Serial.print("Tag cache size: ");
  //   Serial.print(tagCache.size());
  //   Serial.println();
  //   sendProductCodes();
  //   Serial.println("Sent product codes!");
  //   lastMessageTime = millis();
  // }
}

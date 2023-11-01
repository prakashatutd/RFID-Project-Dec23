/*
  RFID Gate Firmware
*/

#include "SparkFun_UHF_RFID_Reader.h"
#include "TagCache.h"

#define DEBUG false

#define EPC_OFFSET 31

bool gateReading = false;
TagCache<32> tagCache;
RFID nano;

char inputBuffer[24];

// Establishes connection between Arduino and RFID module at specified baud rate
// Returns true if connection established, false otherwise
bool setupNano(long baudRate)
{
  // The Uno R4 WiFi has two serial ports:
  // 1) Serial is exposed via USB-C
  // 2) Serial1 is exposed via RX/TX pins (D0/D1)
  // We use Serial for debugging and Serial1 for Arduino <-> module communication

  if (DEBUG)
    nano.enableDebugging(Serial);

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
  return true;
}

void setup()
{
  Serial.begin(115200);
  while (!Serial); // Wait for port to open

  // Configure nano to run at 115200bps
  if (setupNano(115200)) 
  {
    Serial.println("Module connected!");
    nano.setRegion(REGION_NORTHAMERICA);
    nano.setReadPower(500);
    startReading();
  }
  else
  {
    Serial.println(F("Module not connected!"));
    while (1); // Freeze!
  }
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
    delay(1700);
    gateReading = false;
    return true;
  }
  return false;
}

bool writeTag(const String& data)
{
  char buffer[12] = { 0 };
  char temp = 0;
  size_t i;

  for (i = 0; i < min(2 * sizeof(buffer), data.length()); ++i)
  {
    char c = data[i];

    // Get the corresponding hex value of c
    if (c >= '0' && c <= '9')
      c = c - '0';
    else if (c >= 'a' && c <= 'f')
      c = c - 'a' + 10;
    else if (c >= 'A' && c <= 'F')
      c = c - 'A' + 10;
    else
      return false;

    if (i % 2 == 0)
      temp = c << 4;
    else
      buffer[(i - 1) / 2] = temp + c;
  }

  bool wasReading = stopReading();
  bool ret = false;

  // Repeatedly try to write tag for five seconds
  for (auto j = 0; i < 20; ++j)
  {
    if (nano.writeTagEPC(buffer, sizeof(buffer) == RESPONSE_SUCCESS))
    {
      ret = true;
      break;
    }
    delay(250);
  }

  if (wasReading)
    startReading();
  
  return ret;
}

bool setReadPower(long powerSetting)
{
  if (powerSetting < 100 || powerSetting > 2700)
    return false;
  
  nano.setReadPower(powerSetting);
  return true;
}

size_t readLine(char* buffer, size_t length)
{
  char c = 0;

  for (size_t i = 0; i < length; ++i)
  {
    c = Serial.read();
    if (c == -1 || c == '\n')
      return i;
    buffer[i] = c;
  }

  while (c != -1 && c != '\n')
    c = Serial.read();

  return length;
}

void loop()
{
  if (Serial.available())
  {
    String line = Serial.readStringUntil('\n');

    if (line.startsWith("idle"))
    {
      if (stopReading())
        Serial.println("Device entered idle mode");
    }
    else if (line.startsWith("scan"))
    {
      if (startReading())
        Serial.println("Device entered continuous scan mode");
    }
    else if (line.startsWith("write"))
    {
      line.remove(0, sizeof("write"));
      line.trim();
      Serial.print("Writing to tag ... ");
      if (writeTag(line))
        Serial.println("Success!");
      else
        Serial.println("Write failed!");
    }
    else if (line.startsWith("power"))
    {
      line.remove(0, sizeof("power"));
      line.trim();
      long powerSetting = line.toInt();

      if (setReadPower(powerSetting))
      {
        Serial.print("Antenna power set to ");
        Serial.print((float)powerSetting / 100);
        Serial.println(" dBm");
      }
      else
        Serial.println("Invalid antenna power setting; must be in range [100, 2700]");
    }
    else
      Serial.println("Unknown command");
  }

  if (!gateReading)
    return;

  if (nano.check())
  {
    uint8_t responseType = nano.parseResponse();

    if (responseType == RESPONSE_IS_TAGFOUND)
    {
      uint8_t epcLength = nano.getTagEPCBytes();
      if (tagCache.insert(nano.msg + EPC_OFFSET, epcLength))
      {
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

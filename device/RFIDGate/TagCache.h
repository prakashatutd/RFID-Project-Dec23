#ifndef __TAG_CACHE_H__
#define __TAG_CACHE_H__

#include "Arduino.h"

#define EPC_LENGTH 12

template <size_t Size>
class TagCache
{
  struct Record
  {
    uint8_t epc[EPC_LENGTH];
    unsigned long timestamp;
  };

  size_t _size;     // Number of entries currently cached
  Record _records[Size];

  public:

    TagCache() : _size(0) { };
    
    size_t size() const
    {
      return _size;
    }

    // Returns true if successfully inserted, false otherwise
    bool insert(const uint8_t* epc, size_t epcLength, unsigned long timeout = 1000)
    {
      if (epcLength < EPC_LENGTH)
        return false;

      // Index of first empty cache slot
      ssize_t firstEmpty = -1;
      size_t recordCount = 0;

      for (size_t i = 0; i < Size; ++i)
      {
        Record& record(_records[i]);
        unsigned long timestamp = record.timestamp;

        // Slots with timestamp zero are considered empty
        if (timestamp == 0)
        {
          if (firstEmpty == -1)
            firstEmpty = i;
          continue;
        }

        if (++recordCount > _size)
          return false;

        // Check if EPC already present
        if (!memcmp(epc, record.epc, EPC_LENGTH))
        {
          unsigned long newTimestamp = millis();
          record.timestamp = newTimestamp;
          return newTimestamp - timestamp > timeout;
        }
      }

      // Save tag data in empty record
      memcpy(_records[firstEmpty].epc, epc, EPC_LENGTH);
      _records[firstEmpty].timestamp = millis();
      ++_size;
      return true;
    }
};

#endif
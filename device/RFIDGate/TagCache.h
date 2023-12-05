#ifndef __TAG_CACHE_H__
#define __TAG_CACHE_H__

#include "Arduino.h"

#define EPC_LENGTH 12

template <size_t Size>
class TagCache
{
  struct Record
  {
    uint32_t productId;
    uint32_t productCode;
    unsigned long timestamp;
    bool valid = false;
  };

  size_t _size;     // Number of entries currently cached
  Record _records[Size];

  public:

    TagCache() : _size(0) { };
    
    size_t size() const
    {
      return _size;
    }

    size_t capacity() const
    {
      return Size;
    }

    // Returns true if successfully inserted, false otherwise
    bool insert(uint32_t productId, uint32_t productSerialNumber, unsigned long timeout = 5000)
    {
      // Index of first empty cache slot
      ssize_t firstEmpty = -1;
      size_t recordCount = 0;

      for (size_t i = 0; i < Size; ++i)
      {
        Record& record(_records[i]);

        if (record.productId == productId && record.productCode == productSerialNumber)
        {
          unsigned long timestamp = record.timestamp;
          unsigned long newTimestamp = millis();
          record.timestamp = newTimestamp;
          return newTimestamp - timestamp > timeout;
        }

        if (!record.valid)
        {
          if (firstEmpty == -1)
            firstEmpty = i;
          continue;
        }
        
        if (++recordCount > _size)
          return false;
      }

      // Save tag data in empty record
      Record& record(_records[firstEmpty]);
      record.productId = productId;
      record.productCode = productSerialNumber;
      record.timestamp = millis();
      record.valid = true;
      ++_size;
      return true;
    }

    // Remove an entry at the specified index, and return pointer to epc data,
    // or null if no entry at index
    bool remove(size_t i, uint32_t* productId, uint32_t* productSerialNumber)
    {
      Record& record(_records[i]);

      if (!record.valid)
        return false;

      record.valid = false;
      --_size;
      *productId = record.productId;
      *productSerialNumber = record.productCode;
      return true;
    }
};

#endif
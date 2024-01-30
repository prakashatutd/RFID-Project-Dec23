#ifndef __TAG_CACHE_H__
#define __TAG_CACHE_H__

// This file defines a basic data structure for caching scanned tag information.

#include "Arduino.h"

// Length, in bytes, of the EPC field on a tag
#define EPC_LENGTH 12

template <size_t Size>
class TagCache
{
  // Tag record
  struct Record
  {
    uint32_t productId;           // ID used to determine product type
    uint32_t productSerialNumber; // ssed to differentiate between items of same product type
    unsigned long timestamp;      // time when tag was scanned
    bool valid = false;           // whether the record is valid
  };

  size_t _size;          // number of entries currently cached
  Record _records[Size]; // record array

  public:

    TagCache() : _size(0) { };
    
    // Return the number of records currently stored in the cache
    size_t size() const
    {
      return _size;
    }

    // Return the maximum number of records the cache can hold
    size_t capacity() const
    {
      return Size;
    }

    // Insert a record; return true if successfully inserted, false otherwise.
    //
    // 1) If there is space available in the cache and there is no record with the specified
    // product ID and serial number present, a record will be successfully inserted.
    //
    // 2) If there is a record with the same product ID and serial number already present, a new
    // record will be inserted as long as the time difference between the new record and existing
    // record exceeds the timeout period.
    //
    // For example, if a record was inserted at t = 1000, after which the same record is inserted
    // at t = 3000, insertion will fail. If however, the same record is inserted at t = 7000, the
    // insertion will succeed.
    bool insert(uint32_t productId, uint32_t productSerialNumber, unsigned long timeout = 5000)
    {
      ssize_t firstEmpty = -1; // keep track of the first empty cache slot
      size_t recordCount = 0;  // keep track of how many records we've checked

      for (size_t i = 0; i < Size; ++i)
      {
        Record& record(_records[i]);

        if (record.productId == productId && record.productSerialNumber == productSerialNumber)
        {
          // Duplicate record; check timestamp
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
        
        // Cache is full
        if (++recordCount > _size)
          return false;
      }

      // Save tag data in first empty record
      Record& record(_records[firstEmpty]);
      record.productId = productId;
      record.productSerialNumber = productSerialNumber;
      record.timestamp = millis();
      record.valid = true;
      ++_size;
      return true;
    }

    // Remove a record at the specified index, setting productId and productSerialNumber
    // to point at the record's corresponding fields
    // Return true if a record was removed, or false if no valid record exists at the
    // specified index
    bool remove(size_t i, uint32_t* productId, uint32_t* productSerialNumber)
    {
      Record& record(_records[i]);

      if (!record.valid)
        return false;

      record.valid = false;
      --_size;
      // Replace these assignments with memcpy, because this is so unsafe
      *productId = record.productId;
      *productSerialNumber = record.productSerialNumber;
      return true;
    }
};

#endif
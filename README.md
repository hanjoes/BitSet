# BitSet

## Description

Generic bitset in Swift. 
By generic it means we can specify bit width specifying type parameter. Examples see below.

## Usage

```swift
let bs = BitSet<UInt16>(numBits: 1) // creates a BitSet with memory layout "00000000 00000000"
bs.set(at: 10) // sets the bit at index 10 (starting from 0) and result is "00000000 00100000"
```

## Notes

This BitSet implementation is not optimized for performance. 
The motivation is to get something works and can be used in other projects.

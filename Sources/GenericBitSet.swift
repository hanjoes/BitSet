public class BitSet<ChunkType: Comparable & UnsignedInteger> {
    
    // MARK: - Properties
    
    /// Buffer holding all the chunks.
    public var buffer: UnsafeMutableBufferPointer<ChunkType>

    /// Number of chunks in this BitSet.
    public let numChunks: Int

    /// Number of bits in this BitSet. Always rounded up to the next 
    /// chunk boundary.
    public let bitNum: Int
    
    /// Constant for number of bits in a chunk. Determined by the ChunkType
    /// generic variable.
    fileprivate let numBitsInChunk = MemoryLayout<ChunkType>.stride * 8
    
    /// Convenience masks for range related operations.
    /// Contains consecutive bit masks starting from left.
    public lazy var leftConsecutiveMasks: [ChunkType] = {
        var result = [ChunkType]()
        var previous: ChunkType = 0
        for i in 0..<self.numBitsInChunk {
            let currentMask = ChunkType(UIntMax(1) << UIntMax(self.numBitsInChunk - i - 1))
            let currentNumber = previous | currentMask
            result.append(currentNumber)
            previous = currentNumber
        }
        return result
    }()
    
    /// Convenience masks for range related operations.
    /// Contains consecutive bit masks starting from right.
    public lazy var rightConsecutiveMasks: [ChunkType] = {
        var result = [ChunkType]()
        var previous: ChunkType = 0
        for i in 0..<self.numBitsInChunk {
            let currentMask = ChunkType(UIntMax(1) << UIntMax(i))
            let currentNumber = previous | currentMask
            result.append(currentNumber)
            previous = currentNumber
        }
        return result.reversed()
    }()
    
    /// Number of bits set in this BitSet.
    public var popcnt: Int {
        // TODO: Naive implementation.
        var result = 0
        for chunk in buffer {
            result += popcnt(of: chunk)
        }
        return result
    }
    
    // MARK: - Methods

    /// Initialize a BitSet with number of bits in it.
    ///
    /// - Parameter n: number of bits in this BitSet, always rounded up to ChunkType
    /// length boundary.
    public init(numBits n: Int) {
        // Round up to the next chunk boundary.
        let mask = numBitsInChunk - 1
        self.bitNum = (n & mask == 0) ? n : (n & ~mask) + numBitsInChunk
        self.numChunks = self.bitNum / self.numBitsInChunk
        
        // Initialize memory
        let memory = UnsafeMutablePointer<ChunkType>.allocate(capacity: self.numChunks)
        memory.initialize(to: 0, count: self.numChunks)
        self.buffer = UnsafeMutableBufferPointer<ChunkType>(start: memory, count: self.numChunks)
    }
    
    deinit {
        buffer.baseAddress?.deinitialize(count: self.numChunks)
        buffer.baseAddress?.deallocate(capacity: self.numChunks)
    }
    
    /// Set a bit at the specified index.
    /// This operation is safe. Out of index will not change the bitset.
    ///
    /// - Parameter index: index (starting from 0) of the bit to set.
    public func set(at index: Int) {
        guard index >= 0 && index < bitNum else {
            return
        }
        
        let chunkIndex = index / self.numBitsInChunk
        let chunkOffset = index % self.numBitsInChunk
        let bitMask = UIntMax(1 << (self.numBitsInChunk - chunkOffset - 1))
        buffer[chunkIndex] |= ChunkType(bitMask)
    }
    
    /// Clear a bit at the specified index.
    ///
    /// - Parameter index: index (starting from 0) of the bit to clear.
    public func clear(at index: Int) {
        guard index >= 0 && index < bitNum else {
            return
        }
        
        let chunkIndex = index / self.numBitsInChunk
        let chunkOffset = index % self.numBitsInChunk
        let bitMask = UIntMax(1 << (self.numBitsInChunk - chunkOffset - 1))
        buffer[chunkIndex] &= ~ChunkType(bitMask)
    }
    
    /// Set a range of bits in the BitSet.
    ///
    /// - Parameter range: range to set.
    public func set(range: ClosedRange<Int>) {
        guard range.lowerBound >= 0 && range.upperBound < bitNum else {
            return
        }
        
        let minChunkIndex = range.lowerBound / self.numBitsInChunk
        let maxChunkIndex = range.upperBound / self.numBitsInChunk
        let minChunkOffset = range.lowerBound % self.numBitsInChunk
        let maxChunkOffset = range.upperBound % self.numBitsInChunk
        
        var mask: ChunkType
        if minChunkIndex == maxChunkIndex {
            mask = rightConsecutiveMasks[minChunkOffset] & leftConsecutiveMasks[maxChunkOffset]
            buffer[minChunkIndex] |= mask
        }
        else {
            for chunkIndex in minChunkIndex...maxChunkIndex {
                var mask: ChunkType
                if chunkIndex == minChunkIndex {
                    mask = rightConsecutiveMasks[minChunkOffset]
                }
                else if chunkIndex == maxChunkIndex {
                    mask = leftConsecutiveMasks[maxChunkOffset]
                }
                else {
                    mask = rightConsecutiveMasks[0]
                }
                buffer[chunkIndex] |= mask
            }
        }
    }
    
    /// Clear a range of bits in the Bitset.
    ///
    /// - Parameter range: range to clear.
    public func clear(range: ClosedRange<Int>) {
        guard range.lowerBound >= 0 && range.upperBound < bitNum else {
            return
        }
        
        let minChunkIndex = range.lowerBound / self.numBitsInChunk
        let maxChunkIndex = range.upperBound / self.numBitsInChunk
        let minChunkOffset = range.lowerBound % self.numBitsInChunk
        let maxChunkOffset = range.upperBound % self.numBitsInChunk
        
        var mask: ChunkType
        if minChunkIndex == maxChunkIndex {
            mask = ~rightConsecutiveMasks[minChunkOffset] | ~leftConsecutiveMasks[maxChunkOffset]
            buffer[minChunkIndex] &= mask
        }
        else {
            for chunkIndex in minChunkIndex...maxChunkIndex {
                var mask: ChunkType
                if chunkIndex == minChunkIndex {
                    mask = ~rightConsecutiveMasks[minChunkOffset]
                }
                else if chunkIndex == maxChunkIndex {
                    mask = ~leftConsecutiveMasks[maxChunkOffset]
                }
                else {
                    mask = ~rightConsecutiveMasks[0]
                }
                buffer[chunkIndex] &= mask
            }
        }
    }
    
    /// Union with another bitset.
    ///
    /// - Parameter another: the other bitset to union with the current one
    public func union(with another: BitSet<ChunkType>) {
        for index in 0..<self.numChunks {
            self.buffer[index] |= another.buffer[index]
        }
    }
    
    /// Intersect with another bitset.
    ///
    /// - Parameter another: the other bitset to intersect with the current one
    public func intersect(with another: BitSet<ChunkType>) {
        for index in 0..<self.numChunks {
            self.buffer[index] &= another.buffer[index]
        }
    }
    
}

// MARK: - Private

private extension BitSet {
    func paddedString(of num: ChunkType) -> String {
        let rawConverted = String(num, radix: 2)
        var converted = rawConverted
        for _ in 0..<(self.numBitsInChunk - rawConverted.characters.count) {
            converted = "0\(converted)"
        }
        return converted
    }
    
    func popcnt(of chunk: ChunkType) -> Int {
        var count = 0
        for offset in 0..<self.numBitsInChunk {
            let mask = ChunkType(UIntMax(1) << UIntMax(offset))
            if mask & chunk != 0 {
                count += 1
            }
        }
        return count
    }
}

// MARK: - CustomStringConvertible

extension BitSet: CustomStringConvertible {
    public var description: String {
        var convertedChunks = [String]()
        for chunk in buffer {
            convertedChunks.append(paddedString(of: chunk))
        }
        return convertedChunks.joined(separator: " ")
    }
}

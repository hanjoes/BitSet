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
    ///
    /// - Parameter index: index (starting from 0) of the bit to set.
    public func set(at index: Int) {
    }
    
    /// Clear a bit at the specified index.
    ///
    /// - Parameter index: index (starting from 0) of the bit to clear.
    public func clear(at index: Int) {
    }
    
    /// Set a range of bits in the BitSet.
    ///
    /// - Parameter range: range to clear.
    public func set(range: ClosedRange<Int>) {
    }
    
    /// Clear a range of bits in the Bitset.
    ///
    /// - Parameter range: range to clear.
    public func clear(range: ClosedRange<Int>) {
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

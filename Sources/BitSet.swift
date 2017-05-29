public class BitSet<ChunkType: Comparable & UnsignedInteger> {
    
    // MARK: - Properties
    
    var buffer: UnsafeMutableBufferPointer<ChunkType>
    
    let numChunks: Int
    
    fileprivate let numBitsInChunk = MemoryLayout<ChunkType>.stride * 8
    
    // MARK: - Methods

    public init(numBits: Int) {
        // Round up to the next chunk boundary.
        let numChunks = numBits / numBitsInChunk + 1
        let memory = UnsafeMutablePointer<ChunkType>.allocate(capacity: numChunks)
        memory.initialize(to: 0, count: numChunks)
        buffer = UnsafeMutableBufferPointer<ChunkType>(start: memory, count: numChunks)
        self.numChunks = numChunks
    }
    
    deinit {
        buffer.baseAddress?.deinitialize(count: self.numChunks)
        buffer.baseAddress?.deallocate(capacity: self.numChunks)
    }

    
    public func set(at: Int) -> BitSet {
        return BitSet(numBits: 0)
    }
    
    public func clear(at: Int) -> BitSet {
        return BitSet(numBits: 0)
    }
    
    public func set(range: ClosedRange<Int>) -> BitSet {
        return BitSet(numBits: 0)
    }
    
    public func clear(range: ClosedRange<Int>) -> BitSet {
        return BitSet(numBits: 0)
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

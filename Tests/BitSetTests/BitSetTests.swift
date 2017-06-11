import XCTest
@testable import GenericBitSet

class BitSetTests: XCTestCase {

    // MARK: - Test Initialization

    func testInitializeEmpty() {
        let bs = BitSet<UInt8>(numBits: 0)
        XCTAssertEqual("", bs.description)
    }
    
    func testInitializeOnBoundary() {
        let bs = BitSet<UInt8>(numBits: 8)
        XCTAssertEqual("00000000", bs.description)
    }
    
    func testInitializeShorterThanOneChunk() {
        let bs = BitSet<UInt8>(numBits: 5)
        XCTAssertEqual("00000000", bs.description)
    }
    
    func testInitializeLongerThanOneChunk() {
        let bs = BitSet<UInt8>(numBits: 9)
        XCTAssertEqual("00000000 00000000", bs.description)
    }
    
    // MARK: - Test Set
    
    func testSetBeginning() {
        let bs = BitSet<UInt8>(numBits: 8)
        bs.set(at: 0)
        XCTAssertEqual("10000000", bs.description)
    }
    
    func testSetEnd() {
        let bs = BitSet<UInt8>(numBits: 8)
        bs.set(at: 7)
        XCTAssertEqual("00000001", bs.description)
    }
    
    func testSetMiddle() {
        let bs = BitSet<UInt8>(numBits: 8)
        bs.set(at: 4)
        XCTAssertEqual("00001000", bs.description)
    }
    
    func testSetCrossBoundaryBeginning() {
        let bs = BitSet<UInt8>(numBits: 9)
        bs.set(at: 8)
        XCTAssertEqual("00000000 10000000", bs.description)
    }
    
    func testSetCrossBoundaryEnd() {
        let bs = BitSet<UInt8>(numBits: 9)
        bs.set(at: 12)
        XCTAssertEqual("00000000 00001000", bs.description)
    }
    
    func testSetCrossBoundaryMiddle() {
        let bs = BitSet<UInt8>(numBits: 9)
        bs.set(at: 15)
        XCTAssertEqual("00000000 00000001", bs.description)
    }
    
    func testSetGreaterThanMax() {
        let bs = BitSet<UInt8>(numBits: 1)
        bs.set(at: 10)
        XCTAssertEqual("00000000", bs.description)
    }
    
    func testSetLessThanMin() {
        let bs = BitSet<UInt8>(numBits: 1)
        bs.set(at: -1)
        XCTAssertEqual("00000000", bs.description)
    }
    
    
    // MARK: - Test Clear
    
    func testClearBeginning() {
        let bs = BitSet<UInt8>(numBits: 8)
        bs.set(at: 0)
        XCTAssertEqual("10000000", bs.description)
        bs.clear(at: 0)
        XCTAssertEqual("00000000", bs.description)
    }
    
    func testClearEnd() {
        let bs = BitSet<UInt8>(numBits: 8)
        bs.set(at: 7)
        XCTAssertEqual("00000001", bs.description)
        bs.clear(at: 7)
        XCTAssertEqual("00000000", bs.description)
    }
    
    func testClearMiddle() {
        let bs = BitSet<UInt8>(numBits: 8)
        bs.set(at: 4)
        XCTAssertEqual("00001000", bs.description)
        bs.clear(at: 4)
        XCTAssertEqual("00000000", bs.description)
    }
    
    func testClearCrossBoundaryBeginning() {
        let bs = BitSet<UInt8>(numBits: 9)
        bs.set(at: 8)
        XCTAssertEqual("00000000 10000000", bs.description)
        bs.clear(at: 8)
        XCTAssertEqual("00000000 00000000", bs.description)
    }
    
    func testClearCrossBoundaryEnd() {
        let bs = BitSet<UInt8>(numBits: 9)
        bs.set(at: 12)
        XCTAssertEqual("00000000 00001000", bs.description)
        bs.clear(at: 12)
        XCTAssertEqual("00000000 00000000", bs.description)
    }
    
    func testClearCrossBoundaryMiddle() {
        let bs = BitSet<UInt8>(numBits: 9)
        bs.set(at: 15)
        XCTAssertEqual("00000000 00000001", bs.description)
        bs.clear(at: 15)
        XCTAssertEqual("00000000 00000000", bs.description)
    }
    
    func testClearGreaterThanMax() {
        let bs = BitSet<UInt8>(numBits: 1)
        bs.clear(at: 10)
        XCTAssertEqual("00000000", bs.description)
    }
    
    func testClearLessThanMin() {
        let bs = BitSet<UInt8>(numBits: 1)
        bs.clear(at: -1)
        XCTAssertEqual("00000000", bs.description)
    }
    
    // MARK: - Test Consecutive Masks
    
    func testLeftConsecutiveMasks() {
        let bs = BitSet<UInt8>(numBits: 8)
        XCTAssertEqual([0x80, 0xC0, 0xE0, 0xF0, 0xF8, 0xFC, 0xFE, 0xFF],
                       bs.leftConsecutiveMasks)
    }
    
    func testRightConsecutiveMasks() {
        let bs = BitSet<UInt8>(numBits: 8)
        XCTAssertEqual([0xFF, 0x7F, 0x3F, 0x1F, 0x0F, 0x07, 0x03, 0x01],
                       bs.rightConsecutiveMasks)
    }

    // MARK: - Test Set Range
    
    func testSetRangeBeginning() {
        let bs = BitSet<UInt8>(numBits: 8)
        bs.set(range: 0...0)
        XCTAssertEqual("10000000", bs.description)
    }
    
    func testSetRangeEnd() {
        let bs = BitSet<UInt8>(numBits: 8)
        bs.set(range: 7...7)
        XCTAssertEqual("00000001", bs.description)
    }
    
    func testSetRangeMiddle() {
        let bs = BitSet<UInt8>(numBits: 8)
        bs.set(range: 4...4)
        XCTAssertEqual("00001000", bs.description)
    }
    
    func testSetRangeStepOnBoundary() {
        let bs = BitSet<UInt8>(numBits: 9)
        bs.set(range: 4...8)
        XCTAssertEqual("00001111 10000000", bs.description)
    }
    
    func testSetRangeNextChunkBeginning() {
        let bs = BitSet<UInt8>(numBits: 9)
        bs.set(range: 8...8)
        XCTAssertEqual("00000000 10000000", bs.description)
    }
    
    func testSetRangeNextChunkEnd() {
        let bs = BitSet<UInt8>(numBits: 9)
        bs.set(range: 15...15)
        XCTAssertEqual("00000000 00000001", bs.description)
    }
    
    func testSetRangeNextChunkMiddle() {
        let bs = BitSet<UInt8>(numBits: 9)
        bs.set(range: 12...12)
        XCTAssertEqual("00000000 00001000", bs.description)
    }
    
    func testSetRangeCrossMultipleChunks() {
        let bs = BitSet<UInt8>(numBits: 28)
        bs.set(range: 3...28)
        XCTAssertEqual("00011111 11111111 11111111 11111000", bs.description)
    }
    
    
    // MARK: - Test Clear Range
    
    func testClearRangeBeginning() {
        let bs = BitSet<UInt8>(numBits: 8)
        bs.set(range: 0...0)
        XCTAssertEqual("10000000", bs.description)
        bs.clear(range: 0...0)
        XCTAssertEqual("00000000", bs.description)
    }
    
    func testClearRangeEnd() {
        let bs = BitSet<UInt8>(numBits: 8)
        bs.set(range: 7...7)
        XCTAssertEqual("00000001", bs.description)
        bs.clear(range: 7...7)
        XCTAssertEqual("00000000", bs.description)
    }
    
    func testClearRangeMiddle() {
        let bs = BitSet<UInt8>(numBits: 8)
        bs.set(range: 4...4)
        XCTAssertEqual("00001000", bs.description)
        bs.clear(range: 4...4)
        XCTAssertEqual("00000000", bs.description)
    }
    
    func testClearRangeStepOnBoundary() {
        let bs = BitSet<UInt8>(numBits: 9)
        bs.set(range: 4...8)
        XCTAssertEqual("00001111 10000000", bs.description)
        bs.clear(range: 4...7)
        XCTAssertEqual("00000000 10000000", bs.description)
    }
    
    func testClearRangeNextChunkBeginning() {
        let bs = BitSet<UInt8>(numBits: 9)
        bs.set(range: 8...8)
        XCTAssertEqual("00000000 10000000", bs.description)
        bs.clear(range: 8...8)
        XCTAssertEqual("00000000 00000000", bs.description)
    }
    
    func testClearRangeNextChunkEnd() {
        let bs = BitSet<UInt8>(numBits: 9)
        bs.set(range: 15...15)
        XCTAssertEqual("00000000 00000001", bs.description)
        bs.clear(range: 15...15)
        XCTAssertEqual("00000000 00000000", bs.description)
    }
    
    func testClearRangeNextChunkMiddle() {
        let bs = BitSet<UInt8>(numBits: 9)
        bs.set(range: 12...12)
        XCTAssertEqual("00000000 00001000", bs.description)
        bs.clear(range: 12...12)
        XCTAssertEqual("00000000 00000000", bs.description)
    }
    
    func testClearRangeCrossMultipleChunks() {
        let bs = BitSet<UInt8>(numBits: 28)
        bs.set(range: 3...28)
        XCTAssertEqual("00011111 11111111 11111111 11111000", bs.description)
        bs.clear(range: 3...28)
        XCTAssertEqual("00000000 00000000 00000000 00000000", bs.description)
    }
    
    // MARK: - Popcnt
    
    func testPopcntEmpty() {
        let bs = BitSet<UInt8>(numBits: 8)
        XCTAssertEqual(0, bs.popcnt)
    }
    
    
    func testPopcntNotEmpty64Bit() {
        let bs = BitSet<UInt64>(numBits: 8)
        bs.set(range: 10...20)
        bs.set(range: 13...23)
        bs.set(range: 25...27)
        XCTAssertEqual(17, bs.popcnt)
    }
    
    // MARK: - Union
    
    func testUnionTwoEmpty() {
        let bs1 = BitSet<UInt64>(numBits: 1)
        let bs2 = BitSet<UInt64>(numBits: 1)
        bs1.union(with: bs2)
        XCTAssertEqual(0, bs1.popcnt)
    }
    
    func testUnionEmptyWithNonEmpty() {
        let bs1 = BitSet<UInt64>(numBits: 1)
        let bs2 = BitSet<UInt64>(numBits: 1)
        bs2.set(range: 1...10)
        bs1.union(with: bs2)
        XCTAssertEqual(10, bs1.popcnt)
    }
    
    func testUnionTwoRandomlyDistributed() {
        let bs1 = BitSet<UInt64>(numBits: 65)
        let bs2 = BitSet<UInt64>(numBits: 67)
        bs1.set(range: 1...10)
        bs1.set(range: 100...111)
        bs2.set(range: 20...30)
        bs2.set(range: 110...113)
        bs1.union(with: bs2)
        XCTAssertEqual(35, bs1.popcnt)
    }
    
    // MARK: - Intersect
    
    func testIntersectTwoEmpty() {
        let bs1 = BitSet<UInt64>(numBits: 1)
        let bs2 = BitSet<UInt64>(numBits: 1)
        bs1.intersect(with: bs2)
        XCTAssertEqual(0, bs1.popcnt)
    }
    
    func testIntersectEmptyWithNonEmpty() {
        let bs1 = BitSet<UInt64>(numBits: 1)
        let bs2 = BitSet<UInt64>(numBits: 1)
        bs2.set(range: 1...10)
        bs1.intersect(with: bs2)
        XCTAssertEqual(0, bs1.popcnt)
    }
    
    func testIntersectTwoRandomlyDistributed() {
        let bs1 = BitSet<UInt64>(numBits: 65)
        let bs2 = BitSet<UInt64>(numBits: 67)
        bs1.set(range: 1...10)
        bs1.set(range: 100...111)
        bs2.set(range: 20...30)
        bs2.set(range: 110...113)
        bs1.intersect(with: bs2)
        XCTAssertEqual(2, bs1.popcnt)
    }
    
    // MARK: - One
    
    func testEmptyTestOne() {
        let bs = BitSet<UInt64>(numBits: 1)
        XCTAssertFalse(bs.one(at: 0))
    }
    
    func testBeginningOne() {
        let bs = BitSet<UInt64>(numBits: 1)
        bs.set(at: 0)
        print(bs)
        XCTAssertTrue(bs.one(at: 0))
    }
    
    func testEndOne() {
        let bs = BitSet<UInt64>(numBits: 1)
        bs.set(at: 63)
        print(bs)
        XCTAssertTrue(bs.one(at: 63))
    }
    
    func testMiddleOne() {
        let bs = BitSet<UInt64>(numBits: 1)
        bs.set(at: 29)
        print(bs)
        XCTAssertTrue(bs.one(at: 29))
    }

    
    // MARK: - Registration

    static var allTests = [
        ("testEmptyTestOne", testEmptyTestOne),
        ("testIntersectTwoRandomlyDistributed", testIntersectTwoRandomlyDistributed),
        ("testIntersectEmptyWithNonEmpty", testIntersectEmptyWithNonEmpty),
        ("testIntersectTwoEmpty", testIntersectTwoEmpty),
        ("testUnionTwoRandomlyDistributed", testUnionTwoRandomlyDistributed),
        ("testUnionEmptyWithNonEmpty", testUnionEmptyWithNonEmpty),
        ("testUnionTwoEmpty", testUnionTwoEmpty),
        ("testPopcntEmpty", testPopcntEmpty),
        ("testClearRangeCrossMultipleChunks", testClearRangeCrossMultipleChunks),
        ("testClearRangeNextChunkMiddle", testClearRangeNextChunkMiddle),
        ("testClearRangeNextChunkEnd", testClearRangeNextChunkEnd),
        ("testClearRangeNextChunkBeginning", testClearRangeNextChunkBeginning),
        ("testClearRangeStepOnBoundary", testClearRangeStepOnBoundary),
        ("testClearRangeMiddle", testClearRangeMiddle),
        ("testClearRangeEnd", testClearRangeEnd),
        ("testClearRangeBeginning", testClearRangeBeginning),
        ("testSetRangeCrossMultipleChunks", testSetRangeCrossMultipleChunks),
        ("testSetRangeNextChunkMiddle", testSetRangeNextChunkMiddle),
        ("testSetRangeNextChunkEnd", testSetRangeNextChunkEnd),
        ("testSetRangeNextChunkBeginning", testSetRangeNextChunkBeginning),
        ("testSetRangeStepOnBoundary", testSetRangeStepOnBoundary),
        ("testSetRangeMiddle", testSetRangeMiddle),
        ("testSetRangeEnd", testSetRangeEnd),
        ("testSetRangeBeginning", testSetRangeBeginning),
        ("testRightConsecutiveMasks", testRightConsecutiveMasks),
        ("testLeftConsecutiveMasks", testLeftConsecutiveMasks),
        ("testClearLessThanMin", testClearLessThanMin),
        ("testClearGreaterThanMax", testClearGreaterThanMax),
        ("testClearCrossBoundaryMiddle", testClearCrossBoundaryMiddle),
        ("testClearCrossBoundaryEnd", testClearCrossBoundaryEnd),
        ("testClearCrossBoundaryBeginning", testClearCrossBoundaryBeginning),
        ("testClearMiddle", testClearMiddle),
        ("testClearEnd", testClearEnd),
        ("testClearBeginning", testClearBeginning),
        ("testSetLessThanMin", testSetLessThanMin),
        ("testSetGreaterThanMax", testSetGreaterThanMax),
        ("testSetCrossBoundaryMiddle", testSetCrossBoundaryMiddle),
        ("testSetCrossBoundaryEnd", testSetCrossBoundaryEnd),
        ("testSetCrossBoundaryBeginning", testSetCrossBoundaryBeginning),
        ("testSetMiddle", testSetMiddle),
        ("testSetEnd", testSetEnd),
        ("testSetBeginning", testSetBeginning),
        ("testInitializeLongerThanOneChunk", testInitializeLongerThanOneChunk),
        ("testInitializeShorterThanOneChunk", testInitializeShorterThanOneChunk),
        ("testInitializeOnBoundary", testInitializeOnBoundary),
        ("testInitializeEmpty", testInitializeEmpty)
    ]
}

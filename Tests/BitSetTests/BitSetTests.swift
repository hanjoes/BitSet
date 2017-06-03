import XCTest
@testable import BitSet

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
    
    // MARK: - Test Consecutive Masks
    
    func testLeftConsecutiveMasks() {
        let bs = BitSet<UInt8>(numBits: 8)
        XCTAssertEqual([0x80, 0xC0, 0xE0, 0xF0, 0xF8, 0xFC, 0xFE, 0xFF],
                       bs.leftConsecutiveMasks)
    }
    
    func testRightConsecutiveMasks() {
        let bs = BitSet<UInt8>(numBits: 8)
        XCTAssertEqual([0x01, 0x03, 0x07, 0x0F, 0x1F, 0x3F, 0x7F, 0xFF],
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
        bs.set(range: 0...0)
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
        bs.set(range: 8...8)
        XCTAssertEqual("00000000 00000001", bs.description)
    }
    
    func testSetRangeNextChunkMiddle() {
        let bs = BitSet<UInt8>(numBits: 9)
        bs.set(range: 12...12)
        XCTAssertEqual("00000000 00001000", bs.description)
    }
    
    // MARK: - Registration

    static var allTests = [
        ("testInitializeEmpty", testInitializeEmpty),
        ("testInitializeOnBoundary", testInitializeOnBoundary),
        ("testInitializeShorterThanOneChunk", testInitializeShorterThanOneChunk),
        ("testInitializeLongerThanOneChunk", testInitializeLongerThanOneChunk),
    ]
}

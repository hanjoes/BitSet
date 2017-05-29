import XCTest
@testable import BitSet

class BitSetTests: XCTestCase {
    

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

    static var allTests = [
        ("testInitializeEmpty", testInitializeEmpty),
        ("testInitializeOnBoundary", testInitializeOnBoundary),
        ("testInitializeShorterThanOneChunk", testInitializeShorterThanOneChunk),
        ("testInitializeLongerThanOneChunk", testInitializeLongerThanOneChunk),
    ]
}

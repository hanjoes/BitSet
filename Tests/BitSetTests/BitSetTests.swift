import XCTest
@testable import BitSet

class BitSetTests: XCTestCase {
    func testExample() {
        let bs = BitSet<UInt64>(numBits: 1023)
        print(bs)
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}

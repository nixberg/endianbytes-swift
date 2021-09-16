import EndianBytes
import XCTest

final class EndianBytesTests: XCTestCase {
    func testBigEndian() {
        XCTAssertEqual(UInt32(0x01234567).bigEndianBytes.count, 4)
        XCTAssertEqual(UInt32(0x01234567).bigEndianBytes.endIndex, 4)
        
        XCTAssert(UInt32(0x01234567).bigEndianBytes.elementsEqual([0x01, 0x23, 0x45, 0x67]))
        XCTAssertEqual(UInt32(bigEndianBytes: [0x01, 0x23, 0x45, 0x67]), 0x01234567)
        
        XCTAssertEqual(UInt32(0x01234567).bigEndianBytes.first, 0x01)
        XCTAssertEqual(UInt32(0x01234567).bigEndianBytes.last, 0x67)
    }
    
    func testBigEndianExhaustiveRoundtrip() throws {
        for value in 0...UInt16.max {
            XCTAssertEqual(UInt16(bigEndianBytes: value.bigEndianBytes), value)
        }
        for x in 0...UInt8.max {
            for y in 0...UInt8.max {
                let bytes = [x, y]
                let integer = try XCTUnwrap(UInt16(bigEndianBytes: bytes))
                XCTAssertEqual(integer, UInt16(x) << 8 + UInt16(y))
                XCTAssert(integer.bigEndianBytes.elementsEqual(bytes))
            }
        }
    }
    
    func testLittleEndian() {
        XCTAssertEqual(UInt32(0x01234567).littleEndianBytes.count, 4)
        XCTAssertEqual(UInt32(0x01234567).littleEndianBytes.endIndex, 4)
        
        XCTAssert(UInt32(0x01234567).littleEndianBytes.elementsEqual([0x67, 0x45, 0x23, 0x01]))
        XCTAssertEqual(UInt32(littleEndianBytes: [0x67, 0x45, 0x23, 0x01]), 0x01234567)
        
        XCTAssertEqual(UInt32(0x01234567).littleEndianBytes.first, 0x67)
        XCTAssertEqual(UInt32(0x01234567).littleEndianBytes.last, 0x01)
    }
    
    func testLittleEndianExhaustiveRoundtrip() throws {
        for value in 0...UInt16.max {
            XCTAssertEqual(UInt16(littleEndianBytes: value.littleEndianBytes), value)
        }
        for x in 0...UInt8.max {
            for y in 0...UInt8.max {
                let bytes = [x, y]
                let integer = try XCTUnwrap(UInt16(littleEndianBytes: bytes))
                XCTAssertEqual(integer, UInt16(y) << 8 + UInt16(x))
                XCTAssert(integer.littleEndianBytes.elementsEqual(bytes))
            }
        }
    }
}

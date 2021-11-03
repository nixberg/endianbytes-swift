import EndianBytes
import XCTest

final class EndianBytesTests: XCTestCase {
    func testBigEndian() {
        XCTAssertEqual(UInt32(0x0123_4567).bigEndianBytes().count, 4)
        XCTAssertEqual(UInt32(0x0123_4567).bigEndianBytes().endIndex, 4)
        
        XCTAssert(UInt32(0x0123_4567).bigEndianBytes().elementsEqual([0x01, 0x23, 0x45, 0x67]))
        XCTAssertEqual(UInt32(bigEndianBytes: [0x01, 0x23, 0x45, 0x67]), 0x0123_4567)
        
        XCTAssertEqual(UInt32(0x0123_4567).bigEndianBytes().first, 0x01)
        XCTAssertEqual(UInt32(0x0123_4567).bigEndianBytes().last, 0x67)
        
        XCTAssertEqual(UInt8(0x01).bigEndianBytes(),
                       Array(UInt8(0x01).bigEndianBytes()))
        XCTAssertEqual(UInt16(0x0123).bigEndianBytes(),
                       Array(UInt16(0x0123).bigEndianBytes()))
        XCTAssertEqual(UInt32(0x0123_4567).bigEndianBytes(),
                       Array(UInt32(0x0123_4567).bigEndianBytes()))
        XCTAssertEqual(UInt64(0x0123_4567_89ab_cdef).bigEndianBytes(),
                       Array(UInt64(0x0123_4567_89ab_cdef).bigEndianBytes()))
    }
    
    func testBigEndianExhaustiveRoundtrip() throws {
        for value in 0...UInt16.max {
            XCTAssertEqual(UInt16(bigEndianBytes: value.bigEndianBytes()), value)
        }
        for x in 0...UInt8.max {
            for y in 0...UInt8.max {
                let bytes = [x, y]
                let integer = try XCTUnwrap(UInt16(bigEndianBytes: bytes))
                XCTAssertEqual(integer, UInt16(x) << 8 + UInt16(y))
                XCTAssert(integer.bigEndianBytes().elementsEqual(bytes))
            }
        }
    }
    
    func testLittleEndian() {
        XCTAssertEqual(UInt32(0x0123_4567).littleEndianBytes().count, 4)
        XCTAssertEqual(UInt32(0x0123_4567).littleEndianBytes().endIndex, 4)
        
        XCTAssert(UInt32(0x0123_4567).littleEndianBytes().elementsEqual([0x67, 0x45, 0x23, 0x01]))
        XCTAssertEqual(UInt32(littleEndianBytes: [0x67, 0x45, 0x23, 0x01]), 0x0123_4567)
        
        XCTAssertEqual(UInt32(0x0123_4567).littleEndianBytes().first, 0x67)
        XCTAssertEqual(UInt32(0x0123_4567).littleEndianBytes().last, 0x01)
        
        XCTAssertEqual(UInt8(0x01).littleEndianBytes(),
                       Array(UInt8(0x01).littleEndianBytes()))
        XCTAssertEqual(UInt16(0x0123).littleEndianBytes(),
                       Array(UInt16(0x0123).littleEndianBytes()))
        XCTAssertEqual(UInt32(0x0123_4567).littleEndianBytes(),
                       Array(UInt32(0x0123_4567).littleEndianBytes()))
        XCTAssertEqual(UInt64(0x0123_4567_89ab_cdef).littleEndianBytes(),
                       Array(UInt64(0x0123_4567_89ab_cdef).littleEndianBytes()))
    }
    
    func testLittleEndianExhaustiveRoundtrip() throws {
        for value in 0...UInt16.max {
            XCTAssertEqual(UInt16(littleEndianBytes: value.littleEndianBytes()), value)
        }
        for x in 0...UInt8.max {
            for y in 0...UInt8.max {
                let bytes = [x, y]
                let integer = try XCTUnwrap(UInt16(littleEndianBytes: bytes))
                XCTAssertEqual(integer, UInt16(y) << 8 + UInt16(x))
                XCTAssert(integer.littleEndianBytes().elementsEqual(bytes))
            }
        }
    }
}

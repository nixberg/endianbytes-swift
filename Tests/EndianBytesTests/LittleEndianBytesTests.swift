import EndianBytes
import XCTest

final class LittleEndianBytesTests: XCTestCase {
    func testUInt8() {
        testUIntX(value: 0x01 as UInt8, bytes: [0x01])
    }
    
    func testUInt16() {
        testUIntX(value: 0x0123 as UInt16, bytes: [0x23, 0x01])
    }
    
    func testUInt32() {
        testUIntX(value: 0x0123_4567 as UInt32, bytes: [0x67, 0x45, 0x23, 0x01])
    }
    
    func testUInt64() {
        testUIntX(value: 0x0123_4567_89ab_cdef as UInt64, bytes: [
            0xef, 0xcd, 0xab, 0x89, 0x67, 0x45, 0x23, 0x01
        ])
    }
    
    func testExhaustiveRoundtrip() throws {
        for value in 0...UInt16.max {
            XCTAssertEqual(UInt16(littleEndianBytes: value.littleEndianBytes()), value)
        }
        for x in 0...UInt8.max {
            for y in 0...UInt8.max {
                let bytes = [x, y]
                let value = try XCTUnwrap(UInt16(littleEndianBytes: bytes))
                XCTAssertEqual(value, UInt16(y) << 8 + UInt16(x))
                XCTAssert(value.littleEndianBytes().elementsEqual(bytes))
            }
        }
    }
}

fileprivate func testUIntX<T: TestedInteger>(value: T, bytes: [UInt8], line: UInt = #line) {
    XCTAssertEqual(value.littleEndianBytes().count, bytes.count, line: line)
    XCTAssertEqual(value.littleEndianBytes().startIndex, bytes.startIndex, line: line)
    XCTAssertEqual(value.littleEndianBytes().endIndex, bytes.endIndex, line: line)
    
    XCTAssert(value.littleEndianBytes().elementsEqual(bytes), line: line)
    XCTAssertEqual(.init(littleEndianBytes: bytes), value, line: line)
    
    XCTAssertEqual(value.littleEndianBytes().first as UInt8, bytes.first, line: line)
    XCTAssertEqual(value.littleEndianBytes().last as UInt8, bytes.last, line: line)
    
    let a = value.littleEndianBytes().first
    print(a)
}

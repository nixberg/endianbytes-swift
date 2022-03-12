import EndianBytes
import XCTest

final class BigEndianBytesTests: XCTestCase {
    func testUInt8() {
        testUIntX(value: 0x01 as UInt8, bytes: [0x01])
    }
    
    func testUInt16() {
        testUIntX(value: 0x0123 as UInt16, bytes: [0x01, 0x23])
    }
    
    func testUInt32() {
        testUIntX(value: 0x0123_4567 as UInt32, bytes: [0x01, 0x23, 0x45, 0x67])
    }
    
    func testUInt64() {
        testUIntX(value: 0x0123_4567_89ab_cdef as UInt64, bytes: [
            0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef
        ])
    }
    
    func testExhaustiveRoundtrip() throws {
        for value in 0...UInt16.max {
            XCTAssertEqual(UInt16(bigEndianBytes: value.bigEndianBytes()), value)
        }
        for x in 0...UInt8.max {
            for y in 0...UInt8.max {
                let bytes = [x, y]
                let value = try XCTUnwrap(UInt16(bigEndianBytes: bytes))
                XCTAssertEqual(value, UInt16(x) << 8 + UInt16(y))
                XCTAssert(value.bigEndianBytes().elementsEqual(bytes))
            }
        }
    }
}

fileprivate func testUIntX<T: TestedInteger>(value: T, bytes: [UInt8], line: UInt = #line) {
    XCTAssertEqual(value.bigEndianBytes().count, bytes.count, line: line)
    XCTAssertEqual(value.bigEndianBytes().startIndex, bytes.startIndex, line: line)
    XCTAssertEqual(value.bigEndianBytes().endIndex, bytes.endIndex, line: line)
    
    XCTAssert(value.bigEndianBytes().elementsEqual(bytes), line: line)
    XCTAssertEqual(.init(bigEndianBytes: bytes), value, line: line)
    
    XCTAssertEqual(value.bigEndianBytes().first as UInt8, bytes.first, line: line)
    XCTAssertEqual(value.bigEndianBytes().last as UInt8, bytes.last, line: line)
}

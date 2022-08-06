import EndianBytes
import XCTest

final class BigEndianBytesTests: XCTestCase {
    func testInt8() {
        testInteger(ofType: Int8.self, value: +0x01, bytes: [0x01])
        testInteger(ofType: Int8.self, value: -0x01, bytes: [0xff])
    }
    
    func testInt16() {
        testInteger(ofType: Int16.self, value: +0x0123, bytes: [0x01, 0x23])
        testInteger(ofType: Int16.self, value: -0x0123, bytes: [0xfe, 0xdd])
    }
    
    func testInt32() {
        testInteger(ofType: Int32.self, value: +0x0123_4567, bytes: [0x01, 0x23, 0x45, 0x67])
        testInteger(ofType: Int32.self, value: -0x0123_4567, bytes: [0xfe, 0xdc, 0xba, 0x99])
    }
    
    func testInt64() {
        testInteger(ofType: Int64.self, value: +0x0123_4567_89ab_cdef, bytes: [
            0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef
        ])
        testInteger(ofType: Int64.self, value: -0x0123_4567_89ab_cdef, bytes: [
            0xfe, 0xdc, 0xba, 0x98, 0x76, 0x54, 0x32, 0x11
        ])
    }
    
    func testUInt8() {
        testInteger(ofType: UInt8.self, value: 0x01, bytes: [0x01])
    }
    
    func testUInt16() {
        testInteger(ofType: UInt16.self, value: 0x0123, bytes: [0x01, 0x23])
    }
    
    func testUInt32() {
        testInteger(ofType: UInt32.self, value: 0x0123_4567, bytes: [0x01, 0x23, 0x45, 0x67])
    }
    
    func testUInt64() {
        testInteger(ofType: UInt64.self, value: 0x0123_4567_89ab_cdef, bytes: [
            0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef
        ])
    }
    
    func testExhaustiveRoundtripInt16() throws {
        for value in Int16.min...Int16.max {
            XCTAssertEqual(Int16(bigEndianBytes: value.bigEndianBytes()), value)
        }
        for x in 0...UInt8.max {
            for y in 0...UInt8.max {
                let bytes = [x, y]
                let value = try XCTUnwrap(Int16(bigEndianBytes: bytes))
                XCTAssertEqual(value, Int16(x) << 8 + Int16(y))
                XCTAssert(value.bigEndianBytes().elementsEqual(bytes))
            }
        }
    }
    
    func testExhaustiveRoundtripUInt16() throws {
        for value in UInt16.min...UInt16.max {
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

fileprivate func testInteger<T>(
    ofType type: T.Type,
    value: T,
    bytes: [UInt8],
    line: UInt = #line
) where T: EndianBytesProtocol & FixedWidthInteger {
    XCTAssertEqual(value.bigEndianBytes().count, bytes.count, line: line)
    XCTAssertEqual(value.bigEndianBytes().startIndex, bytes.startIndex, line: line)
    XCTAssertEqual(value.bigEndianBytes().endIndex, bytes.endIndex, line: line)
    
    XCTAssert(value.bigEndianBytes().elementsEqual(bytes), line: line)
    XCTAssertEqual(.init(bigEndianBytes: bytes), value, line: line)
    
    XCTAssertEqual(value.bigEndianBytes().first as UInt8, bytes.first, line: line)
    XCTAssertEqual(value.bigEndianBytes().last as UInt8, bytes.last, line: line)
}

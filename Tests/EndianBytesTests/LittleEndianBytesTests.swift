import EndianBytes
import XCTest

final class LittleEndianBytesTests: XCTestCase {
    func testInt8() {
        testInteger(ofType: Int8.self, value: +0x01, bytes: [0x01])
        testInteger(ofType: Int8.self, value: -0x01, bytes: [0xff])
    }
    
    func testInt16() {
        testInteger(ofType: Int16.self, value: +0x0123, bytes: [0x23, 0x01])
        testInteger(ofType: Int16.self, value: -0x0123, bytes: [0xdd, 0xfe])
    }
    
    func testInt32() {
        testInteger(ofType: Int32.self, value: +0x0123_4567, bytes: [0x67, 0x45, 0x23, 0x01])
        testInteger(ofType: Int32.self, value: -0x0123_4567, bytes: [0x99, 0xba, 0xdc, 0xfe])
    }
    
    func testInt64() {
        testInteger(ofType: Int64.self, value: +0x0123_4567_89ab_cdef, bytes: [
            0xef, 0xcd, 0xab, 0x89, 0x67, 0x45, 0x23, 0x01
        ])
        testInteger(ofType: Int64.self, value: -0x0123_4567_89ab_cdef, bytes: [
            0x11, 0x32, 0x54, 0x76, 0x98, 0xba, 0xdc, 0xfe
        ])
    }
    
    func testUInt8() {
        testInteger(ofType: UInt8.self, value: 0x01, bytes: [0x01])
    }
    
    func testUInt16() {
        testInteger(ofType: UInt16.self, value: 0x0123, bytes: [0x23, 0x01])
    }
    
    func testUInt32() {
        testInteger(ofType: UInt32.self, value: 0x0123_4567, bytes: [0x67, 0x45, 0x23, 0x01])
    }
    
    func testUInt64() {
        testInteger(ofType: UInt64.self, value: 0x0123_4567_89ab_cdef, bytes: [
            0xef, 0xcd, 0xab, 0x89, 0x67, 0x45, 0x23, 0x01
        ])
    }
    
    func testExhaustiveRoundtripInt16() throws {
        for value in Int16.min...Int16.max {
            XCTAssertEqual(Int16(littleEndianBytes: value.littleEndianBytes()), value)
        }
        for x in 0...UInt8.max {
            for y in 0...UInt8.max {
                let bytes = [x, y]
                let value = try XCTUnwrap(Int16(littleEndianBytes: bytes))
                XCTAssertEqual(value, Int16(y) << 8 + Int16(x))
                XCTAssert(value.littleEndianBytes().elementsEqual(bytes))
            }
        }
    }
    
    func testExhaustiveRoundtripUInt16() throws {
        for value in UInt16.min...UInt16.max {
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

fileprivate func testInteger<T>(
    ofType type: T.Type,
    value: T,
    bytes: [UInt8],
    line: UInt = #line
) where T: EndianBytesProtocol & FixedWidthInteger {
    XCTAssertEqual(value.littleEndianBytes().count, bytes.count, line: line)
    XCTAssertEqual(value.littleEndianBytes().startIndex, bytes.startIndex, line: line)
    XCTAssertEqual(value.littleEndianBytes().endIndex, bytes.endIndex, line: line)
    
    XCTAssert(value.littleEndianBytes().elementsEqual(bytes), line: line)
    XCTAssertEqual(.init(littleEndianBytes: bytes), value, line: line)
    
    XCTAssertEqual(value.littleEndianBytes().first as UInt8, bytes.first, line: line)
    XCTAssertEqual(value.littleEndianBytes().last as UInt8, bytes.last, line: line)
}

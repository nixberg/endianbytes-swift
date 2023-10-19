import EndianBytes
import XCTest

final class LittleEndianBytesTests: XCTestCase {
    func testInt8() {
        testInteger(+0x01 as Int8, bytes: [0x01])
        testInteger(-0x01 as Int8, bytes: [0xff])
    }
    
    func testInt16() {
        testInteger(+0x0123 as Int16, bytes: [0x23, 0x01])
        testInteger(-0x0123 as Int16, bytes: [0xdd, 0xfe])
    }
    
    func testInt32() {
        testInteger(+0x0123_4567 as Int32, bytes: [0x67, 0x45, 0x23, 0x01])
        testInteger(-0x0123_4567 as Int32, bytes: [0x99, 0xba, 0xdc, 0xfe])
    }
    
    func testInt64() {
        testInteger(+0x0123_4567_89ab_cdef as Int64, bytes: [
            0xef, 0xcd, 0xab, 0x89, 0x67, 0x45, 0x23, 0x01
        ])
        testInteger(-0x0123_4567_89ab_cdef as Int64, bytes: [
            0x11, 0x32, 0x54, 0x76, 0x98, 0xba, 0xdc, 0xfe
        ])
    }
    
    func testUInt8() {
        testInteger(0x01 as UInt8, bytes: [0x01])
    }
    
    func testUInt16() {
        testInteger(0x0123 as UInt16, bytes: [0x23, 0x01])
    }
    
    func testUInt32() {
        testInteger(0x0123_4567 as UInt32, bytes: [0x67, 0x45, 0x23, 0x01])
    }
    
    func testUInt64() {
        testInteger(0x0123_4567_89ab_cdef as UInt64, bytes: [
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
                let value = Int16(littleEndianBytes: bytes)
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
                let value = UInt16(littleEndianBytes: bytes)
                XCTAssertEqual(value, UInt16(y) << 8 + UInt16(x))
                XCTAssert(value.littleEndianBytes().elementsEqual(bytes))
            }
        }
    }
}

fileprivate func testInteger(_ value: some FixedWidthInteger, bytes: [UInt8], line: UInt = #line) {
    XCTAssertEqual(value.littleEndianBytes().count, bytes.count, line: line)
    XCTAssertEqual(value.littleEndianBytes().startIndex, bytes.startIndex, line: line)
    XCTAssertEqual(value.littleEndianBytes().endIndex, bytes.endIndex, line: line)
    
    XCTAssert(value.littleEndianBytes().elementsEqual(bytes), line: line)
    XCTAssertEqual(.init(littleEndianBytes: bytes), value, line: line)
    
    XCTAssertEqual(value.littleEndianBytes().first as UInt8, bytes.first, line: line)
    XCTAssertEqual(value.littleEndianBytes().last as UInt8, bytes.last, line: line)
}


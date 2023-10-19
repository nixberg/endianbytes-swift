import EndianBytesSIMD
import XCTest

final class SIMDLittleEndianBytesTests: XCTestCase {
    func testSIMD2() {
        testVector(SIMD2(0x0123, 0x4567), bytes: [0x23, 0x01, 0x67, 0x45])
    }
    
    func testSIMD3() {
        testVector(SIMD3(0x0123, 0x4567, 0x89ab), bytes: [0x23, 0x01, 0x67, 0x45, 0xab, 0x89])
    }
    
    func testSIMD4() {
        testVector(SIMD4(0x0123, 0x4567, 0x89ab, 0xcdef), bytes: [
            0x23, 0x01, 0x67, 0x45, 0xab, 0x89, 0xef, 0xcd
        ])
    }
    
    func testRandomRoundtrip() throws {
        for _ in 0..<1024 {
            let value: SIMD2 = .random(in: UInt16.min...UInt16.max)
            XCTAssertEqual(SIMD2(littleEndianBytes: value.littleEndianBytes()), value)
        }
        for _ in 0..<1024 {
            let bytes: [UInt8] = .random(ofCount: 4)
            let vector: SIMD2<UInt16> = try XCTUnwrap(SIMD2(littleEndianBytes: bytes))
            XCTAssert(vector.littleEndianBytes().elementsEqual(bytes))
        }
    }
}

fileprivate func testVector(_ value: some SIMD<UInt16>, bytes: [UInt8], line: UInt = #line) {
    XCTAssertEqual(value.littleEndianBytes().count, bytes.count, line: line)
    XCTAssertEqual(value.littleEndianBytes().startIndex, bytes.startIndex, line: line)
    XCTAssertEqual(value.littleEndianBytes().endIndex, bytes.endIndex, line: line)
    
    XCTAssert(value.littleEndianBytes().elementsEqual(bytes), line: line)
    XCTAssertEqual(.init(littleEndianBytes: bytes), value, line: line)
    
    XCTAssertEqual(value.littleEndianBytes().first as UInt8, bytes.first, line: line)
    XCTAssertEqual(value.littleEndianBytes().last as UInt8, bytes.last, line: line)
}

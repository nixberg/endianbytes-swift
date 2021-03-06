import EndianBytes
import XCTest

final class SIMDBigEndianBytesTests: XCTestCase {
    func testSIMD2() {
        testSIMDX(value: [0x0123, 0x4567] as SIMD2<UInt16>, bytes: [0x01, 0x23, 0x45, 0x67])
    }
    
    func testSIMD3() {
        testSIMDX(value: [0x0123, 0x4567, 0x89ab] as SIMD3<UInt16>, bytes: [
            0x01, 0x23, 0x45, 0x67, 0x89, 0xab
        ])
    }
    
    func testSIMD4() {
        testSIMDX(value: [0x0123, 0x4567, 0x89ab, 0xcdef] as SIMD4<UInt16>, bytes: [
            0x01, 0x23, 0x45, 0x67, 0x89, 0xab, 0xcd, 0xef
        ])
    }
    
    func testRandomRoundtrip() throws {
        for _ in 0..<1024 {
            let value: SIMD2 = .random(in: 0...UInt16.max)
            XCTAssertEqual(SIMD2(bigEndianBytes: value.bigEndianBytes()), value)
        }
        for _ in 0..<1024 {
            var rng = SystemRandomNumberGenerator()
            let bytes: [UInt8] = (0..<4).map { _ in rng.next() }
            let vector: SIMD2<UInt16> = try XCTUnwrap(SIMD2(bigEndianBytes: bytes))
            XCTAssert(vector.bigEndianBytes().elementsEqual(bytes))
        }
    }
}

fileprivate func testSIMDX<T: TestedVector>(value: T, bytes: [UInt8], line: UInt = #line) {
    XCTAssertEqual(value.bigEndianBytes().count, bytes.count, line: line)
    XCTAssertEqual(value.bigEndianBytes().startIndex, bytes.startIndex, line: line)
    XCTAssertEqual(value.bigEndianBytes().endIndex, bytes.endIndex, line: line)
    
    XCTAssert(value.bigEndianBytes().elementsEqual(bytes), line: line)
    XCTAssertEqual(.init(bigEndianBytes: bytes), value, line: line)
    
    XCTAssertEqual(value.bigEndianBytes().first as UInt8, bytes.first, line: line)
    XCTAssertEqual(value.bigEndianBytes().last as UInt8, bytes.last, line: line)
}

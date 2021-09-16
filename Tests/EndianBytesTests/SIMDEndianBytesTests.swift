import EndianBytes
import XCTest

final class SIMDEndianBytesTests: XCTestCase {
    func testSIMDBigEndian() {
        let vector = SIMD2<UInt16>(0x0123, 0x4567)
        
        XCTAssertEqual(vector.bigEndianBytes.count, 4)
        XCTAssertEqual(vector.bigEndianBytes.endIndex, 4)
        
        XCTAssert(vector.bigEndianBytes.elementsEqual([0x01, 0x23, 0x45, 0x67]))
        XCTAssertEqual(SIMD2<UInt16>(bigEndianBytes: [0x01, 0x23, 0x45, 0x67]), vector)
        
        XCTAssertEqual(vector.bigEndianBytes.first, 0x01)
        XCTAssertEqual(vector.bigEndianBytes.last, 0x67)
    }
    
    func testSIMDBigEndianRandomRoundtrip() throws {
        for _ in 0..<1024 {
            let value: SIMD2 = .random(in: 0...UInt16.max)
            XCTAssertEqual(SIMD2(bigEndianBytes: value.bigEndianBytes), value)
        }
        for _ in 0..<1024 {
            var rng = SystemRandomNumberGenerator()
            let bytes: [UInt8] = (0..<4).map { _ in rng.next() }
            let vector: SIMD2<UInt16> = try XCTUnwrap(SIMD2(bigEndianBytes: bytes))
            XCTAssert(vector.bigEndianBytes.elementsEqual(bytes))
        }
    }
    
    func testSIMDLittleEndian() {
        let vector = SIMD2<UInt16>(0x0123, 0x4567)
        
        XCTAssertEqual(vector.littleEndianBytes.count, 4)
        XCTAssertEqual(vector.littleEndianBytes.endIndex, 4)
        
        XCTAssert(vector.littleEndianBytes.elementsEqual([0x23, 0x01, 0x67, 0x45]))
        XCTAssertEqual(SIMD2<UInt16>(littleEndianBytes: [0x23, 0x01, 0x67, 0x45]), vector)
        
        XCTAssertEqual(vector.littleEndianBytes.first, 0x23)
        XCTAssertEqual(vector.littleEndianBytes.last, 0x45)
    }
    
    func testSIMDLittleEndianRandomRoundtrip() throws {
        for _ in 0..<1024 {
            let value: SIMD2 = .random(in: 0...UInt16.max)
            XCTAssertEqual(SIMD2(littleEndianBytes: value.littleEndianBytes), value)
        }
        for _ in 0..<1024 {
            var rng = SystemRandomNumberGenerator()
            let bytes: [UInt8] = (0..<4).map { _ in rng.next() }
            let vector: SIMD2<UInt16> = try XCTUnwrap(SIMD2(littleEndianBytes: bytes))
            XCTAssert(vector.littleEndianBytes.elementsEqual(bytes))
        }
    }
}

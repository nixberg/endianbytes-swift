import Algorithms

public extension SIMD where Scalar: FixedWidthInteger & EndianBytes {
    typealias BigEndianBytesSequence = SIMDBigEndianBytes<Self>
    
    typealias LittleEndianBytesSequence = SIMDLittleEndianBytes<Self>
    
    init?<Bytes>(bigEndianBytes bytes: Bytes) where Bytes: Sequence, Bytes.Element == UInt8 {
        self.init(bigEndianBytes: Array(bytes))
    }
    
    init?<Bytes>(littleEndianBytes bytes: Bytes) where Bytes: Sequence, Bytes.Element == UInt8 {
        self.init(littleEndianBytes: Array(bytes))
    }
    
    init?<Bytes>(bigEndianBytes bytes: Bytes) where Bytes: Collection, Bytes.Element == UInt8 {
        precondition(Scalar.bitWidth.isMultiple(of: 8))
        var result: Self = .zero
        for (i, chunk) in zip(result.indices, bytes.chunks(ofCount: Scalar.bitWidth / 8)) {
            guard let scalar = Scalar(bigEndianBytes: chunk) else {
                return nil
            }
            result[i] = scalar
        }
        self = result
    }
    
    init?<Bytes>(littleEndianBytes bytes: Bytes) where Bytes: Collection, Bytes.Element == UInt8 {
        precondition(Scalar.bitWidth.isMultiple(of: 8))
        var result: Self = .zero
        for (i, chunk) in zip(result.indices, bytes.chunks(ofCount: Scalar.bitWidth / 8)) {
            guard let scalar = Scalar(littleEndianBytes: chunk) else {
                return nil
            }
            result[i] = scalar
        }
        self = result
    }
    
    func bigEndianBytes() -> SIMDBigEndianBytes<Self> {
        SIMDBigEndianBytes(value: self)
    }
    
    func littleEndianBytes() -> SIMDLittleEndianBytes<Self> {
        SIMDLittleEndianBytes(value: self)
    }
    
    @_disfavoredOverload
    func bigEndianBytes() -> [UInt8] {
        Array(self.bigEndianBytes())
    }
    
    @_disfavoredOverload
    func littleEndianBytes() -> [UInt8] {
        Array(self.littleEndianBytes())
    }
}

extension SIMD2:  EndianBytes where Scalar: FixedWidthInteger & EndianBytes {}
extension SIMD3:  EndianBytes where Scalar: FixedWidthInteger & EndianBytes {}
extension SIMD4:  EndianBytes where Scalar: FixedWidthInteger & EndianBytes {}
extension SIMD8:  EndianBytes where Scalar: FixedWidthInteger & EndianBytes {}
extension SIMD16: EndianBytes where Scalar: FixedWidthInteger & EndianBytes {}
extension SIMD32: EndianBytes where Scalar: FixedWidthInteger & EndianBytes {}
extension SIMD64: EndianBytes where Scalar: FixedWidthInteger & EndianBytes {}

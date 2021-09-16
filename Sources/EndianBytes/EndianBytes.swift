import Algorithms

public extension FixedWidthInteger where Self: UnsignedInteger {
    init?<Bytes>(bigEndianBytes bytes: Bytes) where Bytes: Collection, Bytes.Element == UInt8 {
        precondition(Self.bitWidth.isMultiple(of: 8))
        guard bytes.count == Self.bitWidth / 8 else {
            return nil
        }
        self = bytes.reduce(0, { $0 << 8 | Self($1) })
    }
    
    init?<Bytes>(littleEndianBytes bytes: Bytes) where Bytes: Collection, Bytes.Element == UInt8 {
        precondition(Self.bitWidth.isMultiple(of: 8))
        guard bytes.count == Self.bitWidth / 8 else {
            return nil
        }
        self = bytes.reversed().reduce(0, { $0 << 8 | Self($1) })
    }
    
    var bigEndianBytes: BigEndianBytes<Self> {
        BigEndianBytes(value: self)
    }
    
    var littleEndianBytes: LittleEndianBytes<Self> {
        LittleEndianBytes(value: self)
    }
}

public extension SIMD where Scalar: FixedWidthInteger & UnsignedInteger {
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
    
    var bigEndianBytes: SIMDBigEndianBytes<Self> {
        SIMDBigEndianBytes(value: self)
    }
    
    var littleEndianBytes: SIMDLittleEndianBytes<Self> {
        SIMDLittleEndianBytes(value: self)
    }
}

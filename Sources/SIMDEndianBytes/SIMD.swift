import EndianBytes

extension SIMD where Scalar: EndianBytesProtocol & FixedWidthInteger {
    public typealias BigEndianBytesSequence = SIMDBigEndianBytes<Self>
    
    public typealias LittleEndianBytesSequence = SIMDLittleEndianBytes<Self>
    
    public init<Bytes>(bigEndianBytes bytes: Bytes)
    where Bytes: Sequence, Bytes.Element == UInt8 {
        var accumulatedBits = 0
        self = bytes.reduce(into: .zero) {
            $0[accumulatedBits / Self.Scalar.bitWidth] <<= 8
            $0[accumulatedBits / Self.Scalar.bitWidth] |= Self.Scalar(truncatingIfNeeded: $1)
            accumulatedBits += 8
        }
        precondition(accumulatedBits == Self.scalarCount * Self.Scalar.bitWidth)
    }
    
    public init<Bytes>(littleEndianBytes bytes: Bytes)
    where Bytes: Sequence, Bytes.Element == UInt8 {
        self = Self(bigEndianBytes: bytes).byteSwapped
    }
    
    public func bigEndianBytes() -> Self.BigEndianBytesSequence {
        .init(self)
    }
    
    public func littleEndianBytes() -> Self.LittleEndianBytesSequence {
        .init(self)
    }
}

extension SIMD2:  EndianBytesProtocol where Scalar: EndianBytesProtocol & FixedWidthInteger {}
extension SIMD3:  EndianBytesProtocol where Scalar: EndianBytesProtocol & FixedWidthInteger {}
extension SIMD4:  EndianBytesProtocol where Scalar: EndianBytesProtocol & FixedWidthInteger {}
extension SIMD8:  EndianBytesProtocol where Scalar: EndianBytesProtocol & FixedWidthInteger {}
extension SIMD16: EndianBytesProtocol where Scalar: EndianBytesProtocol & FixedWidthInteger {}
extension SIMD32: EndianBytesProtocol where Scalar: EndianBytesProtocol & FixedWidthInteger {}
extension SIMD64: EndianBytesProtocol where Scalar: EndianBytesProtocol & FixedWidthInteger {}

extension SIMD {
    @inline(__always)
    var first: Self.Scalar {
        self[indices.startIndex]
    }
    
    @inline(__always)
    var last: Self.Scalar {
        self[indices.index(before: indices.endIndex)]
    }
}

fileprivate extension SIMD where Scalar: FixedWidthInteger {
    var byteSwapped: Self {
        var result: Self = .zero
        for i in indices {
            result[i] = self[i].byteSwapped
        }
        return result
    }
}

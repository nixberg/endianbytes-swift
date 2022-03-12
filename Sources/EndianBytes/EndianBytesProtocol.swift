import Algorithms

public protocol EndianBytesProtocol {
    associatedtype BigEndianBytesSequence: Sequence
    where BigEndianBytesSequence.Element == UInt8
    
    associatedtype LittleEndianBytesSequence: Sequence
    where LittleEndianBytesSequence.Element == UInt8
    
    init<Bytes>(bigEndianBytes bytes: Bytes)
    where Bytes: Sequence, Bytes.Element == UInt8
    
    init<Bytes>(littleEndianBytes bytes: Bytes)
    where Bytes: Sequence, Bytes.Element == UInt8
    
    func bigEndianBytes() -> BigEndianBytesSequence
    
    func littleEndianBytes() -> LittleEndianBytesSequence
}

public extension FixedWidthInteger where Self: UnsignedInteger {
    typealias BigEndianBytesSequence = BigEndianBytes<Self>
    
    typealias LittleEndianBytesSequence = LittleEndianBytes<Self>
    
    init<Bytes>(bigEndianBytes bytes: Bytes) where Bytes: Sequence, Bytes.Element == UInt8 {
        var accumulatedBits = 0
        self = bytes.reduce(0) {
            accumulatedBits += 8
            return ($0 << 8) | Self(truncatingIfNeeded: $1)
        }
        precondition(accumulatedBits == Self.bitWidth)
    }
    
    init<Bytes>(littleEndianBytes bytes: Bytes) where Bytes: Sequence, Bytes.Element == UInt8 {
        self = Self(bigEndianBytes: bytes).byteSwapped
    }
    
    func bigEndianBytes() -> Self.BigEndianBytesSequence {
        .init(self)
    }
    
    func littleEndianBytes() -> Self.LittleEndianBytesSequence {
        .init(self)
    }
}

extension UInt8: EndianBytesProtocol {
    public typealias BigEndianBytesSequence = CollectionOfOne<Self>
    
    public typealias LittleEndianBytesSequence = CollectionOfOne<Self>
    
    public func bigEndianBytes() -> Self.BigEndianBytesSequence {
        .init(self)
    }
    
    public func littleEndianBytes() -> Self.LittleEndianBytesSequence {
        .init(self)
    }
}

extension UInt16: EndianBytesProtocol {}
extension UInt32: EndianBytesProtocol {}
extension UInt64: EndianBytesProtocol {}

public extension SIMD where Scalar: FixedWidthInteger & UnsignedInteger & EndianBytesProtocol {
    typealias BigEndianBytesSequence = SIMDBigEndianBytes<Self>
    
    typealias LittleEndianBytesSequence = SIMDLittleEndianBytes<Self>
    
    init<Bytes>(bigEndianBytes bytes: Bytes) where Bytes: Sequence, Bytes.Element == UInt8 {
        self.init(bigEndianBytes: Array(bytes))
    }
    
    init<Bytes>(littleEndianBytes bytes: Bytes) where Bytes: Sequence, Bytes.Element == UInt8 {
        self.init(littleEndianBytes: Array(bytes))
    }
    
    init<Bytes>(bigEndianBytes bytes: Bytes) where Bytes: Collection, Bytes.Element == UInt8 {
        self = .zero
        var accumulatedBits = 0
        for (i, chunk) in zip(indices, bytes.chunks(ofCount: Self.Scalar.bitWidth / 8)) {
            self[i] = .init(bigEndianBytes: chunk)
            accumulatedBits += Self.Scalar.bitWidth
        }
        // TODO: What about extra bytes?
        precondition(accumulatedBits == Self.scalarCount * Self.Scalar.bitWidth)
    }
    
    init<Bytes>(littleEndianBytes bytes: Bytes) where Bytes: Collection, Bytes.Element == UInt8 {
        self = .zero
        var accumulatedBits = 0
        for (i, chunk) in zip(indices, bytes.chunks(ofCount: Self.Scalar.bitWidth / 8)) {
            self[i] = .init(littleEndianBytes: chunk)
            accumulatedBits += Self.Scalar.bitWidth
        }
        // TODO: What about extra bytes?
        precondition(accumulatedBits == Self.scalarCount * Self.Scalar.bitWidth)
    }
    
    func bigEndianBytes() -> Self.BigEndianBytesSequence {
        .init(self)
    }
    
    func littleEndianBytes() -> Self.LittleEndianBytesSequence {
        .init(self)
    }
}

extension SIMD2: EndianBytesProtocol
where Scalar: FixedWidthInteger & UnsignedInteger & EndianBytesProtocol {}
extension SIMD3: EndianBytesProtocol
where Scalar: FixedWidthInteger & UnsignedInteger & EndianBytesProtocol {}
extension SIMD4: EndianBytesProtocol
where Scalar: FixedWidthInteger & UnsignedInteger & EndianBytesProtocol {}
extension SIMD8: EndianBytesProtocol
where Scalar: FixedWidthInteger & UnsignedInteger & EndianBytesProtocol {}
extension SIMD16: EndianBytesProtocol
where Scalar: FixedWidthInteger & UnsignedInteger & EndianBytesProtocol {}
extension SIMD32: EndianBytesProtocol
where Scalar: FixedWidthInteger & UnsignedInteger & EndianBytesProtocol {}
extension SIMD64: EndianBytesProtocol
where Scalar: FixedWidthInteger & UnsignedInteger & EndianBytesProtocol {}

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

public extension FixedWidthInteger where Self: UnsignedInteger {
    typealias BigEndianBytesSequence = BigEndianBytes<Self>
    
    typealias LittleEndianBytesSequence = LittleEndianBytes<Self>
    
    init?<Bytes>(bigEndianBytes bytes: Bytes) where Bytes: Sequence, Bytes.Element == UInt8 {
        self.init(bigEndianBytes: Array(bytes))
    }
    
    init?<Bytes>(littleEndianBytes bytes: Bytes) where Bytes: Sequence, Bytes.Element == UInt8 {
        self.init(littleEndianBytes: Array(bytes))
    }
    
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
        self = zip(bytes, stride(from: 0, to: Self.bitWidth, by: 8))
            .reduce(0, { $0 | (Self($1.0) &<< $1.1) })
    }
    
    func bigEndianBytes() -> BigEndianBytes<Self> {
        BigEndianBytes(value: self)
    }
    
    func littleEndianBytes() -> LittleEndianBytes<Self> {
        LittleEndianBytes(value: self)
    }
    
    @_disfavoredOverload
    func bigEndianBytes() -> [UInt8] {
        stride(from: 0, to: Self.bitWidth, by: 8)
            .reversed()
            .map { UInt8(truncatingIfNeeded: self &>> $0) }
    }
    
    @_disfavoredOverload
    func littleEndianBytes() -> [UInt8] {
        stride(from: 0, to: Self.bitWidth, by: 8)
            .map { UInt8(truncatingIfNeeded: self &>> $0) }
    }
}

extension UInt8: EndianBytes {
    public typealias BigEndianBytesSequence = CollectionOfOne<Self>
    
    public typealias LittleEndianBytesSequence = CollectionOfOne<Self>
    
    public init?<Bytes>(bigEndianBytes bytes: Bytes)
    where Bytes: Sequence, Bytes.Element == UInt8 {
        var iterator = bytes.makeIterator()
        guard let byte = iterator.next() else {
            return nil
        }
        precondition(iterator.next() == nil)
        self = byte
    }
    
    public init?<Bytes>(littleEndianBytes bytes: Bytes)
    where Bytes: Sequence, Bytes.Element == UInt8 {
        var iterator = bytes.makeIterator()
        guard let byte = iterator.next() else {
            return nil
        }
        precondition(iterator.next() == nil)
        self = byte
    }
    
    public func bigEndianBytes() -> Self.BigEndianBytesSequence {
        .init(self)
    }
    
    public func littleEndianBytes() -> Self.LittleEndianBytesSequence {
        .init(self)
    }
    
    @_disfavoredOverload
    public func bigEndianBytes() -> [UInt8] {
        [self]
    }
    
    @_disfavoredOverload
    public func littleEndianBytes() -> [UInt8] {
        [self]
    }
}

extension UInt16: EndianBytes {
    @_disfavoredOverload
    public func bigEndianBytes() -> [UInt8] {
        [
            UInt8(truncatingIfNeeded: self >> 8),
            UInt8(truncatingIfNeeded: self >> 0),
        ]
    }
    
    @_disfavoredOverload
    public func littleEndianBytes() -> [UInt8] {
        [
            UInt8(truncatingIfNeeded: self >> 0),
            UInt8(truncatingIfNeeded: self >> 8),
        ]
    }
}

extension UInt32: EndianBytes {
    @_disfavoredOverload
    public func bigEndianBytes() -> [UInt8] {
        [
            UInt8(truncatingIfNeeded: self >> 24),
            UInt8(truncatingIfNeeded: self >> 16),
            UInt8(truncatingIfNeeded: self >>  8),
            UInt8(truncatingIfNeeded: self >>  0),
        ]
    }
    
    @_disfavoredOverload
    public func littleEndianBytes() -> [UInt8] {
        [
            UInt8(truncatingIfNeeded: self >>  0),
            UInt8(truncatingIfNeeded: self >>  8),
            UInt8(truncatingIfNeeded: self >> 16),
            UInt8(truncatingIfNeeded: self >> 24),
        ]
    }
}

extension UInt64: EndianBytes {
    @_disfavoredOverload
    public func bigEndianBytes() -> [UInt8] {
        [
            UInt8(truncatingIfNeeded: self >> 56),
            UInt8(truncatingIfNeeded: self >> 48),
            UInt8(truncatingIfNeeded: self >> 40),
            UInt8(truncatingIfNeeded: self >> 32),
            UInt8(truncatingIfNeeded: self >> 24),
            UInt8(truncatingIfNeeded: self >> 16),
            UInt8(truncatingIfNeeded: self >>  8),
            UInt8(truncatingIfNeeded: self >>  0),
        ]
    }
    
    @_disfavoredOverload
    public func littleEndianBytes() -> [UInt8] {
        [
            UInt8(truncatingIfNeeded: self >>  0),
            UInt8(truncatingIfNeeded: self >>  8),
            UInt8(truncatingIfNeeded: self >> 16),
            UInt8(truncatingIfNeeded: self >> 24),
            UInt8(truncatingIfNeeded: self >> 32),
            UInt8(truncatingIfNeeded: self >> 40),
            UInt8(truncatingIfNeeded: self >> 48),
            UInt8(truncatingIfNeeded: self >> 56),
        ]
    }
}

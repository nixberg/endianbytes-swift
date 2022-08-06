extension FixedWidthInteger {
    public typealias BigEndianBytesSequence = BigEndianBytes<Self>
    
    public typealias LittleEndianBytesSequence = LittleEndianBytes<Self>
    
    public init<Bytes>(bigEndianBytes bytes: Bytes)
    where Bytes: Sequence, Bytes.Element == UInt8 {
        var accumulatedBits = 0
        self = bytes.reduce(into: .zero) {
            $0 <<= 8
            $0 |= Self(truncatingIfNeeded: $1)
            accumulatedBits += 8
        }
        precondition(accumulatedBits == Self.bitWidth)
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

extension Int8: EndianBytesProtocol {
    public typealias BigEndianBytesSequence = CollectionOfOne<UInt8>
    
    public typealias LittleEndianBytesSequence = CollectionOfOne<UInt8>
    
    public func bigEndianBytes() -> Self.BigEndianBytesSequence {
        .init(.init(bitPattern: self))
    }
    
    public func littleEndianBytes() -> Self.LittleEndianBytesSequence {
        .init(.init(bitPattern: self))
    }
}

extension UInt8: EndianBytesProtocol {
    public typealias BigEndianBytesSequence = CollectionOfOne<UInt8>
    
    public typealias LittleEndianBytesSequence = CollectionOfOne<UInt8>
    
    public func bigEndianBytes() -> Self.BigEndianBytesSequence {
        .init(self)
    }
    
    
    public func littleEndianBytes() -> Self.LittleEndianBytesSequence {
        .init(self)
    }
}

extension Int16: EndianBytesProtocol {}
extension Int32: EndianBytesProtocol {}
extension Int64: EndianBytesProtocol {}

extension UInt16: EndianBytesProtocol {}
extension UInt32: EndianBytesProtocol {}
extension UInt64: EndianBytesProtocol {}

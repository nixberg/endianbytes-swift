@_exported import EndianBytesConvertible

extension FixedWidthInteger {
    public typealias BigEndianBytesSequence = BigEndianBytesCollection<Self>
    
    public typealias LittleEndianBytesSequence = LittleEndianBytesCollection<Self>
    
    public init(bigEndianBytes: some Sequence<UInt8>) {
        precondition(Self.isExactlyByteRepresentable, "TODO")
        
        var accumulatedBits = 0
        
        self = bigEndianBytes.reduce(.zero) {
            accumulatedBits += 8
            precondition(accumulatedBits <= Self.bitWidth, "Too many elements in sequence")
            return $0 << 8 | Self(truncatingIfNeeded: $1)
        }
        
        precondition(accumulatedBits == Self.bitWidth, "Not enough elements in sequence")
    }
    
    public init(littleEndianBytes: some Sequence<UInt8>) {
        self = Self(bigEndianBytes: littleEndianBytes).byteSwapped
    }
    
    public func bigEndianBytes() -> BigEndianBytesSequence {
        precondition(Self.isExactlyByteRepresentable, "TODO")
        return BigEndianBytesSequence(self)
    }
    
    public func littleEndianBytes() -> LittleEndianBytesSequence {
        precondition(Self.isExactlyByteRepresentable, "TODO")
        return LittleEndianBytesSequence(self)
    }
}

extension  Int:   EndianBytesConvertible {}
extension  Int8:  EndianBytesConvertible {}
extension  Int16: EndianBytesConvertible {}
extension  Int32: EndianBytesConvertible {}
extension  Int64: EndianBytesConvertible {}
extension UInt:   EndianBytesConvertible {}
extension UInt8:  EndianBytesConvertible {}
extension UInt16: EndianBytesConvertible {}
extension UInt32: EndianBytesConvertible {}
extension UInt64: EndianBytesConvertible {}

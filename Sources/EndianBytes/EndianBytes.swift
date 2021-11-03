public protocol EndianBytes {
    associatedtype BigEndianBytesSequence: Sequence
    where BigEndianBytesSequence.Element == UInt8
    
    associatedtype LittleEndianBytesSequence: Sequence
    where LittleEndianBytesSequence.Element == UInt8
    
    init?<Bytes>(bigEndianBytes bytes: Bytes)
    where Bytes: Sequence, Bytes.Element == UInt8
    
    init?<Bytes>(littleEndianBytes bytes: Bytes)
    where Bytes: Sequence, Bytes.Element == UInt8
    
    func bigEndianBytes() -> BigEndianBytesSequence
    
    func littleEndianBytes() -> LittleEndianBytesSequence
    
    @_disfavoredOverload
    func bigEndianBytes() -> [UInt8]
    
    @_disfavoredOverload
    func littleEndianBytes() -> [UInt8]
}

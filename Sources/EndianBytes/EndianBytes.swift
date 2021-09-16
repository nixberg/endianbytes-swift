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

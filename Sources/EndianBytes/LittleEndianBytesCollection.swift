public struct LittleEndianBytesCollection<Integer> where Integer: FixedWidthInteger {
    private let value: Integer
    
    init(_ value: Integer) {
        self.value = value
    }
}

extension LittleEndianBytesCollection: RandomAccessCollection {
    public var startIndex: Int {
        0
    }
    
    public var endIndex: Int {
        assert(Integer.isExactlyByteRepresentable)
        return Integer.bitWidth / 8
    }
    
    public subscript(position: Int) -> UInt8 {
        precondition(indices.contains(position), "Index out of range")
        return UInt8(truncatingIfNeeded: value &>> (8 &* position))
    }
    
    public var first: UInt8 {
        UInt8(truncatingIfNeeded: value)
    }
    
    public var last: UInt8 {
        UInt8(truncatingIfNeeded: value >> (Integer.bitWidth - 8))
    }
}

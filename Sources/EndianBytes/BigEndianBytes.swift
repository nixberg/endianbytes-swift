public struct BigEndianBytes<Integer>: RandomAccessCollection
where Integer: FixedWidthInteger & UnsignedInteger {
    public typealias Element = UInt8
    
    public typealias Index = Int
    
    private let value: Integer
    
    init(value: Integer) {
        precondition(Integer.bitWidth.isMultiple(of: 8))
        self.value = value
    }
    
    public var count: Int {
        Integer.bitWidth / 8
    }
    
    public var startIndex: Self.Index {
        0
    }
    
    public var endIndex: Self.Index {
        Integer.bitWidth / 8
    }
    
    public func index(after i: Self.Index) -> Self.Index {
        assert((startIndex..<endIndex).contains(i))
        return i + 1
    }
    
    public func index(before i: Self.Index) -> Self.Index {
        assert(((startIndex + 1)..<endIndex).contains(i))
        return i - 1
    }
    
    public subscript(position: Self.Index) -> Self.Element {
        precondition((startIndex..<endIndex).contains(position))
        return UInt8(truncatingIfNeeded: value &>> ((Integer.bitWidth - 8) - (8 * position)))
    }
    
    public var first: Self.Element {
        UInt8(truncatingIfNeeded: value >> (Integer.bitWidth - 8))
    }
    
    public var last: Self.Element {
        UInt8(truncatingIfNeeded: value)
    }
}

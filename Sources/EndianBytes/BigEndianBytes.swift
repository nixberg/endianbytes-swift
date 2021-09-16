public struct BigEndianBytes<Integer>: RandomAccessCollection
where Integer: FixedWidthInteger & UnsignedInteger {
    public typealias Element = UInt8
    
    public typealias Index = Int
    
    private let bigEndianValue: Integer
    
    init(value: Integer) {
        bigEndianValue = value.bigEndian
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
        i + 1
    }
    
    public func index(before i: Self.Index) -> Self.Index {
        i - 1
    }
    
    public subscript(position: Self.Index) -> Self.Element {
        Self.Element(truncatingIfNeeded: bigEndianValue &>> (8 * position))
    }
        
    public var first: Self.Element {
        Self.Element(truncatingIfNeeded: bigEndianValue)
    }
    
    public var last: Self.Element {
        Self.Element(truncatingIfNeeded: bigEndianValue >> (Integer.bitWidth - 8))
    }
}

public struct LittleEndianBytes<Integer>: RandomAccessCollection
where Integer: FixedWidthInteger & UnsignedInteger {
    public typealias Element = UInt8
    
    public typealias Index = Int
    
    private let littleEndianValue: Integer
    
    init(value: Integer) {
        littleEndianValue = value.littleEndian
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
        Self.Element(truncatingIfNeeded: littleEndianValue &>> (8 * position))
    }
        
    public var first: Self.Element {
        Self.Element(truncatingIfNeeded: littleEndianValue)
    }
    
    public var last: Self.Element {
        Self.Element(truncatingIfNeeded: littleEndianValue >> (Integer.bitWidth - 8))
    }
}

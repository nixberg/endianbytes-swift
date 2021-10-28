public struct LittleEndianBytes<Integer>: RandomAccessCollection
where Integer: FixedWidthInteger & UnsignedInteger {
    public typealias Element = UInt8
    
    public typealias Index = Int
    
    private let littleEndianValue: Integer
    
    init(value: Integer) {
        precondition(Integer.bitWidth.isMultiple(of: 8))
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
        assert((startIndex..<endIndex).contains(i))
        return i + 1
    }
    
    public func index(before i: Self.Index) -> Self.Index {
        assert((startIndex..<endIndex).contains(i))
        return i - 1
    }
    
    public subscript(position: Self.Index) -> Self.Element {
        precondition((startIndex..<endIndex).contains(position))
        return withUnsafeBytes(of: littleEndianValue) { $0[position] }
    }
        
    public var first: Self.Element {
        withUnsafeBytes(of: littleEndianValue) { $0[startIndex] }
    }
    
    public var last: Self.Element {
        withUnsafeBytes(of: littleEndianValue) { $0[endIndex - 1] }
    }
}

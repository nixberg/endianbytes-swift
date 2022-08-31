public struct BigEndianBytes<Integer>: RandomAccessCollection where Integer: FixedWidthInteger {
    public typealias Element = UInt8
    
    public typealias Index = Int
    
    private let value: Integer
    
    init(_ value: Integer) {
        precondition(Integer.bitWidth.isMultiple(of: 8))
        self.value = value
    }
    
    @inline(__always)
    public var startIndex: Index {
        0
    }
    
    @inline(__always)
    public var endIndex: Index {
        Integer.bitWidth / 8
    }
    
    public subscript(position: Index) -> Element {
        precondition((startIndex..<endIndex).contains(position))
        return .init(truncatingIfNeeded: value >> ((Integer.bitWidth - 8) - (8 * position)))
    }
    
    public var first: Element {
        .init(truncatingIfNeeded: value >> (Integer.bitWidth - 8))
    }
    
    public var last: Element {
        .init(truncatingIfNeeded: value)
    }
}

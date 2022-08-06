public struct LittleEndianBytes<Integer>: RandomAccessCollection where Integer: FixedWidthInteger {
    public typealias Element = UInt8
    
    public typealias Index = Int
    
    private let value: Integer
    
    init(_ value: Integer) {
        precondition(Integer.bitWidth.isMultiple(of: 8))
        self.value = value
    }
    
    @inline(__always)
    public var count: Int {
        Integer.bitWidth / 8
    }
    
    @inline(__always)
    public var startIndex: Self.Index {
        0
    }
    
    @inline(__always)
    public var endIndex: Self.Index {
        Integer.bitWidth / 8
    }
    
    public subscript(position: Self.Index) -> Self.Element {
        precondition((startIndex..<endIndex).contains(position))
        return .init(truncatingIfNeeded: value >> (8 * position))
    }
    
    public var first: Self.Element {
        .init(truncatingIfNeeded: value)
    }
    
    public var last: Self.Element {
        .init(truncatingIfNeeded: value >> (Integer.bitWidth - 8))
    }
}

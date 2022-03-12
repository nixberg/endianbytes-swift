public struct SIMDLittleEndianBytes<Vector>: RandomAccessCollection
where Vector: SIMD, Vector.Scalar: FixedWidthInteger & UnsignedInteger & EndianBytesProtocol {
    public typealias Element = UInt8
    
    public typealias Index = Int
    
    private let value: Vector
    
    init(_ value: Vector) {
        precondition(Vector.Scalar.bitWidth.isMultiple(of: 8))
        self.value = value
    }
    
    @inline(__always)
    public var count: Int {
        Vector.scalarCount * Vector.Scalar.bitWidth / 8
    }
    
    @inline(__always)
    public var startIndex: Self.Index {
        0
    }
    
    @inline(__always)
    public var endIndex: Self.Index {
        Vector.scalarCount * Vector.Scalar.bitWidth / 8
    }
    
    public subscript(position: Self.Index) -> Self.Element {
        precondition((startIndex..<endIndex).contains(position))
        let (i, j) = position.quotientAndRemainder(dividingBy: Vector.Scalar.bitWidth / 8)
        return .init(truncatingIfNeeded: value[i] &>> (8 * j))
    }
    
    public var first: Self.Element {
        .init(truncatingIfNeeded: value.first)
    }
    
    public var last: Self.Element {
        .init(truncatingIfNeeded: value.last >> (Vector.Scalar.bitWidth - 8))
    }
}

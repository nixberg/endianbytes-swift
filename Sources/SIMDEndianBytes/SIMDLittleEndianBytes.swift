import EndianBytes

public struct SIMDLittleEndianBytes<Vector>: RandomAccessCollection
where Vector: SIMD, Vector.Scalar: EndianBytesProtocol & FixedWidthInteger {
    public typealias Element = UInt8
    
    public typealias Index = Int
    
    private let value: Vector
    
    init(_ value: Vector) {
        precondition(Vector.Scalar.bitWidth.isMultiple(of: 8))
        self.value = value
    }
    
    @inline(__always)
    public var startIndex: Index {
        0
    }
    
    @inline(__always)
    public var endIndex: Index {
        Vector.scalarCount * Vector.Scalar.bitWidth / 8
    }
    
    public subscript(position: Index) -> Element {
        precondition((startIndex..<endIndex).contains(position))
        let (i, j) = position.quotientAndRemainder(dividingBy: Vector.Scalar.bitWidth / 8)
        return .init(truncatingIfNeeded: value[i] >> (8 * j))
    }
    
    public var first: Element {
        .init(truncatingIfNeeded: value.first)
    }
    
    public var last: Element {
        .init(truncatingIfNeeded: value.last >> (Vector.Scalar.bitWidth - 8))
    }
}

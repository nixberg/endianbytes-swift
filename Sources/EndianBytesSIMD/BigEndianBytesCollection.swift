public struct BigEndianBytesCollection<Vector>
where Vector: SIMD, Vector.Scalar: FixedWidthInteger {
    private let value: Vector
    
    init(_ value: Vector) {
        self.value = value.byteSwapped
    }
}

extension BigEndianBytesCollection: RandomAccessCollection {
    public var startIndex: Int {
        0
    }
    
    public var endIndex: Int {
        precondition(Vector.Scalar.bitWidth.isMultiple(of: 8))
        return Vector.bitWidth / 8
    }
    
    public subscript(position: Int) -> UInt8 {
        precondition(indices.contains(position), "Index out of range")
        let (scalarIndex, position) = position.quotientAndRemainder(
            dividingBy: Vector.Scalar.bitWidth / 8
        )
        return UInt8(truncatingIfNeeded: value[scalarIndex] &>> (8 &* position))
    }
    
    public var first: UInt8 {
        UInt8(truncatingIfNeeded: value.first)
    }
    
    public var last: UInt8 {
        UInt8(truncatingIfNeeded: value.last >> (Vector.Scalar.bitWidth - 8))
    }
}

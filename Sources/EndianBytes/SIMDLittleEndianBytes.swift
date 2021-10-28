public struct SIMDLittleEndianBytes<Vector>: RandomAccessCollection
where Vector: SIMD, Vector.Scalar: FixedWidthInteger & UnsignedInteger {
    public typealias Element = UInt8
    
    public typealias Index = Int
    
    private let littleEndianValue: Vector
    
    init(value: Vector) {
        precondition(Vector.Scalar.bitWidth.isMultiple(of: 8))
        littleEndianValue = value.littleEndian
    }
    
    public var count: Int {
        Vector.scalarCount * Vector.Scalar.bitWidth / 8
    }
    
    public var startIndex: Self.Index {
        0
    }
    
    public var endIndex: Self.Index {
        Vector.scalarCount * Vector.Scalar.bitWidth / 8
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

fileprivate extension SIMD where Scalar: FixedWidthInteger & UnsignedInteger {
    var littleEndian: Self {
        var result: Self = .zero
        for i in indices {
            result[i] = self[i].littleEndian
        }
        return result
    }
}

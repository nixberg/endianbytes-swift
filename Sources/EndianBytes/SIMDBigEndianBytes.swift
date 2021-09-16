public struct SIMDBigEndianBytes<Vector>: RandomAccessCollection
where Vector: SIMD, Vector.Scalar: FixedWidthInteger & UnsignedInteger {
    public typealias Element = UInt8
    
    public typealias Index = Int
    
    private let bigEndianValue: Vector
    
    init(value: Vector) {
        precondition(Vector.Scalar.bitWidth.isMultiple(of: 8))
        bigEndianValue = value.bigEndian
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
        i + 1
    }
    
    public func index(before i: Self.Index) -> Self.Index {
        i - 1
    }
    
    public subscript(position: Self.Index) -> Self.Element {
        withUnsafeBytes(of: bigEndianValue) { $0[position] }
    }
    
    public var first: Self.Element {
        withUnsafeBytes(of: bigEndianValue) { $0[startIndex] }
    }
    
    public var last: Self.Element {
        withUnsafeBytes(of: bigEndianValue) { $0[endIndex - 1] }
    }
}

fileprivate extension SIMD where Scalar: FixedWidthInteger & UnsignedInteger {
    var bigEndian: Self {
        var result: Self = .zero
        for i in indices {
            result[i] = self[i].bigEndian
        }
        return result
    }
}

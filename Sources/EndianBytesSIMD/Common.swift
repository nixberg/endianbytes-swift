extension SIMD where Scalar: FixedWidthInteger {
    static var bitWidth: Int {
        scalarCount * Scalar.bitWidth
    }
    
    var byteSwapped: Self {
        var result: Self = .zero
        for index in indices {
            result[index] = self[index].byteSwapped
        }
        return result
    }
    
    var first: Scalar {
        self[0]
    }
    
    var last: Scalar {
        self[Self.scalarCount - 1]
    }
}

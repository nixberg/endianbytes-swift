@_exported import EndianBytesConvertible

extension SIMD where Scalar: FixedWidthInteger {
    public typealias BigEndianBytesSequence = BigEndianBytesCollection<Self>
    
    public typealias LittleEndianBytesSequence = LittleEndianBytesCollection<Self>
    
    public init(bigEndianBytes: some Sequence<UInt8>) {
        precondition(Scalar.isExactlyByteRepresentable, "TODO")
        
        var accumulatedBits = 0
        
        self = bigEndianBytes.reduce(into: .zero) {
            let scalarIndex = accumulatedBits / Scalar.bitWidth
            accumulatedBits += 8
            precondition(accumulatedBits <= Self.bitWidth, "Too many elements in sequence")
            $0[scalarIndex] <<= 8
            $0[scalarIndex] |= Scalar(truncatingIfNeeded: $1)
        }
        
        precondition(accumulatedBits == Self.bitWidth, "Not enough elements in sequence")
    }
    
    public init(littleEndianBytes: some Sequence<UInt8>) {
        self = Self(bigEndianBytes: littleEndianBytes).byteSwapped
    }
    
    public func bigEndianBytes() -> BigEndianBytesSequence {
        precondition(Scalar.isExactlyByteRepresentable, "TODO")
        return BigEndianBytesSequence(self)
    }
    
    public func littleEndianBytes() -> LittleEndianBytesSequence {
        precondition(Scalar.isExactlyByteRepresentable, "TODO")
        return LittleEndianBytesSequence(self)
    }
}

extension SIMD2:  EndianBytesConvertible where Scalar: FixedWidthInteger {}
extension SIMD3:  EndianBytesConvertible where Scalar: FixedWidthInteger {}
extension SIMD4:  EndianBytesConvertible where Scalar: FixedWidthInteger {}
extension SIMD8:  EndianBytesConvertible where Scalar: FixedWidthInteger {}
extension SIMD16: EndianBytesConvertible where Scalar: FixedWidthInteger {}
extension SIMD32: EndianBytesConvertible where Scalar: FixedWidthInteger {}
extension SIMD64: EndianBytesConvertible where Scalar: FixedWidthInteger {}

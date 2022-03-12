import EndianBytes

protocol TestedInteger: FixedWidthInteger & UnsignedInteger & EndianBytesProtocol {}

extension UInt8:  TestedInteger {}
extension UInt16: TestedInteger {}
extension UInt32: TestedInteger {}
extension UInt64: TestedInteger {}

protocol TestedVector: SIMD where Self.Scalar: TestedInteger {}

extension SIMD2: TestedVector where Self.Scalar: TestedInteger {}
extension SIMD3: TestedVector where Self.Scalar: TestedInteger {}
extension SIMD4: TestedVector where Self.Scalar: TestedInteger {}

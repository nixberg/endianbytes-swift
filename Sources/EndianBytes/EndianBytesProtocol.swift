/// Conforming types support conversion from and to representations of their value as sequences of
/// bytes in big-endian or little-endian byte order.
public protocol EndianBytesProtocol {
    /// A type representing a value as a sequence of bytes in big-endian byte order.
    associatedtype BigEndianBytesSequence: Sequence
    where BigEndianBytesSequence.Element == UInt8
    
    /// A type representing a value as a sequence of bytes in little-endian byte order.
    associatedtype LittleEndianBytesSequence: Sequence
    where LittleEndianBytesSequence.Element == UInt8
    
    /// Creates a new instance of `Self` from a representation of a value as a sequence of
    /// bytes in big-endian byte order.
    ///
    /// When applicable, conforming implementations should expect a fixed count of `bytes` and
    /// consider omitted or superfluous bytes a `preconditionFailure`.
    ///
    /// - Parameters:
    ///   - bytes: A sequence of bytes representing a value in big-endian byte order.
    init<Bytes>(bigEndianBytes bytes: Bytes) where Bytes: Sequence, Bytes.Element == UInt8
    
    /// Creates a new instance of `Self` from a representation of a value as a sequence of bytes
    /// in little-endian byte order.
    ///
    /// When applicable, conforming implementations should expect a fixed count of `bytes` and
    /// consider omitted or superfluous bytes a `preconditionFailure`.
    ///
    /// - Parameters:
    ///   - bytes: A sequence of bytes representing a value in little-endian byte order.
    init<Bytes>(littleEndianBytes bytes: Bytes) where Bytes: Sequence, Bytes.Element == UInt8
    
    /// Returns a representation of `self` as a sequence of bytes in big-endian byte order.
    ///
    /// - Returns: A `BigEndianBytesSequence` representing the value of `self` as a sequence of
    ///            bytes in big-endian byte order.
    func bigEndianBytes() -> BigEndianBytesSequence
    
    /// Returns a representation of `self` as a sequence of bytes in little-endian byte order.
    ///
    /// - Returns: A `LittleEndianBytesSequence` representing the value of `self` as a sequence of
    ///            bytes in little-endian byte order.
    func littleEndianBytes() -> LittleEndianBytesSequence
}

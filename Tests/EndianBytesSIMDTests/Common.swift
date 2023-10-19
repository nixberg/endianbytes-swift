extension Array where Element: FixedWidthInteger & UnsignedInteger {
    static func random(ofCount count: Int) -> Self {
        var rng = SystemRandomNumberGenerator()
        return (0..<count).map({ _ in rng.next() })
    }
}

extension Array where Element == Double {
    public func delta() -> [Element] {
        (1..<count).map {
            self[$0] - self[$0 - 1]
        }
    }
}

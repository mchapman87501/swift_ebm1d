extension Array where Element == Double {
    func delta() -> [Element] {
        return (1..<count).map {
            self[$0] - self[$0 - 1]
        }
    }

    func normed() -> [Element] {
        let maxVal = self.max() ?? 1.0
        return self.map { $0 / maxVal }
    }

    func formatted() -> String {
        let svals = self.map {
            String(format: "%.2f", $0)
        }
        return "[\(svals.joined(separator: ", "))]"
    }
}

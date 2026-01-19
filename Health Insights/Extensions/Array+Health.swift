// Array+Health.swift
// Extensions/Array+Health.swift

import Foundation

extension Array where Element == HealthData {
    func sleepDebt(targetHours: Double) -> Double {
        let totalSleep = compactMap { $0.sleepData?.totalSleep }.reduce(0, +)
        let targetTotal = Double(count) * targetHours
        return targetTotal - totalSleep
    }
}

extension Array where Element: BinaryFloatingPoint {
    var average: Element? {
        guard !isEmpty else { return nil }
        return reduce(0, +) / Element(count)
    }
}

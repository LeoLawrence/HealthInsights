// WeekdayWeekendComparison.swift
// Views/Shared/WeekdayWeekendComparison.swift

import SwiftUI

struct WeekdayWeekendComparison<T: BinaryFloatingPoint>: View {
    let data: [HealthData]
    let title: String
    let keyPath: KeyPath<HealthData, T?>
    let unit: String
    let format: String
    @Environment(\.colorScheme) var colorScheme
    
    var weekdayAvg: T? {
        let weekdayData = data.filter { !Calendar.current.isDateInWeekend($0.date) }
        let values = weekdayData.compactMap { $0[keyPath: keyPath] }
        guard !values.isEmpty else { return nil }
        return values.reduce(0, +) / T(values.count)
    }
    
    var weekendAvg: T? {
        let weekendData = data.filter { Calendar.current.isDateInWeekend($0.date) }
        let values = weekendData.compactMap { $0[keyPath: keyPath] }
        guard !values.isEmpty else { return nil }
        return values.reduce(0, +) / T(values.count)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
            
            HStack(spacing: 32) {
                if let weekday = weekdayAvg {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Weekday")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(String(format: format, Double(weekday)))
                            .font(.system(size: 28, weight: .bold))
                        Text(unit)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                if let weekend = weekendAvg, let weekday = weekdayAvg {
                    VStack(spacing: 4) {
                        Image(systemName: weekend > weekday ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                            .font(.title3)
                            .foregroundColor(weekend > weekday ? .green : .red)
                        Text(String(format: format, abs(Double(weekend - weekday))))
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                }
                
                if let weekend = weekendAvg {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Weekend")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(String(format: format, Double(weekend)))
                            .font(.system(size: 28, weight: .bold))
                        Text(unit)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? Color(.systemGray6) : Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
        )
    }
}

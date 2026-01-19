// CorrelationCard.swift
// Views/Insights/CorrelationCard.swift

import SwiftUI
import Charts

struct CorrelationCard: View {
    let title: String
    let data: ArraySlice<HealthData>
    let xKeyPath: KeyPath<HealthData, Double?>
    let yKeyPath: KeyPath<HealthData, Int>
    let xLabel: String
    let yLabel: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            
            if #available(iOS 16.0, *) {
                Chart(Array(data).filter { $0[keyPath: xKeyPath] != nil }) { item in
                    PointMark(
                        x: .value(xLabel, item[keyPath: xKeyPath] ?? 0),
                        y: .value(yLabel, item[keyPath: yKeyPath])
                    )
                    .foregroundStyle(.blue.opacity(0.6))
                }
                .frame(height: 200)
                .padding()
            }
            
            Text(correlationDescription())
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? Color(.systemGray6) : Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
        )
    }
    
    func correlationDescription() -> String {
        let validData = data.compactMap { item -> (Double, Double)? in
            guard let x = item[keyPath: xKeyPath] else { return nil }
            let y = Double(item[keyPath: yKeyPath])
            return (x, y)
        }
        
        guard validData.count > 2 else {
            return "Not enough data to determine correlation."
        }
        
        // Simple correlation calculation
        let xMean = validData.map { $0.0 }.reduce(0, +) / Double(validData.count)
        let yMean = validData.map { $0.1 }.reduce(0, +) / Double(validData.count)
        
        let numerator = validData.map { ($0.0 - xMean) * ($0.1 - yMean) }.reduce(0, +)
        let xDenom = sqrt(validData.map { pow($0.0 - xMean, 2) }.reduce(0, +))
        let yDenom = sqrt(validData.map { pow($0.1 - yMean, 2) }.reduce(0, +))
        
        let correlation = numerator / (xDenom * yDenom)
        
        if correlation > 0.6 {
            return "Strong positive correlation: Higher \(xLabel.lowercased()) tends to mean better \(yLabel.lowercased())."
        } else if correlation > 0.3 {
            return "Moderate positive correlation between \(xLabel.lowercased()) and \(yLabel.lowercased())."
        } else if correlation < -0.6 {
            return "Strong negative correlation detected."
        } else if correlation < -0.3 {
            return "Moderate negative correlation detected."
        } else {
            return "Weak or no correlation between these metrics."
        }
    }
}

// ContributingFactorsCard.swift
// Views/Recovery/ContributingFactorsCard.swift

import SwiftUI

struct ContributingFactorsCard: View {
    let data: HealthData
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Contributing Factors")
                .font(.headline)
            
            if let hrv = data.hrv {
                FactorRow(
                    title: "HRV",
                    subtitle: "40% weight",
                    value: String(format: "%.0f ms", hrv),
                    progress: min(hrv / 80, 1.0),
                    color: .pink
                )
            }
            
            FactorRow(
                title: "Sleep",
                subtitle: "40% weight",
                value: "\(data.sleepScore)%",
                progress: Double(data.sleepScore) / 100,
                color: .purple
            )
            
            if let rhr = data.restingHR {
                FactorRow(
                    title: "Resting HR",
                    subtitle: "20% weight",
                    value: String(format: "%.0f bpm", rhr),
                    progress: max(1.0 - ((rhr - 50) / 30), 0),
                    color: .red
                )
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

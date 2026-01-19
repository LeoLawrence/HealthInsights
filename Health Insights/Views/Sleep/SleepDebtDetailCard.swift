// SleepDebtDetailCard.swift
// Views/Sleep/SleepDebtDetailCard.swift

import SwiftUI

struct SleepDebtDetailCard: View {
    let debt: Double
    let targetHours: Double
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: debt > 0 ? "moon.circle.fill" : "checkmark.circle.fill")
                    .font(.title)
                    .foregroundColor(debt > 0 ? .orange : .green)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("7-Day Sleep Bank")
                        .font(.headline)
                    if debt > 0 {
                        Text("You owe \(String(format: "%.1f", debt)) hours of sleep")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } else {
                        Text("Sleep surplus of \(String(format: "%.1f", abs(debt))) hours")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
            }
            
            if debt > 0 {
                Text("Try getting \(String(format: "%.1f", targetHours + (debt / 2))) hours tonight to start paying off your sleep debt.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.orange.opacity(0.1))
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

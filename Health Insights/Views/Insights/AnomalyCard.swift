// AnomalyCard.swift
// Views/Insights/AnomalyCard.swift

import SwiftUI

struct AnomalyCard: View {
    let data: HealthData
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "exclamationmark.circle.fill")
                .font(.title2)
                .foregroundColor(.orange)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(data.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.headline)
                Text("Unusual health pattern detected")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                if data.illnessRisk >= 3 {
                    Text("Possible illness indicators")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? Color(.systemGray6) : Color.white)
                .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
        )
    }
}

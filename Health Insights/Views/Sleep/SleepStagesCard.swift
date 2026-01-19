// SleepStagesCard.swift
// Views/Sleep/SleepStagesCard.swift

import SwiftUI

struct SleepStagesCard: View {
    let sleep: SleepData
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sleep Stages")
                .font(.headline)
            
            SleepStageRow(
                title: "Deep Sleep",
                hours: sleep.deepSleep,
                percentage: (sleep.deepSleep / sleep.totalSleep) * 100,
                total: sleep.totalSleep,
                color: .indigo,
                optimal: "13-23%"
            )
            
            SleepStageRow(
                title: "REM Sleep",
                hours: sleep.remSleep,
                percentage: (sleep.remSleep / sleep.totalSleep) * 100,
                total: sleep.totalSleep,
                color: .purple,
                optimal: "20-25%"
            )
            
            SleepStageRow(
                title: "Core Sleep",
                hours: sleep.coreSleep,
                percentage: (sleep.coreSleep / sleep.totalSleep) * 100,
                total: sleep.totalSleep,
                color: Color(red: 0.4, green: 0.6, blue: 1.0),
                optimal: "45-55%"
            )
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? Color(.systemGray6) : Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
        )
    }
}

struct SleepStageRow: View {
    let title: String
    let hours: Double
    let percentage: Double
    let total: Double
    let color: Color
    let optimal: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text("Optimal: \(optimal)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(String(format: "%.1fh", hours))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text(String(format: "%.0f%%", percentage))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)
                    
                    Capsule()
                        .fill(color)
                        .frame(width: geometry.size.width * (hours / total), height: 8)
                }
            }
            .frame(height: 8)
        }
    }
}

// SleepScoreCard.swift
// Views/Sleep/SleepScoreCard.swift

import SwiftUI

struct SleepScoreCard: View {
    let data: HealthData
    @Environment(\.colorScheme) var colorScheme
    
    var scoreColor: Color {
        let score = data.sleepScore
        if score >= 85 { return .green }
        if score >= 70 { return .blue }
        if score >= 50 { return .yellow }
        return .red
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Last Night")
                        .font(.headline)
                    if let sleep = data.sleepData {
                        HStack(spacing: 16) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(String(format: "%.1fh", sleep.totalSleep))
                                    .font(.system(size: 32, weight: .bold))
                                Text("Total Sleep")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(Int(sleep.efficiency))%")
                                    .font(.system(size: 32, weight: .bold))
                                Text("Efficiency")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                Spacer()
                
                // Sleep Score Circle
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 12)
                        .frame(width: 100, height: 100)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(data.sleepScore) / 100)
                        .stroke(scoreColor, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .frame(width: 100, height: 100)
                        .rotationEffect(.degrees(-90))
                    
                    VStack(spacing: 0) {
                        Text("\(data.sleepScore)")
                            .font(.system(size: 28, weight: .bold))
                        Text("score")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            if let sleep = data.sleepData {
                Divider()
                
                HStack(spacing: 20) {
                    ScoreDetailItem(
                        icon: "bed.double.fill",
                        value: String(format: "%.1fh", sleep.inBed),
                        label: "In Bed"
                    )
                    
                    ScoreDetailItem(
                        icon: "moon.zzz.fill",
                        value: "\(sleep.awakenings)",
                        label: "Awakenings"
                    )
                    
                    if let rr = data.respiratoryRate {
                        ScoreDetailItem(
                            icon: "wind",
                            value: String(format: "%.1f", rr),
                            label: "Resp. Rate"
                        )
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? Color(.systemGray6) : Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
        )
    }
}

struct ScoreDetailItem: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.purple.opacity(0.8))
            Text(value)
                .font(.headline)
            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// WeekComparisonCard.swift
// Views/Recovery/WeekComparisonCard.swift

import SwiftUI

struct WeekComparisonCard: View {
    let thisWeek: [HealthData]
    let lastWeek: [HealthData]
    @Environment(\.colorScheme) var colorScheme
    
    var thisWeekAvg: Int {
        let scores = thisWeek.map { $0.recoveryScore }
        return scores.isEmpty ? 0 : scores.reduce(0, +) / scores.count
    }
    
    var lastWeekAvg: Int {
        let scores = lastWeek.map { $0.recoveryScore }
        return scores.isEmpty ? 0 : scores.reduce(0, +) / scores.count
    }
    
    var change: Int {
        thisWeekAvg - lastWeekAvg
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("This Week vs Last Week")
                .font(.headline)
            
            HStack(spacing: 32) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("This Week")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(thisWeekAvg)")
                        .font(.system(size: 36, weight: .bold))
                }
                
                VStack(spacing: 4) {
                    Image(systemName: change >= 0 ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                        .font(.title2)
                        .foregroundColor(change >= 0 ? .green : .red)
                    Text("\(abs(change)) pts")
                        .font(.caption)
                        .fontWeight(.medium)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Last Week")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("\(lastWeekAvg)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.secondary)
                }
            }
            
            Text(change >= 0 ? "Your recovery is improving!" : "Your recovery declined this week. Focus on sleep and stress management.")
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
}

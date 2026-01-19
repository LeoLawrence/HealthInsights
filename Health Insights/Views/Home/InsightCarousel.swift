// InsightCarousel.swift
// Views/Home/InsightCarousel.swift

import SwiftUI

struct InsightCarousel: View {
    let data: HealthData
    let allData: [HealthData]
    
    var insights: [String] {
        var result: [String] = []
        
        // HRV trend
        if let currentHRV = data.hrv {
            let recentHRV = allData.suffix(7).compactMap { $0.hrv }
            if recentHRV.count >= 3 {
                let avg = recentHRV.reduce(0, +) / Double(recentHRV.count)
                let change = ((currentHRV - avg) / avg) * 100
                if abs(change) > 5 {
                    result.append("Your HRV is \(change > 0 ? "up" : "down") \(String(format: "%.0f", abs(change)))% this week")
                }
            }
        }
        
        // Sleep pattern
        let weekendData = allData.suffix(14).filter { Calendar.current.isDateInWeekend($0.date) }
        let weekdayData = allData.suffix(14).filter { !Calendar.current.isDateInWeekend($0.date) }
        
        let weekendSleepValues = weekendData.compactMap { $0.sleepData?.totalSleep }
        let weekdaySleepValues = weekdayData.compactMap { $0.sleepData?.totalSleep }
        
        if !weekendSleepValues.isEmpty && !weekdaySleepValues.isEmpty {
            let weekendSleep = weekendSleepValues.reduce(0, +) / Double(weekendSleepValues.count)
            let weekdaySleep = weekdaySleepValues.reduce(0, +) / Double(weekdaySleepValues.count)
            let diff = weekendSleep - weekdaySleep
            
            if abs(diff) > 0.5 {
                result.append("You sleep \(String(format: "%.1f", abs(diff)))h \(diff > 0 ? "more" : "less") on weekends")
            }
        }
        
        // Recovery trend
        let recentRecovery = allData.suffix(7).map { $0.recoveryScore }
        if recentRecovery.count >= 5 {
            let trend = recentRecovery.last! - recentRecovery.first!
            if abs(trend) > 10 {
                result.append("Your recovery is trending \(trend > 0 ? "upward" : "downward") this week")
            }
        }
        
        // Temperature correlation
        if let tempDelta = data.temperatureFahrenheitDelta, abs(tempDelta) > 0.5 {
            if let sleep = data.sleepData, sleep.efficiency < 75 {
                result.append("Temperature changes may be affecting your sleep quality")
            }
        }
        
        return result.isEmpty ? ["Keep tracking your health for personalized insights"] : result
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(insights, id: \.self) { insight in
                    InsightChip(text: insight)
                }
            }
        }
    }
}

struct InsightChip: View {
    let text: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "lightbulb.fill")
                .font(.caption)
                .foregroundColor(.yellow)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Capsule()
                .fill(colorScheme == .dark ? Color(.systemGray6) : Color.white)
                .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
        )
    }
}

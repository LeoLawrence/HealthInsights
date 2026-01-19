// InsightsView.swift
// Views/Insights/InsightsView.swift

import SwiftUI

struct InsightsView: View {
    @EnvironmentObject var healthManager: HealthKitManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Personalized Insights
                    Text("Your Insights")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    ForEach(generateInsights(), id: \.title) { insight in
                        InsightDetailCard(insight: insight)
                            .padding(.horizontal)
                    }
                    
                    // Correlations
                    Text("Correlations")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    CorrelationCard(
                        title: "HRV vs Sleep Quality",
                        data: healthManager.healthData.suffix(14),
                        xKeyPath: \.hrv,
                        yKeyPath: \.sleepScore,
                        xLabel: "HRV (ms)",
                        yLabel: "Sleep Score"
                    )
                    .padding(.horizontal)
                    
                    // Anomalies
                    let anomalies = healthManager.healthData.filter { $0.isAnomaly }
                    if !anomalies.isEmpty {
                        Text("Unusual Days")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                            .padding(.top)
                        
                        ForEach(anomalies.suffix(5)) { data in
                            AnomalyCard(data: data)
                                .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .background(colorScheme == .dark ? Color.black : Color(.systemGroupedBackground))
            .navigationTitle("Insights")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    func generateInsights() -> [InsightItem] {
        var insights: [InsightItem] = []
        let recentData = healthManager.healthData.suffix(14)
        
        // HRV trend insight
        if let currentHRV = recentData.last?.hrv {
            let previousHRV = recentData.dropLast().compactMap { $0.hrv }
            if !previousHRV.isEmpty {
                let avg = previousHRV.reduce(0, +) / Double(previousHRV.count)
                let change = ((currentHRV - avg) / avg) * 100
                if abs(change) > 10 {
                    insights.append(InsightItem(
                        title: "HRV Trend",
                        description: "Your HRV is \(change > 0 ? "up" : "down") \(String(format: "%.0f%%", abs(change))) compared to your 2-week average.",
                        recommendation: change > 0 ? "Great! Your body is recovering well." : "Your body may need more rest and recovery.",
                        icon: "waveform.path.ecg",
                        color: change > 0 ? .green : .orange
                    ))
                }
            }
        }
        
        // Sleep consistency
        let sleepTimes = recentData.compactMap { $0.sleepData?.totalSleep }
        if sleepTimes.count >= 7 {
            let mean = sleepTimes.reduce(0, +) / Double(sleepTimes.count)
            let variance = sleepTimes.map { pow($0 - mean, 2) }.reduce(0, +) / Double(sleepTimes.count)
            let stdDev = sqrt(variance)
            
            if stdDev > 1.0 {
                insights.append(InsightItem(
                    title: "Sleep Consistency",
                    description: "Your sleep duration varies by an average of \(String(format: "%.1f", stdDev)) hours per night.",
                    recommendation: "Try maintaining a consistent sleep schedule for better recovery.",
                    icon: "clock.fill",
                    color: .purple
                ))
            }
        }
        
        // Weekend vs weekday
        let weekendData = recentData.filter { Calendar.current.isDateInWeekend($0.date) }
        let weekdayData = recentData.filter { !Calendar.current.isDateInWeekend($0.date) }
        
        let weekendSleepValues = weekendData.compactMap { $0.sleepData?.totalSleep }
        let weekdaySleepValues = weekdayData.compactMap { $0.sleepData?.totalSleep }
        
        if !weekendSleepValues.isEmpty && !weekdaySleepValues.isEmpty {
            let weekendSleep = weekendSleepValues.reduce(0, +) / Double(weekendSleepValues.count)
            let weekdaySleep = weekdaySleepValues.reduce(0, +) / Double(weekdaySleepValues.count)
            let diff = weekendSleep - weekdaySleep
            
            if abs(diff) > 1.0 {
                insights.append(InsightItem(
                    title: "Weekend Sleep Pattern",
                    description: "You sleep \(String(format: "%.1f", abs(diff))) hours \(diff > 0 ? "more" : "less") on weekends.",
                    recommendation: diff > 0 ? "This suggests weekday sleep debt. Try going to bed earlier on weekdays." : "Maintain this consistent pattern!",
                    icon: "calendar",
                    color: .blue
                ))
            }
        }
        
        // Recovery trend
        let recoveryScores = recentData.map { $0.recoveryScore }
        if recoveryScores.count >= 7 {
            let recent = recoveryScores.suffix(3).reduce(0, +) / 3
            let previous = recoveryScores.prefix(4).reduce(0, +) / 4
            let trend = recent - previous
            
            if abs(trend) > 5 {
                insights.append(InsightItem(
                    title: "Recovery Trend",
                    description: "Your recovery score is trending \(trend > 0 ? "upward" : "downward") this week.",
                    recommendation: trend > 0 ? "Keep up the great work!" : "Focus on sleep quality and stress management.",
                    icon: "chart.line.uptrend.xyaxis",
                    color: trend > 0 ? .green : .yellow
                ))
            }
        }
        
        return insights.isEmpty ? [InsightItem(
            title: "Keep Tracking",
            description: "Continue wearing your Apple Watch to generate personalized insights.",
            recommendation: "We need more data to provide meaningful patterns and recommendations.",
            icon: "chart.bar.fill",
            color: .blue
        )] : insights
    }
}

struct InsightItem {
    let title: String
    let description: String
    let recommendation: String
    let icon: String
    let color: Color
}

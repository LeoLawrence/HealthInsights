// SleepView.swift
// Views/Sleep/SleepView.swift

import SwiftUI
import Charts

struct SleepView: View {
    @EnvironmentObject var healthManager: HealthKitManager
    @Environment(\.colorScheme) var colorScheme
    
    var weekAverage: (hours: Double, efficiency: Double) {
        let weekData = healthManager.healthData.suffix(7)
        let sleepData = weekData.compactMap { $0.sleepData }
        guard !sleepData.isEmpty else { return (0, 0) }
        
        let avgHours = sleepData.reduce(0) { $0 + $1.totalSleep } / Double(sleepData.count)
        let avgEfficiency = sleepData.reduce(0) { $0 + $1.efficiency } / Double(sleepData.count)
        
        return (avgHours, avgEfficiency)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if let today = healthManager.todayData, let sleep = today.sleepData {
                        // Sleep Score Card
                        SleepScoreCard(data: today)
                            .padding(.horizontal)
                        
                        // Sleep Stages
                        SleepStagesCard(sleep: sleep)
                            .padding(.horizontal)
                        
                        // Sleep Debt
                        let weekData = Array(healthManager.healthData.suffix(7))
                        let debt = weekData.sleepDebt(targetHours: healthManager.settings.targetSleepHours)
                        SleepDebtDetailCard(debt: debt, targetHours: healthManager.settings.targetSleepHours)
                            .padding(.horizontal)
                        
                        // Sleep Trend
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Sleep Duration Trend")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            if #available(iOS 16.0, *) {
                                Chart(healthManager.healthData.suffix(14).filter { $0.sleepData != nil }) { data in
                                    BarMark(
                                        x: .value("Date", data.date, unit: .day),
                                        y: .value("Hours", data.sleepData?.totalSleep ?? 0)
                                    )
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.purple.opacity(0.6), .purple],
                                            startPoint: .bottom,
                                            endPoint: .top
                                        )
                                    )
                                    
                                    RuleMark(y: .value("Target", healthManager.settings.targetSleepHours))
                                        .foregroundStyle(.green.opacity(0.5))
                                        .lineStyle(StrokeStyle(lineWidth: 2, dash: [5, 5]))
                                }
                                .frame(height: 200)
                                .chartYScale(domain: 0...10)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(colorScheme == .dark ? Color(.systemGray6) : Color.white)
                                )
                                .padding(.horizontal)
                            }
                        }
                        
                        // Weekday vs Weekend
                        WeekdayWeekendComparison(
                            data: healthManager.healthData,
                            title: "Sleep Patterns",
                            keyPath: \.sleepData?.totalSleep,
                            unit: "hours",
                            format: "%.1f"
                        )
                        .padding(.horizontal)
                        
                    } else {
                        LoadingView()
                    }
                }
                .padding(.vertical)
            }
            .background(colorScheme == .dark ? Color.black : Color(.systemGroupedBackground))
            .navigationTitle("Sleep")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

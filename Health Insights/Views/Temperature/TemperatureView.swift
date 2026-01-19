// TemperatureView.swift
// Views/Temperature/TemperatureView.swift

import SwiftUI
import Charts

struct TemperatureView: View {
    @EnvironmentObject var healthManager: HealthKitManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if let today = healthManager.todayData {
                        // Current Temperature
                        TemperatureCard(data: today, settings: healthManager.settings)
                            .padding(.horizontal)
                        
                        // 14-Day Trend
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Temperature Trend")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            if #available(iOS 16.0, *) {
                                Chart(healthManager.healthData.filter { $0.temperatureDelta != nil }) { data in
                                    LineMark(
                                        x: .value("Date", data.date),
                                        y: .value("Delta", data.temperatureFahrenheitDelta ?? 0)
                                    )
                                    .foregroundStyle(Color.orange)
                                    .symbol(Circle())
                                    
                                    if data.illnessRisk >= 3 {
                                        PointMark(
                                            x: .value("Date", data.date),
                                            y: .value("Delta", data.temperatureFahrenheitDelta ?? 0)
                                        )
                                        .foregroundStyle(Color.red)
                                        .symbolSize(100)
                                    }
                                }
                                .frame(height: 220)
                                .chartYAxis {
                                    AxisMarks(position: .leading)
                                }
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
                            title: "Temperature Patterns",
                            keyPath: \.temperatureFahrenheitDelta,
                            unit: "°F",
                            format: "%+.2f"
                        )
                        .padding(.horizontal)
                        
                    } else {
                        LoadingView()
                    }
                }
                .padding(.vertical)
            }
            .background(colorScheme == .dark ? Color.black : Color(.systemGroupedBackground))
            .navigationTitle("Temperature")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

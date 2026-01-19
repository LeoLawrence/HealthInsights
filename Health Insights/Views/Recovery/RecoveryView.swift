// RecoveryView.swift
// Views/Recovery/RecoveryView.swift

import SwiftUI
import Charts

struct RecoveryView: View {
    @EnvironmentObject var healthManager: HealthKitManager
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if let today = healthManager.todayData {
                        // Recovery Score
                        RecoveryScoreCard(data: today)
                            .padding(.horizontal)
                        
                        // Contributing Factors
                        ContributingFactorsCard(data: today)
                            .padding(.horizontal)
                        
                        // 7-Day Trend
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Recovery Trend")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            if #available(iOS 16.0, *) {
                                Chart(healthManager.healthData.suffix(14)) { data in
                                    LineMark(
                                        x: .value("Date", data.date),
                                        y: .value("Score", data.recoveryScore)
                                    )
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.blue, .cyan],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .symbol(Circle())
                                    
                                    AreaMark(
                                        x: .value("Date", data.date),
                                        y: .value("Score", data.recoveryScore)
                                    )
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.blue.opacity(0.3), .clear],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                }
                                .frame(height: 200)
                                .chartYScale(domain: 0...100)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(colorScheme == .dark ? Color(.systemGray6) : Color.white)
                                )
                                .padding(.horizontal)
                            }
                        }
                        
                        // Week Comparison
                        WeekComparisonCard(
                            thisWeek: Array(healthManager.healthData.suffix(7)),
                            lastWeek: Array(healthManager.healthData.dropLast(7).suffix(7))
                        )
                        .padding(.horizontal)
                        
                    } else {
                        LoadingView()
                    }
                }
                .padding(.vertical)
            }
            .background(colorScheme == .dark ? Color.black : Color(.systemGroupedBackground))
            .navigationTitle("Recovery")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

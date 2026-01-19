// HomeView.swift
// Views/Home/HomeView.swift

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var healthManager: HealthKitManager
    @Binding var selectedTab: Int
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Health Insights")
                            .font(.system(size: 34, weight: .bold))
                        Text(Date().formatted(date: .complete, time: .omitted))
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    if let today = healthManager.todayData {
                        // Hero Readiness Card
                        ReadinessHeroCard(data: today)
                            .padding(.horizontal)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedTab = 2
                                }
                            }
                        
                        // Illness Alert
                        if today.illnessRisk >= 3 {
                            IllnessAlertCard(riskLevel: today.illnessRisk)
                                .padding(.horizontal)
                        }
                        
                        // Quick Insights
                        InsightCarousel(data: today, allData: healthManager.healthData)
                            .padding(.leading)
                        
                        // Quick Stats Grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            QuickStatCard(
                                title: "Sleep Score",
                                value: "\(today.sleepScore)",
                                subtitle: "Quality",
                                icon: "moon.stars.fill",
                                color: .purple,
                                gradient: [Color.purple.opacity(0.6), Color.purple]
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedTab = 3
                                }
                            }
                            
                            if let hrv = today.hrv {
                                QuickStatCard(
                                    title: "HRV",
                                    value: String(format: "%.0f", hrv),
                                    subtitle: "ms",
                                    icon: "waveform.path.ecg",
                                    color: .pink,
                                    gradient: [Color.pink.opacity(0.6), Color.pink]
                                )
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3)) {
                                        selectedTab = 2
                                    }
                                }
                            }
                            
                            if let tempDelta = today.temperatureFahrenheitDelta {
                                QuickStatCard(
                                    title: "Temperature",
                                    value: String(format: "%+.1f°F", tempDelta),
                                    subtitle: "from baseline",
                                    icon: "thermometer.medium",
                                    color: .orange,
                                    gradient: [Color.orange.opacity(0.6), Color.orange]
                                )
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3)) {
                                        selectedTab = 1
                                    }
                                }
                            }
                            
                            if let strain = today.strainScore {
                                QuickStatCard(
                                    title: "Strain",
                                    value: String(format: "%.1f", strain),
                                    subtitle: "/ 21",
                                    icon: "flame.fill",
                                    color: .red,
                                    gradient: [Color.red.opacity(0.6), Color.red]
                                )
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3)) {
                                        selectedTab = 4
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Sleep Debt
                        let weekData = Array(healthManager.healthData.suffix(7))
                        let sleepDebt = weekData.sleepDebt(targetHours: healthManager.settings.targetSleepHours)
                        if sleepDebt != 0 {
                            SleepDebtCard(debt: sleepDebt)
                                .padding(.horizontal)
                        }
                    } else {
                        LoadingView()
                    }
                }
                .padding(.vertical)
            }
            .background(colorScheme == .dark ? Color.black : Color(.systemGroupedBackground))
        }
    }
}

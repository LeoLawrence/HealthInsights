// ContentView.swift
// Main content view with tab navigation

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var healthManager: HealthKitManager
    @State private var selectedTab = 0
    @State private var showSettings = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            TemperatureView()
                .tabItem {
                    Label("Temp", systemImage: "thermometer.medium")
                }
                .tag(1)
            
            RecoveryView()
                .tabItem {
                    Label("Recovery", systemImage: "heart.fill")
                }
                .tag(2)
            
            SleepView()
                .tabItem {
                    Label("Sleep", systemImage: "moon.fill")
                }
                .tag(3)
            
            InsightsView()
                .tabItem {
                    Label("Insights", systemImage: "chart.xyaxis.line")
                }
                .tag(4)
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width < -50 && selectedTab < 4 {
                        withAnimation { selectedTab += 1 }
                    } else if value.translation.width > 50 && selectedTab > 0 {
                        withAnimation { selectedTab -= 1 }
                    }
                }
        )
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(healthManager)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showSettings = true }) {
                    Image(systemName: "gear")
                }
            }
        }
    }
}

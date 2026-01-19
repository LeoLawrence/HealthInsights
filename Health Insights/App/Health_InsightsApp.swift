// Health_InsightsApp.swift
// App/Health_InsightsApp.swift

import SwiftUI

@main
struct Health_InsightsApp: App {
    @StateObject private var healthManager = HealthKitManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthManager)
                .onAppear {
                    healthManager.requestAuthorization()
                }
        }
    }
}

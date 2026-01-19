// SettingsView.swift
// App settings screen

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var healthManager: HealthKitManager
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("Sync Settings") {
                    Picker("Update Frequency", selection: $healthManager.settings.syncFrequency) {
                        ForEach(SyncFrequency.allCases, id: \.self) { freq in
                            Text(freq.rawValue).tag(freq)
                        }
                    }
                }
                
                Section("Sleep Settings") {
                    Stepper("Target Sleep: \(String(format: "%.1f", healthManager.settings.targetSleepHours))h",
                            value: $healthManager.settings.targetSleepHours,
                            in: 6...10,
                            step: 0.5)
                }
                
                Section("Temperature Display") {
                    Toggle("Show Absolute Temperature", isOn: $healthManager.settings.showAbsoluteTemp)
                    Text("Note: Absolute temperatures may be inaccurate. Delta values are more reliable.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

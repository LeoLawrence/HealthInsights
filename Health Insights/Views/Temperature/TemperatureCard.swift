// TemperatureCard.swift
// Views/Temperature/TemperatureCard.swift

import SwiftUI

struct TemperatureCard: View {
    let data: HealthData
    let settings: AppSettings
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Wrist Temperature")
                    .font(.headline)
                Spacer()
                Image(systemName: "thermometer.medium")
                    .foregroundColor(.orange)
            }
            
            if let delta = data.temperatureFahrenheitDelta {
                VStack(alignment: .leading, spacing: 12) {
                    // Delta Display
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text(String(format: "%+.2f°F", delta))
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(abs(delta) > 1.0 ? .orange : .primary)
                        Text("from baseline")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Absolute temp (if enabled)
                    if settings.showAbsoluteTemp, let absTemp = data.absoluteTemperatureFahrenheit {
                        Text("Absolute: \(String(format: "%.1f°F", absTemp))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    // Status indicator
                    HStack(spacing: 8) {
                        Circle()
                            .fill(statusColor(delta: delta))
                            .frame(width: 12, height: 12)
                        Text(statusText(delta: delta))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Illness warning
                    if abs(delta) > 1.0 || data.illnessRisk >= 3 {
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.orange)
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Temperature Change Detected")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Text("Monitor for symptoms and consider rest if you feel unwell.")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.orange.opacity(0.1))
                        )
                    }
                }
            } else {
                Text("No temperature data available")
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? Color(.systemGray6) : Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
        )
    }
    
    private func statusColor(delta: Double) -> Color {
        if abs(delta) > 1.5 { return .red }
        if abs(delta) > 1.0 { return .orange }
        if abs(delta) > 0.5 { return .yellow }
        return .green
    }
    
    private func statusText(delta: Double) -> String {
        if abs(delta) > 1.5 { return "Significant change" }
        if abs(delta) > 1.0 { return "Elevated" }
        if abs(delta) > 0.5 { return "Slightly elevated" }
        return "Normal range"
    }
}

// SleepDebtCard.swift
// Views/Home/SleepDebtCard.swift

import SwiftUI

struct SleepDebtCard: View {
    let debt: Double
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: debt > 0 ? "minus.circle.fill" : "plus.circle.fill")
                .font(.title)
                .foregroundColor(debt > 0 ? .orange : .green)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Sleep Bank")
                    .font(.headline)
                Text(debt > 0 ? "You owe \(String(format: "%.1f", debt))h of sleep" : "Sleep surplus of \(String(format: "%.1f", abs(debt)))h")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(colorScheme == .dark ? Color(.systemGray6) : Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
        )
    }
}

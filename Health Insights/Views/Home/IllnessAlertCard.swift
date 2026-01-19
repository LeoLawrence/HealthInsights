// IllnessAlertCard.swift
// Views/Home/IllnessAlertCard.swift

import SwiftUI

struct IllnessAlertCard: View {
    let riskLevel: Int
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.title2)
                .foregroundColor(.red)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Potential Illness Detected")
                    .font(.headline)
                    .foregroundColor(.red)
                Text("We detected \(riskLevel) health indicators suggesting you may be getting sick. Consider rest and monitor symptoms.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.red.opacity(colorScheme == .dark ? 0.15 : 0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color.red.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

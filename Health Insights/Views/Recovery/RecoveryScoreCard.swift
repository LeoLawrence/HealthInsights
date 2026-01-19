// RecoveryScoreCard.swift
// Views/Recovery/RecoveryScoreCard.swift

import SwiftUI

struct RecoveryScoreCard: View {
    let data: HealthData
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Recovery Score")
                .font(.headline)
            
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 18)
                    .frame(width: 200, height: 200)
                
                Circle()
                    .trim(from: 0, to: CGFloat(data.recoveryScore) / 100)
                    .stroke(
                        AngularGradient(
                            colors: gradientColors(for: data.recoveryCategory),
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 18, lineCap: .round)
                    )
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 1.0), value: data.recoveryScore)
                
                VStack(spacing: 4) {
                    Text("\(data.recoveryScore)")
                        .font(.system(size: 56, weight: .bold))
                    Text(data.recoveryCategory.label)
                        .font(.subheadline)
                        .foregroundColor(categoryColor(data.recoveryCategory))
                }
            }
            
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(categoryColor(data.recoveryCategory))
                Text(data.recoveryCategory.recoveryRecommendation)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(categoryColor(data.recoveryCategory).opacity(0.1))
            )
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? Color(.systemGray6) : Color.white)
                .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
        )
    }
    
    private func categoryColor(_ category: RecoveryCategory) -> Color {
        switch category {
        case .optimal: return .green
        case .good: return .blue
        case .fair: return .yellow
        case .poor: return .red
        }
    }
    
    private func gradientColors(for category: RecoveryCategory) -> [Color] {
        switch category {
        case .optimal: return [.green, .mint, .green]
        case .good: return [.blue, .cyan, .blue]
        case .fair: return [.yellow, .orange, .yellow]
        case .poor: return [.red, .pink, .red]
        }
    }
}

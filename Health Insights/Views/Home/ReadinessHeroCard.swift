// ReadinessHeroCard.swift
// Views/Home/ReadinessHeroCard.swift

import SwiftUI

struct ReadinessHeroCard: View {
    let data: HealthData
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Readiness")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text(data.readinessCategory.readinessRecommendation)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
            }
            
            HStack(alignment: .center, spacing: 30) {
                // Score Circle
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 16)
                        .frame(width: 130, height: 130)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(data.readinessScore) / 100)
                        .stroke(
                            AngularGradient(
                                colors: gradientColors(for: data.readinessCategory),
                                center: .center,
                                startAngle: .degrees(0),
                                endAngle: .degrees(360)
                            ),
                            style: StrokeStyle(lineWidth: 16, lineCap: .round)
                        )
                        .frame(width: 130, height: 130)
                        .rotationEffect(.degrees(-90))
                    
                    VStack(spacing: 2) {
                        Text("\(data.readinessScore)")
                            .font(.system(size: 42, weight: .bold))
                        Text(data.readinessCategory.label)
                            .font(.caption)
                            .foregroundColor(categoryColor(data.readinessCategory))
                    }
                }
                
                // Contributing Scores
                VStack(alignment: .leading, spacing: 12) {
                    ScoreRow(title: "Recovery", score: data.recoveryScore, color: .blue)
                    ScoreRow(title: "Sleep", score: data.sleepScore, color: .purple)
                    if let strain = data.strainScore {
                        ScoreRow(title: "Strain", score: Int((1 - strain / 21) * 100), color: .orange)
                    }
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(colorScheme == .dark ? Color(.systemGray6) : Color.white)
                .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
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
        case .optimal: return [.green, .mint]
        case .good: return [.blue, .cyan]
        case .fair: return [.yellow, .orange]
        case .poor: return [.red, .pink]
        }
    }
}

struct ScoreRow: View {
    let title: String
    let score: Int
    let color: Color
    
    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
            Text("\(score)")
                .font(.caption)
                .fontWeight(.semibold)
        }
        .frame(width: 120)
    }
}

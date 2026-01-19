// RecoveryCategory.swift
// Models/RecoveryCategory.swift

import Foundation

enum RecoveryCategory {
    case optimal, good, fair, poor
    
    var label: String {
        switch self {
        case .optimal: return "Optimal"
        case .good: return "Good"
        case .fair: return "Fair"
        case .poor: return "Poor"
        }
    }
    
    var color: String {
        switch self {
        case .optimal: return "green"
        case .good: return "blue"
        case .fair: return "yellow"
        case .poor: return "red"
        }
    }
    
    var recoveryRecommendation: String {
        switch self {
        case .optimal:
            return "Excellent recovery! Your body is primed for high-intensity training."
        case .good:
            return "Good recovery. You can handle moderate to challenging workouts today."
        case .fair:
            return "Fair recovery. Consider lighter activities or active recovery sessions."
        case .poor:
            return "Low recovery detected. Prioritize rest, quality sleep, and stress management."
        }
    }
    
    var readinessRecommendation: String {
        switch self {
        case .optimal:
            return "You're ready to perform at your best today. Great time for important tasks."
        case .good:
            return "You're in good shape today. Maintain your routine and stay consistent."
        case .fair:
            return "You're okay but not optimal. Don't push too hard and listen to your body."
        case .poor:
            return "Your body needs recovery. Take it easy and focus on restoration."
        }
    }
}

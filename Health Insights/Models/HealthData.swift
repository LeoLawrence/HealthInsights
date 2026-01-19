// HealthData.swift
// Models/HealthData.swift

import Foundation

struct HealthData: Identifiable {
    let id = UUID()
    let date: Date
    var hrv: Double?
    var restingHR: Double?
    var temperatureDelta: Double? // Celsius delta from baseline
    var respiratoryRate: Double?
    var sleepData: SleepData?
    var strainScore: Double?
    var illnessRisk: Int = 0
    var isAnomaly: Bool = false
    
    // MARK: - Temperature Conversions
    var temperatureFahrenheitDelta: Double? {
        temperatureDelta.map { $0 * 9/5 }
    }
    
    var absoluteTemperatureFahrenheit: Double? {
        temperatureDelta.map { (36.5 + $0) * 9/5 + 32 }
    }
    
    // MARK: - Sleep Score (Research-based)
    var sleepScore: Int {
        guard let sleep = sleepData else { return 0 }
        
        let totalSleep = sleep.totalSleep
        let efficiency = sleep.efficiency
        let deepPercent = (sleep.deepSleep / totalSleep) * 100
        let remPercent = (sleep.remSleep / totalSleep) * 100
        
        // Total sleep time (25%): 7-9 hours optimal
        var sleepTimeScore = 0.0
        if totalSleep >= 7 && totalSleep <= 9 {
            sleepTimeScore = 100.0
        } else if totalSleep >= 6 && totalSleep < 7 {
            sleepTimeScore = 70.0
        } else if totalSleep >= 5 && totalSleep < 6 {
            sleepTimeScore = 50.0
        } else {
            sleepTimeScore = 30.0
        }
        
        // Sleep efficiency (20%): >85% optimal
        let efficiencyScore = min(efficiency, 100.0)
        
        // Deep sleep (20%): 13-23% of total optimal
        var deepScore = 0.0
        if deepPercent >= 13 && deepPercent <= 23 {
            deepScore = 100.0
        } else if deepPercent >= 10 && deepPercent < 13 {
            deepScore = 70.0
        } else {
            deepScore = 40.0
        }
        
        // REM sleep (15%): 20-25% of total optimal
        var remScore = 0.0
        if remPercent >= 20 && remPercent <= 25 {
            remScore = 100.0
        } else if remPercent >= 15 && remPercent < 20 {
            remScore = 70.0
        } else {
            remScore = 40.0
        }
        
        // Awakenings (10%): Fewer is better
        var awakeScore = 100.0
        if sleep.awakenings <= 1 {
            awakeScore = 100.0
        } else if sleep.awakenings <= 3 {
            awakeScore = 70.0
        } else if sleep.awakenings <= 5 {
            awakeScore = 50.0
        } else {
            awakeScore = 30.0
        }
        
        // Sleep consistency (10%): Would need historical data - using placeholder
        let consistencyScore = 75.0
        
        let totalScore = (sleepTimeScore * 0.25) +
                        (efficiencyScore * 0.20) +
                        (deepScore * 0.20) +
                        (remScore * 0.15) +
                        (awakeScore * 0.10) +
                        (consistencyScore * 0.10)
        
        return Int(totalScore)
    }
    
    // MARK: - Recovery Score
    var recoveryScore: Int {
        guard let hrv = hrv,
              let rhr = restingHR else {
            return 0
        }
        
        let hrvScore = min((hrv / 80) * 100, 100)
        let sleepScoreValue = Double(sleepScore)
        let rhrScore = max(100 - ((rhr - 50) / 30) * 100, 0)
        
        // HRV 40%, Sleep 40%, RHR 20%
        let total = (hrvScore * 0.4) + (sleepScoreValue * 0.4) + (rhrScore * 0.2)
        return Int(total)
    }
    
    // MARK: - Readiness Score (Oura-style)
    var readinessScore: Int {
        guard let sleep = sleepData else { return 0 }
        
        let recoveryValue = Double(recoveryScore)
        let sleepValue = Double(sleepScore)
        let strainValue = strainScore.map { 100 - ($0 / 21 * 100) } ?? 80
        
        // Recovery 50%, Sleep 30%, Low Strain 20%
        let total = (recoveryValue * 0.5) + (sleepValue * 0.3) + (strainValue * 0.2)
        return Int(total)
    }
    
    // MARK: - Category Helpers
    var recoveryCategory: RecoveryCategory {
        let score = recoveryScore
        if score >= 85 { return .optimal }
        if score >= 70 { return .good }
        if score >= 50 { return .fair }
        return .poor
    }
    
    var readinessCategory: RecoveryCategory {
        let score = readinessScore
        if score >= 85 { return .optimal }
        if score >= 70 { return .good }
        if score >= 50 { return .fair }
        return .poor
    }
}

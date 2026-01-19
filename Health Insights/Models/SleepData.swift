// SleepData.swift
// Models/SleepData.swift

import Foundation

struct SleepData {
    let deepSleep: Double
    let remSleep: Double
    let coreSleep: Double
    let awake: Double
    let inBed: Double
    let awakenings: Int
    
    var totalSleep: Double {
        deepSleep + remSleep + coreSleep
    }
    
    var efficiency: Double {
        inBed > 0 ? (totalSleep / inBed) * 100 : 0
    }
}

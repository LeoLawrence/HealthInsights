// AppSettings.swift
// Models/AppSettings.swift

import Foundation

struct AppSettings {
    var syncFrequency: SyncFrequency = .hourly
    var targetSleepHours: Double = 8.0
    var showAbsoluteTemp: Bool = false
}

enum SyncFrequency: String, CaseIterable {
    case immediate = "Real-time"
    case hourly = "Hourly"
    case daily = "Daily"
}

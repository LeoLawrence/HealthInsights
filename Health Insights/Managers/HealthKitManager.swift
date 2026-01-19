// HealthKitManager.swift
// Managers/HealthKitManager.swift

import Foundation
import HealthKit
import Combine

class HealthKitManager: ObservableObject {
    private let healthStore = HKHealthStore()
    
    @Published var isAuthorized = false
    @Published var healthData: [HealthData] = []
    @Published var todayData: HealthData?
    @Published var settings = AppSettings()
    
    private let typesToRead: Set<HKObjectType> = [
        HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
        HKObjectType.quantityType(forIdentifier: .restingHeartRate)!,
        HKObjectType.quantityType(forIdentifier: .appleSleepingWristTemperature)!,
        HKObjectType.quantityType(forIdentifier: .respiratoryRate)!,
        HKObjectType.quantityType(forIdentifier: .heartRate)!,
        HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
        HKObjectType.quantityType(forIdentifier: .stepCount)!,
        HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
        HKObjectType.workoutType()
    ]
    
    // MARK: - Authorization
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        healthStore.requestAuthorization(toShare: [], read: typesToRead) { success, error in
            DispatchQueue.main.async {
                self.isAuthorized = success
                if success {
                    self.fetchHealthData()
                    self.setupBackgroundDelivery()
                }
            }
        }
    }
    
    // MARK: - Fetch Health Data
    func fetchHealthData() {
        let calendar = Calendar.current
        let now = Date()
        let days = 30
        
        let group = DispatchGroup()
        var dailyData: [Date: HealthData] = [:]
        
        for i in 0..<days {
            guard let date = calendar.date(byAdding: .day, value: -i, to: now) else { continue }
            let dayStart = calendar.startOfDay(for: date)
            let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)!
            
            dailyData[dayStart] = HealthData(date: dayStart)
            
            group.enter()
            fetchHRV(start: dayStart, end: dayEnd) { hrv in
                dailyData[dayStart]?.hrv = hrv
                group.leave()
            }
            
            group.enter()
            fetchRestingHeartRate(start: dayStart, end: dayEnd) { rhr in
                dailyData[dayStart]?.restingHR = rhr
                group.leave()
            }
            
            group.enter()
            fetchWristTemperatureDelta(start: dayStart, end: dayEnd) { delta in
                dailyData[dayStart]?.temperatureDelta = delta
                group.leave()
            }
            
            group.enter()
            fetchRespiratoryRate(start: dayStart, end: dayEnd) { rr in
                dailyData[dayStart]?.respiratoryRate = rr
                group.leave()
            }
            
            group.enter()
            fetchSleepData(start: dayStart, end: dayEnd) { sleep in
                dailyData[dayStart]?.sleepData = sleep
                group.leave()
            }
            
            group.enter()
            fetchDailyStrain(start: dayStart, end: dayEnd) { strain in
                dailyData[dayStart]?.strainScore = strain
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.healthData = dailyData.values.sorted { $0.date < $1.date }
            self.todayData = self.healthData.last
            self.detectAnomalies()
        }
    }
    
    // MARK: - Individual Data Fetchers
    private func fetchHRV(start: Date, end: Date, completion: @escaping (Double?) -> Void) {
        guard let hrvType = HKQuantityType.quantityType(forIdentifier: .heartRateVariabilitySDNN) else {
            completion(nil)
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: hrvType, quantitySamplePredicate: predicate, options: .discreteAverage) { _, result, _ in
            guard let result = result, let average = result.averageQuantity() else {
                completion(nil)
                return
            }
            completion(average.doubleValue(for: HKUnit.secondUnit(with: .milli)))
        }
        healthStore.execute(query)
    }
    
    private func fetchRestingHeartRate(start: Date, end: Date, completion: @escaping (Double?) -> Void) {
        guard let rhrType = HKQuantityType.quantityType(forIdentifier: .restingHeartRate) else {
            completion(nil)
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: rhrType, quantitySamplePredicate: predicate, options: .discreteAverage) { _, result, _ in
            guard let result = result, let average = result.averageQuantity() else {
                completion(nil)
                return
            }
            completion(average.doubleValue(for: HKUnit.count().unitDivided(by: .minute())))
        }
        healthStore.execute(query)
    }
    
    private func fetchWristTemperatureDelta(start: Date, end: Date, completion: @escaping (Double?) -> Void) {
        guard let tempType = HKQuantityType.quantityType(forIdentifier: .appleSleepingWristTemperature) else {
            completion(nil)
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: tempType, quantitySamplePredicate: predicate, options: .discreteAverage) { _, result, _ in
            guard let result = result, let average = result.averageQuantity() else {
                completion(nil)
                return
            }
            completion(average.doubleValue(for: HKUnit.degreeCelsius()))
        }
        healthStore.execute(query)
    }
    
    private func fetchRespiratoryRate(start: Date, end: Date, completion: @escaping (Double?) -> Void) {
        guard let rrType = HKQuantityType.quantityType(forIdentifier: .respiratoryRate) else {
            completion(nil)
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: rrType, quantitySamplePredicate: predicate, options: .discreteAverage) { _, result, _ in
            guard let result = result, let average = result.averageQuantity() else {
                completion(nil)
                return
            }
            completion(average.doubleValue(for: HKUnit.count().unitDivided(by: .minute())))
        }
        healthStore.execute(query)
    }
    
    private func fetchSleepData(start: Date, end: Date, completion: @escaping (SleepData?) -> Void) {
        guard let sleepType = HKCategoryType.categoryType(forIdentifier: .sleepAnalysis) else {
            completion(nil)
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, samples, _ in
            guard let samples = samples as? [HKCategorySample] else {
                completion(nil)
                return
            }
            
            var deepSleep: TimeInterval = 0
            var remSleep: TimeInterval = 0
            var coreSleep: TimeInterval = 0
            var awake: TimeInterval = 0
            var inBed: TimeInterval = 0
            var awakenings = 0
            var lastAwakeTime: Date?
            
            for sample in samples {
                let duration = sample.endDate.timeIntervalSince(sample.startDate)
                
                if #available(iOS 16.0, *) {
                    switch sample.value {
                    case HKCategoryValueSleepAnalysis.asleepDeep.rawValue:
                        deepSleep += duration
                    case HKCategoryValueSleepAnalysis.asleepREM.rawValue:
                        remSleep += duration
                    case HKCategoryValueSleepAnalysis.asleepCore.rawValue:
                        coreSleep += duration
                    case HKCategoryValueSleepAnalysis.awake.rawValue:
                        awake += duration
                        if let last = lastAwakeTime, sample.startDate.timeIntervalSince(last) > 300 {
                            awakenings += 1
                        }
                        lastAwakeTime = sample.endDate
                    case HKCategoryValueSleepAnalysis.inBed.rawValue:
                        inBed += duration
                    default:
                        break
                    }
                }
            }
            
            let totalSleep = deepSleep + remSleep + coreSleep
            let totalInBed = max(inBed, totalSleep + awake)
            
            let sleepData = SleepData(
                deepSleep: deepSleep / 3600,
                remSleep: remSleep / 3600,
                coreSleep: coreSleep / 3600,
                awake: awake / 3600,
                inBed: totalInBed / 3600,
                awakenings: awakenings
            )
            
            completion(sleepData)
        }
        healthStore.execute(query)
    }
    
    private func fetchDailyStrain(start: Date, end: Date, completion: @escaping (Double?) -> Void) {
        guard let hrType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            completion(nil)
            return
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: hrType, quantitySamplePredicate: predicate, options: .discreteAverage) { _, result, _ in
            guard let result = result, let average = result.averageQuantity() else {
                completion(nil)
                return
            }
            
            let avgHR = average.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))
            let strain = min(max((avgHR - 60) / 100 * 21, 0), 21)
            completion(strain)
        }
        healthStore.execute(query)
    }
    
    // MARK: - Background Delivery
    private func setupBackgroundDelivery() {
        let frequency: HKUpdateFrequency = {
            switch settings.syncFrequency {
            case .immediate: return .immediate
            case .hourly: return .hourly
            case .daily: return .daily
            }
        }()
        
        let types: [HKQuantityType] = [
            HKObjectType.quantityType(forIdentifier: .heartRateVariabilitySDNN)!,
            HKObjectType.quantityType(forIdentifier: .restingHeartRate)!,
            HKObjectType.quantityType(forIdentifier: .appleSleepingWristTemperature)!,
            HKObjectType.quantityType(forIdentifier: .respiratoryRate)!
        ]
        
        for type in types {
            healthStore.enableBackgroundDelivery(for: type, frequency: frequency) { _, _ in }
        }
    }
    
    // MARK: - Anomaly Detection
    private func detectAnomalies() {
        for i in 0..<healthData.count {
            var data = healthData[i]
            data.illnessRisk = detectIllness(for: data, index: i)
            data.isAnomaly = detectUnusualPattern(for: data, index: i)
            healthData[i] = data
        }
    }
    
    private func detectIllness(for data: HealthData, index: Int) -> Int {
        var indicators = 0
        let baseline = getBaseline(upToIndex: index)
        
        // Temperature spike
        if let tempDelta = data.temperatureDelta {
            if abs(tempDelta) > 1.0 {
                indicators += 1
            }
            if index > 0, let prevDelta = healthData[index - 1].temperatureDelta {
                if abs(tempDelta - prevDelta) > 0.7 {
                    indicators += 1
                }
            }
        }
        
        // HRV drop
        if let hrv = data.hrv, let baselineHRV = baseline.hrv {
            if hrv < baselineHRV * 0.85 {
                indicators += 1
            }
        }
        
        // Resting HR increase
        if let rhr = data.restingHR, let baselineRHR = baseline.restingHR {
            if rhr > baselineRHR * 1.10 {
                indicators += 1
            }
        }
        
        // Respiratory rate increase
        if let rr = data.respiratoryRate, let baselineRR = baseline.respiratoryRate {
            if rr > baselineRR * 1.15 {
                indicators += 1
            }
        }
        
        // Poor sleep efficiency
        if let sleep = data.sleepData, sleep.efficiency < 70 {
            indicators += 1
        }
        
        return indicators
    }
    
    private func detectUnusualPattern(for data: HealthData, index: Int) -> Bool {
        let baseline = getBaseline(upToIndex: index)
        var unusualCount = 0
        
        if let hrv = data.hrv, let baselineHRV = baseline.hrv {
            if abs(hrv - baselineHRV) > baselineHRV * 0.3 {
                unusualCount += 1
            }
        }
        
        if let rhr = data.restingHR, let baselineRHR = baseline.restingHR {
            if abs(rhr - baselineRHR) > baselineRHR * 0.2 {
                unusualCount += 1
            }
        }
        
        return unusualCount >= 2
    }
    
    private func getBaseline(upToIndex: Int) -> (hrv: Double?, restingHR: Double?, respiratoryRate: Double?) {
        let recentData = healthData.prefix(upToIndex).suffix(14)
        
        let hrvValues = recentData.compactMap { $0.hrv }
        let rhrValues = recentData.compactMap { $0.restingHR }
        let rrValues = recentData.compactMap { $0.respiratoryRate }
        
        return (
            hrv: hrvValues.isEmpty ? nil : hrvValues.reduce(0, +) / Double(hrvValues.count),
            restingHR: rhrValues.isEmpty ? nil : rhrValues.reduce(0, +) / Double(rhrValues.count),
            respiratoryRate: rrValues.isEmpty ? nil : rrValues.reduce(0, +) / Double(rrValues.count)
        )
    }
}

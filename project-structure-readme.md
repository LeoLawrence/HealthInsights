# Health Insights - Project Structure

## File Organization

```
Health Insights/
├── App/
│   └── Health_InsightsApp.swift           (Already exists - update it)
│
├── Managers/
│   └── HealthKitManager.swift             (File 6)
│
├── Models/
│   ├── HealthData.swift                   (File 1)
│   ├── SleepData.swift                    (File 2)
│   ├── RecoveryCategory.swift             (File 3)
│   └── AppSettings.swift                  (File 4)
│
├── Extensions/
│   └── Array+Health.swift                 (File 5)
│
├── Views/
│   ├── ContentView.swift                  (File 30)
│   ├── SettingsView.swift                 (File 31)
│   │
│   ├── Home/
│   │   ├── HomeView.swift                 (File 8)
│   │   ├── ReadinessHeroCard.swift        (File 9)
│   │   ├── IllnessAlertCard.swift         (File 10)
│   │   ├── InsightCarousel.swift          (File 11)
│   │   ├── QuickStatCard.swift            (File 12)
│   │   └── SleepDebtCard.swift            (File 13)
│   │
│   ├── Temperature/
│   │   ├── TemperatureView.swift          (File 14)
│   │   └── TemperatureCard.swift          (File 15)
│   │
│   ├── Recovery/
│   │   ├── RecoveryView.swift             (File 16)
│   │   ├── RecoveryScoreCard.swift        (File 17)
│   │   ├── ContributingFactorsCard.swift  (File 18)
│   │   └── WeekComparisonCard.swift       (File 19)
│   │
│   ├── Sleep/
│   │   ├── SleepView.swift                (File 21)
│   │   ├── SleepScoreCard.swift           (File 22)
│   │   ├── SleepStagesCard.swift          (File 23)
│   │   └── SleepDebtDetailCard.swift      (File 24)
│   │
│   ├── Insights/
│   │   ├── InsightsView.swift             (File 26)
│   │   ├── InsightDetailCard.swift        (File 27)
│   │   ├── CorrelationCard.swift          (File 28)
│   │   └── AnomalyCard.swift              (File 29)
│   │
│   └── Shared/
│       ├── LoadingView.swift              (File 7)
│       ├── FactorRow.swift                (File 20)
│       └── WeekdayWeekendComparison.swift (File 25)
│
└── Info.plist (Configure in Xcode settings)
```

## Setup Instructions

### 1. Update Health_InsightsApp.swift

Replace the contents with:

```swift
import SwiftUI

@main
struct Health_InsightsApp: App {
    @StateObject private var healthManager = HealthKitManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(healthManager)
                .onAppear {
                    healthManager.requestAuthorization()
                }
        }
    }
}
```

### 2. Add HealthKit Privacy Keys

1. Select your project in Xcode
2. Select your target
3. Go to the "Info" tab
4. Click "+" to add these keys:
   - `Privacy - Health Share Usage Description` = "This app needs access to your health data to provide insights on temperature, recovery, and sleep quality."
   - `Privacy - Health Update Usage Description` = "This app needs to update your health data."

### 3. Enable HealthKit Capability

1. Select your project
2. Go to "Signing & Capabilities"
3. Click "+ Capability"
4. Add "HealthKit"

### 4. Set Minimum iOS Version

- Go to project settings → General → Deployment Info
- Set iOS Deployment Target to **iOS 16.0** or later

### 5. Build and Run

- **MUST use a physical iPhone** (HealthKit doesn't work in simulator)
- Ensure Apple Watch is paired and has synced data
- Grant HealthKit permissions when prompted

## Features Implemented

### ✅ Core Features
- **Temperature Tracking**: Delta-based with illness detection
- **Sleep Score**: Research-based algorithm (total time, efficiency, stages, awakenings)
- **Recovery Score**: HRV (40%), Sleep (40%), RHR (20%)
- **Readiness Score**: Oura-style combining recovery, sleep, and strain
- **Strain Score**: Whoop-style 0-21 scale
- **Sleep Debt**: 7-day tracking with recommendations
- **Illness Detection**: Multi-factor algorithm (5 indicators)

### ✅ UI/UX Enhancements
- Tappable cards that navigate to tabs
- Swipe gestures between tabs
- Animated charts and progress indicators
- Light/dark mode support
- Glassmorphism and gradient effects
- Settings page for customization

### ✅ Smart Insights
- HRV trends and analysis
- Sleep consistency tracking
- Recovery trending
- Temperature-sleep correlations
- Weekend vs weekday patterns
- Anomaly detection
- Personalized recommendations

## Troubleshooting

### No Data Showing
- Wear Apple Watch for a few nights to collect sleep data
- Check Apple Health app to verify data exists
- Ensure HealthKit permissions were granted

### Build Errors
- Make sure all files are in the correct folders
- Check that HealthKit capability is enabled
- Verify Info.plist keys are added
- Clean build folder (Cmd+Shift+K)

### Runtime Crashes
- Ensure running on physical device, not simulator
- Check that all @EnvironmentObject dependencies are provided
- Verify iOS deployment target is set correctly

## Next Steps

After everything is working:
1. Test with your real Apple Watch data
2. Customize settings (sync frequency, sleep target)
3. Review insights and correlations
4. Add notifications for illness alerts (future feature)
5. Export data capabilities (future feature)

## Notes

- Temperature readings are delta values (changes from baseline) for accuracy
- Sleep score uses research-based weighting factors
- Recovery score prioritizes HRV and Sleep equally
- Illness detection requires 3+ risk factors to trigger alert
- Data is fetched for last 30 days on app launch
- Background updates occur based on sync frequency setting

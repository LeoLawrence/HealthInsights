# Health Insights

A beautiful, Apple-inspired health tracking app for iOS that provides advanced insights into your sleep, recovery, and overall wellness using Apple Watch data.

![iOS](https://img.shields.io/badge/iOS-16.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## Features

### Core Metrics

- **Readiness Score** - Oura-style daily readiness combining recovery, sleep quality, and strain
- **Recovery Score** - Research-based algorithm weighing HRV (40%), Sleep (40%), and Resting Heart Rate (20%)
- **Sleep Score** - Comprehensive analysis of sleep duration, efficiency, stages, and awakenings
- **Temperature Tracking** - Delta-based wrist temperature monitoring with illness detection
- **Strain Score** - Whoop-style 0-21 daily strain measurement

### Smart Insights

- **Illness Detection** - Multi-factor algorithm detecting potential illness 24-48 hours early
- **Pattern Recognition** - Identifies trends in HRV, sleep, and recovery over time
- **Correlations** - Discovers relationships between sleep quality, HRV, and temperature
- **Weekend vs Weekday** - Automatic comparison of health patterns
- **Sleep Debt Tracking** - 7-day sleep bank with personalized recommendations
- **Anomaly Detection** - Flags unusual health patterns for review

### Beautiful Design

- Clean, minimal interface inspired by Apple Health
- Dark mode support
- Animated charts and progress indicators
- Glassmorphism effects and gradients
- Smooth transitions and haptic feedback
- Tappable cards with gesture navigation

## Screenshots

_Coming soon_

## Requirements

- iOS 18.0+
- Xcode 15.0+
- Apple Watch Series 8+ (for temperature data)
- watchOS 9.0+ (for sleep stage detection)
- Physical iPhone device (HealthKit not available in simulator)

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/leolawrence/health-insights.git
cd health-insights
```

### 2. Open in Xcode

```bash
open "Health Insights.xcodeproj"
```

### 3. Configure HealthKit

1. Select your project in the navigator
2. Select your target → **Signing & Capabilities**
3. Click **"+ Capability"**
4. Add **"HealthKit"**

### 4. Add Privacy Keys

1. Select your target → **Info** tab
2. Add these keys:
   - `Privacy - Health Share Usage Description`: "This app needs access to your health data to provide insights on temperature, recovery, and sleep quality."
   - `Privacy - Health Update Usage Description`: "This app needs to update your health data."

### 5. Build and Run

1. Select your physical iPhone device (not simulator)
2. Press **Cmd+R** to build and run
3. Grant HealthKit permissions when prompted

## Project Structure

```
Health Insights/
├── App/
│   └── Health_InsightsApp.swift       # App entry point
├── Managers/
│   └── HealthKitManager.swift         # HealthKit data fetching and processing
├── Models/
│   ├── HealthData.swift               # Main health data model
│   ├── SleepData.swift                # Sleep metrics model
│   ├── RecoveryCategory.swift         # Recovery categorization
│   └── AppSettings.swift              # User preferences
├── Extensions/
│   └── Array+Health.swift             # Array utility extensions
└── Views/
    ├── ContentView.swift              # Main tab navigation
    ├── SettingsView.swift             # App settings
    ├── Home/                          # Dashboard views
    ├── Temperature/                   # Temperature tracking views
    ├── Recovery/                      # Recovery score views
    ├── Sleep/                         # Sleep analysis views
    ├── Insights/                      # Insights and correlations
    └── Shared/                        # Reusable components
```

## How It Works

### Data Collection

The app uses HealthKit to access data from your Apple Watch:
- Heart Rate Variability (HRV)
- Resting Heart Rate
- Wrist Temperature (delta from baseline)
- Respiratory Rate
- Sleep Stages (Deep, REM, Core, Awake)
- Daily Activity and Strain

### Algorithms

**Sleep Score** (Research-Based):
- Total Sleep Time (25%): 7-9 hours optimal
- Sleep Efficiency (20%): Time asleep / time in bed
- Deep Sleep % (20%): 13-23% of total optimal
- REM Sleep % (15%): 20-25% of total optimal
- Awakenings (10%): Fewer is better
- Consistency (10%): Regular sleep schedule

**Recovery Score**:
- HRV (40%): Higher is better, normalized to 80ms
- Sleep Quality (40%): Based on sleep score
- Resting Heart Rate (20%): Lower is better (50-80 bpm range)

**Readiness Score** (Oura-style):
- Recovery (50%): Overall recovery state
- Sleep (30%): Last night's sleep quality
- Strain (20%): Inverse of previous day's strain

**Illness Detection**:
Triggers alert when 3+ indicators present:
- Temperature spike (>1°C/1.8°F above baseline)
- HRV drop (>15% below baseline)
- Resting HR increase (>10% above baseline)
- Respiratory rate increase (>15% above baseline)
- Poor sleep efficiency (<70%)

## Configuration

### Settings

Access settings via the gear icon in the app:

- **Sync Frequency**: Real-time, Hourly, or Daily updates
- **Target Sleep Hours**: Customize your sleep goal (6-10 hours)
- **Temperature Display**: Toggle absolute temperature display (note: less accurate than delta)

### Background Updates

The app uses HealthKit's background delivery to stay updated:
- **Immediate**: Real-time updates (higher battery usage)
- **Hourly**: Updates every hour (balanced)
- **Daily**: Updates once per day (minimal battery usage)

## Data Privacy

- All health data stays on your device
- No data is sent to external servers
- HealthKit data is encrypted by iOS
- You control which metrics the app can access
- Permissions can be revoked anytime in iOS Settings

## Troubleshooting

### No Data Showing
- Ensure Apple Watch is paired and syncing
- Wear your watch for a few nights to collect sleep data
- Check Apple Health app to verify data exists
- Confirm HealthKit permissions were granted

### Build Errors
- Ensure HealthKit capability is enabled
- Verify Info.plist privacy keys are added
- Clean build folder (Cmd+Shift+K)
- Check iOS deployment target and testing device is 18.0+

### Temperature Not Tracking
- Requires Apple Watch Series 8 or newer
- Temperature only records during sleep
- Ensure wrist detection is enabled on watch

## Tentative Roadmap

- [ ] Notifications for illness alerts
- [ ] Export data to CSV/PDF
- [ ] Custom goal setting and tracking
- [ ] Workout impact analysis
- [ ] Widget support
- [ ] Meal and hydration tracking integration
- [ ] Menstrual cycle correlation (for applicable users)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by [Oura Ring](https://ouraring.com/), [Whoop](https://www.whoop.com/), and [AutoSleep](https://autosleep.tantsissa.com/)
- Built with SwiftUI and HealthKit
- Research-based sleep scoring algorithms
- Apple's Human Interface Guidelines

## Author

Built by Leo Lawrence

## Disclaimer

**This app is for informational purposes only and is not intended to diagnose, treat, cure, or prevent any disease. Always consult with a qualified healthcare professional for medical advice.**

---

**Star ⭐ this repo if you find it helpful!**

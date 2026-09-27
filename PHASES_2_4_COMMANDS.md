# 🚀 PHASES 2-4: COMPLETE DEPLOYMENT COMMANDS
**Urban Glide Full Mobile & Web Deployment**  
**All Commands for Quick Reference**  
**December 1, 2025**

---

## 📋 TABLE OF CONTENTS

1. [Phase 2: Mobile Configuration](#phase-2-mobile-configuration)
2. [Phase 3: Web Deployment](#phase-3-web-deployment)
3. [Phase 4: System Testing](#phase-4-system-testing)
4. [Emergency Commands](#emergency-commands)
5. [Verification & Monitoring](#verification--monitoring)

---

## 🔥 ONE-COMMAND FULL DEPLOYMENT

Execute entire Phases 2-4 pipeline (requires manual Firebase Console actions):

```powershell
# PHASE 2 (requires Firebase Console downloads + manual edits)
# See PHASE_2_CONFIGURATION.md for Firebase Console steps
# Then:
cd c:\src\Claude\passenger_app
flutter clean
flutter pub get
flutter run

# In second terminal - PHASE 3
cd c:\src\Claude\admin_app
flutter clean
flutter pub get
flutter build web --release
firebase deploy --only hosting

# PHASE 4 - Run comprehensive tests (see PHASE_4_TESTING.md)
```

---

## PHASE 2: MOBILE CONFIGURATION

### 2.1: Firebase Console Downloads (Manual - 5 min)

**Steps in Firebase Console:**
```
1. https://console.firebase.google.com
2. Select: urban-glide-transport-25
3. Project Settings → Your apps

For Android:
4. Download google-services.json for passenger_app
5. Save to: passenger_app/android/app/google-services.json
6. Download google-services.json for driver_app
7. Save to: driver_app/android/app/google-services.json

For iOS:
8. Download GoogleService-Info.plist for passenger_app
9. Save to: passenger_app/ios/Runner/GoogleService-Info.plist
10. Download GoogleService-Info.plist for driver_app
11. Save to: driver_app/ios/Runner/GoogleService-Info.plist
```

### 2.2: Google Maps API Key Setup (Manual - 5 min)

**Get API Key:**
```
1. https://console.cloud.google.com
2. Select: urban-glide-transport-25
3. Search: "Maps SDK"
4. Enable "Maps SDK for Android" and "Maps SDK for iOS"
5. Credentials → Create API Key
6. Note the key (e.g., AIza...)
```

**Add to Android (passenger_app):**
```xml
File: passenger_app/android/app/src/main/AndroidManifest.xml
Replace: YOUR_GOOGLE_MAPS_API_KEY_HERE
With: AIza... (your actual key)
```

**Add to Android (driver_app):**
```xml
File: driver_app/android/app/src/main/AndroidManifest.xml
Replace: YOUR_GOOGLE_MAPS_API_KEY_HERE
With: AIza... (your actual key)
```

**Add to iOS (passenger_app):**
```swift
File: passenger_app/ios/Runner/AppDelegate.swift
Add: GMSServices.provideAPIKey("AIza...")
```

**Add to iOS (driver_app):**
```swift
File: driver_app/ios/Runner/AppDelegate.swift
Add: GMSServices.provideAPIKey("AIza...")
```

### 2.3: Passenger App - Android Build & Run

**Clean & Prepare:**
```powershell
cd c:\src\Claude\passenger_app
flutter clean
flutter pub get
```

**Run on Emulator:**
```powershell
flutter run
```

**Run on Device:**
```powershell
flutter devices  # Get device ID
flutter run -d <device_id>
```

**Build APK (for distribution):**
```powershell
flutter build apk --release
# Output: build/app/outputs/apk/release/app-release.apk
```

### 2.4: Driver App - Android Build & Run

**Clean & Prepare:**
```powershell
cd c:\src\Claude\driver_app
flutter clean
flutter pub get
```

**Run on Emulator:**
```powershell
flutter run
```

**Run on Device:**
```powershell
flutter devices
flutter run -d <device_id>
```

**Build APK:**
```powershell
flutter build apk --release
# Output: build/app/outputs/apk/release/app-release.apk
```

### 2.5: Passenger App - iOS Build & Run

**Install Dependencies:**
```powershell
cd c:\src\Claude\passenger_app\ios
pod install --repo-update
cd ..
```

**Clean & Prepare:**
```powershell
flutter clean
flutter pub get
```

**Run on iOS Simulator:**
```powershell
flutter run -d "iPhone 15 Pro"
# Or: flutter run (to choose simulator)
```

**List Available Simulators:**
```powershell
xcrun simctl list devices
```

**Build IPA (for distribution):**
```powershell
flutter build ios --release
# Then use Xcode to create IPA
```

### 2.6: Driver App - iOS Build & Run

**Install Dependencies:**
```powershell
cd c:\src\Claude\driver_app\ios
pod install --repo-update
cd ..
```

**Clean & Prepare:**
```powershell
flutter clean
flutter pub get
```

**Run on iOS Simulator:**
```powershell
flutter run -d "iPhone 15 Pro"
```

**Build IPA:**
```powershell
flutter build ios --release
```

### 2.7: Verify Firebase Integration

**Check in Firebase Console:**
```
https://console.firebase.google.com/project/urban-glide-transport-25

1. Firestore Database
   - Verify collections created: passengers, drivers, rides
   - Check data populated from app signups

2. Authentication
   - Verify test users created during signup

3. Cloud Messaging
   - Check FCM tokens registered (in users' FCM Token field)

4. Logs
   - No Firebase initialization errors
```

### 2.8: Batch Commands - All Android Setup

```powershell
# Setup both apps for Android
cd c:\src\Claude\passenger_app; flutter clean; flutter pub get; cd ..\driver_app; flutter clean; flutter pub get; cd ..

# Run passenger
cd c:\src\Claude\passenger_app; flutter run

# (in another terminal) Run driver
cd c:\src\Claude\driver_app; flutter run
```

### 2.9: Batch Commands - All iOS Setup

```powershell
# Setup both apps iOS dependencies
cd c:\src\Claude\passenger_app\ios; pod install --repo-update; cd ..\.. 
cd c:\src\Claude\driver_app\ios; pod install --repo-update; cd ..\..

# Setup dependencies
cd c:\src\Claude\passenger_app; flutter clean; flutter pub get; cd ..\driver_app; flutter clean; flutter pub get

# Run passenger
cd c:\src\Claude\passenger_app; flutter run -d "iPhone 15 Pro"

# (in another terminal) Run driver
cd c:\src\Claude\driver_app; flutter run -d "iPhone 15 Pro"
```

---

## PHASE 3: WEB DEPLOYMENT

### 3.1: Admin App - Build Web Release

**Navigate:**
```powershell
cd c:\src\Claude\admin_app
```

**Clean & Prepare:**
```powershell
flutter clean
flutter pub get
```

**Build for Web:**
```powershell
flutter build web --release
# Takes 5-10 minutes
# Output: build/web/
```

**Verify Build:**
```powershell
Test-Path "build/web/index.html"
# Should return: True
```

### 3.2: Deploy to Firebase Hosting

**From admin_app directory:**
```powershell
firebase deploy --only hosting
```

**Expected Output:**
```
✔ Deploy complete!
Hosting URL: https://urban-glide-transport-25.web.app
```

### 3.3: Access Admin Dashboard

**Open Browser:**
```
https://urban-glide-transport-25.web.app
```

**Login Credentials:**
```
Username: admin
Password: admin123
```

### 3.4: Verify Dashboard Features

**Check these sections:**
- Dashboard home with metrics
- Passengers management
- Drivers management
- Rides monitoring
- Analytics/reports

### 3.5: Quick Deploy Command

```powershell
cd c:\src\Claude\admin_app; flutter clean; flutter pub get; flutter build web --release; firebase deploy --only hosting
```

### 3.6: Rollback Deployment (if needed)

**View previous versions:**
```powershell
firebase hosting:versions
```

**Restore previous version:**
```powershell
firebase hosting:clone <version-id>
```

### 3.7: View Hosting Logs

```powershell
firebase hosting:log
```

---

## PHASE 4: SYSTEM TESTING

### 4.1: Pre-Test Verification

**Check Backend Status:**
```powershell
firebase functions:list
# Should show all 4 functions READY

firebase firestore:indexes --list
# Verify indexes

firebase functions:log
# Check for any errors
```

**Check Firestore Rules:**
```
https://console.firebase.google.com
Project: urban-glide-transport-25
→ Firestore Database
→ Rules tab
Verify: Published status (green checkmark)
```

### 4.2: Create Test Users

**In Firebase Console:**

**Passenger Account:**
```
Email: passenger@test.com
Password: Test@123456
Name: Test Passenger
```

**Driver Account:**
```
Email: driver@test.com
Password: Test@123456
Name: Test Driver
Vehicle: Toyota Corolla
License: UG-123
```

### 4.3: Passenger App - Start Test

**Run passenger app:**
```powershell
cd c:\src\Claude\passenger_app
flutter run
```

**Actions:**
1. Sign up or login with: passenger@test.com / Test@123456
2. Allow location permissions
3. Navigate to home screen
4. Tap "Request Ride" button

### 4.4: Driver App - Start Test

**In separate terminal, run driver app:**
```powershell
cd c:\src\Claude\driver_app
flutter run
```

**Actions:**
1. Sign up or login with: driver@test.com / Test@123456
2. Allow location permissions
3. Enable "Available for rides" toggle
4. Wait for ride request notification

### 4.5: Test Complete Ride Flow

**Sequence:**
```
Passenger:
1. Request ride from location A → B
2. Wait for driver notification
3. Observe driver location on map
4. See driver accept ride
5. Watch real-time location tracking
6. Receive "Driver has arrived" notification
7. Rate driver and complete

Driver:
1. Receive ride request notification
2. See passenger pickup location
3. Tap "Accept Ride"
4. Start navigation to pickup
5. Move towards pickup (simulated or real)
6. Tap "Mark Arrived"
7. Complete ride
8. See earnings added
```

### 4.6: Test Admin Dashboard Real-Time Updates

**In Browser:**
```
https://urban-glide-transport-25.web.app
Login: admin / admin123
```

**Observe:**
1. New ride appears in real-time
2. Status changes (searching → accepted → pickup → completed)
3. Driver location visible on map
4. Metrics update (active rides, earnings)
5. No latency (updates within 2-5 seconds)

### 4.7: Check Cloud Function Logs

**Monitor during testing:**
```powershell
firebase functions:log

# Watch for:
- onRideCreated triggered
- onRideAccepted triggered
- onDriverArrived triggered
- onRideCompleted triggered
- No errors in logs
```

### 4.8: Verify Notifications

**Expected Notifications:**

**To Driver:**
- "New Ride Request" when passenger books
- "Ride Completed" after completion

**To Passenger:**
- "Driver Accepted Your Ride"
- "Driver is on the way"
- "Driver has arrived"
- "Ride completed"

### 4.9: Check Firestore Data

**Verify in Firebase Console:**

```
Collections → rides
→ Select test ride document

Should show:
- passengerId: <passenger_id>
- driverId: <driver_id>
- status: completed (final)
- pickupLocation: {lat, lng}
- dropoffLocation: {lat, lng}
- fare: <amount>
- timestamps: created, accepted, completed
```

### 4.10: Performance Monitoring

**Track during testing:**
```
Real-time update latency: Target <5 seconds
Location broadcast frequency: Every 5-10 seconds
Notification delivery: <5 seconds
App responsiveness: No freezing
```

### 4.11: Full Test Suite Command Reference

```powershell
# Terminal 1 - Passenger App
cd c:\src\Claude\passenger_app
flutter run

# Terminal 2 - Driver App
cd c:\src\Claude\driver_app
flutter run

# Terminal 3 - Monitor Functions
firebase functions:log

# Browser 1 - Admin Dashboard
https://urban-glide-transport-25.web.app
# Login: admin / admin123

# Browser 2 - Firebase Console
https://console.firebase.google.com/project/urban-glide-transport-25
```

---

## EMERGENCY COMMANDS

### Reset All Development Environments

```powershell
# Clean all Flutter apps
cd c:\src\Claude\passenger_app; flutter clean
cd c:\src\Claude\driver_app; flutter clean
cd c:\src\Claude\admin_app; flutter clean
```

### Clear Firebase Emulator Data

```powershell
firebase emulators:start --only firestore
# Ctrl+C to stop
firebase emulators:stop
```

### Redeploy Everything

```powershell
# Backend
cd c:\src\Claude\firebase; firebase deploy --only functions,firestore:rules

# Web Admin
cd c:\src\Claude\admin_app; flutter build web --release; firebase deploy --only hosting
```

### Force Reinstall Dependencies

```powershell
# Passenger App
cd c:\src\Claude\passenger_app
rm pubspec.lock
flutter pub get
cd ios
rm Podfile.lock
pod install --repo-update
cd ../..

# Driver App
cd c:\src\Claude\driver_app
rm pubspec.lock
flutter pub get
cd ios
rm Podfile.lock
pod install --repo-update
cd ../..

# Admin App
cd c:\src\Claude\admin_app
rm pubspec.lock
flutter pub get
```

### Kill All Flutter Processes

```powershell
# Windows
Get-Process flutter | Stop-Process -Force

# Kill all emulators
adb kill-server
```

---

## VERIFICATION & MONITORING

### Check All Systems Status

```powershell
# Firebase Status
firebase projects:list

# Functions Status
firebase functions:list

# Hosting Status
firebase hosting:log

# Firestore Size
firebase firestore:inspect
```

### Monitor Real-Time Logs

```powershell
# Cloud Functions Logs
firebase functions:log --follow

# Hosting Logs
firebase hosting:log --follow
```

### Create Test Data Script

```powershell
# Create sample passengers
# (Use Firebase Console: Firestore → Add collection → Add documents)

# Or use Firebase CLI:
firebase firestore:delete passengers --recursive
# (Will prompt for confirmation)
```

### Database Backup & Restore

```powershell
# Backup Firestore
firebase firestore:delete passengers --dry-run

# (To fully backup, use Firebase Console Export option)
```

---

## 📊 QUICK REFERENCE TABLE

| Phase | Duration | Command | File |
|-------|----------|---------|------|
| 2a | 5m | Manual Firebase Console | PHASE_2_CONFIGURATION.md |
| 2b | 5m | Manual API Key Setup | PHASE_2_CONFIGURATION.md |
| 2c | 15m | `flutter run` | PHASE_2_CONFIGURATION.md |
| 3 | 15m | `flutter build web --release` | PHASE_3_DEPLOYMENT.md |
| 4 | 30m | Manual Testing | PHASE_4_TESTING.md |
| **Total** | **80m** | - | - |

---

## 🎯 SUCCESS CRITERIA CHECKLIST

- [ ] Phase 2: Both apps build without errors
- [ ] Phase 2: Firebase config files in place
- [ ] Phase 2: Google Maps API keys configured
- [ ] Phase 2: Apps run on emulators/devices
- [ ] Phase 3: Admin dashboard deployed
- [ ] Phase 3: Web app accessible at Firebase URL
- [ ] Phase 4: Ride can be booked end-to-end
- [ ] Phase 4: Driver receives notification
- [ ] Phase 4: Real-time location tracking works
- [ ] Phase 4: Admin dashboard updates in real-time
- [ ] Phase 4: All notifications delivered
- [ ] All phases: 0 critical errors

---

## 📞 GETTING HELP

**See detailed guides:**
- PHASE_2_CONFIGURATION.md - Mobile app setup (45-60 min)
- PHASE_3_DEPLOYMENT.md - Web deployment (10-15 min)
- PHASE_4_TESTING.md - System testing (20-30 min)

**Troubleshooting:**
- RUN_APPS.md - Common issues
- DEPLOYMENT_GUIDE.md - Phase by phase

---

**Reference Created:** December 1, 2025  
**System:** Urban Glide Complete Deployment  
**Coverage:** Phases 2-4 (Mobile + Web + Testing)

🚀 **READY FOR DEPLOYMENT**

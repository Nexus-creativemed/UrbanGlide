# Urban Glide - Deployment Commands Reference
**Quick Copy-Paste Commands for Deployment**

---

## Phase 1: Backend Deployment (10 minutes)

```powershell
# Navigate to firebase directory
cd firebase

# Install dependencies
cd functions
npm install
cd ..

# Deploy Cloud Functions and Firestore Rules
firebase deploy --only functions,firestore:rules

# Verify deployment
firebase functions:list
firebase firestore:indexes --list

# Monitor logs
firebase functions:log --limit 20
```

---

## Phase 2: Android Configuration

### Update Passenger App (passenger_app)

```powershell
# Place google-services.json
# File: passenger_app/android/app/google-services.json

# Update AndroidManifest.xml with Google Maps API key
# File: passenger_app/android/app/src/main/AndroidManifest.xml
# Find: com.google.android.geo.API_KEY
# Replace value with your API key

# Build and run
cd passenger_app
flutter clean
flutter pub get
flutter run
```

### Update Driver App (driver_app)

```powershell
# Place google-services.json
# File: driver_app/android/app/google-services.json

# Update AndroidManifest.xml with Google Maps API key
# File: driver_app/android/app/src/main/AndroidManifest.xml

# Build and run
cd driver_app
flutter clean
flutter pub get
flutter run
```

---

## Phase 3: iOS Configuration

### Update Passenger App (passenger_app)

```powershell
# Place GoogleService-Info.plist
# File: passenger_app/ios/Runner/GoogleService-Info.plist

# Update AppDelegate.swift with Google Maps API key
# File: passenger_app/ios/Runner/AppDelegate.swift
# Add: GMSServices.provideAPIKey("YOUR_API_KEY")

# Open in Xcode
open passenger_app/ios/Runner.xcworkspace

# In Xcode:
# 1. Select Runner target
# 2. Go to Signing & Capabilities
# 3. Add Push Notifications capability
# 4. Build and run on device
```

### Update Driver App (driver_app)

```powershell
# Place GoogleService-Info.plist
# File: driver_app/ios/Runner/GoogleService-Info.plist

# Update AppDelegate.swift
# File: driver_app/ios/Runner/AppDelegate.swift

# Open in Xcode
open driver_app/ios/Runner.xcworkspace

# Add Push Notifications capability
# Build and run on device
```

---

## Phase 4: Admin App (Web)

```powershell
# Navigate to admin app
cd admin_app

# Clean and build
flutter clean
flutter pub get

# Build for web
flutter build web --release

# Deploy to Firebase Hosting
firebase deploy --only hosting

# Or run locally
flutter run -d chrome
```

---

## Phase 5: Testing & Verification

```powershell
# Test all apps
cd passenger_app && flutter test
cd driver_app && flutter test
cd admin_app && flutter test

# Monitor Cloud Functions
firebase functions:log --follow

# Check Firestore collections
firebase firestore:documents --collection passengers
firebase firestore:documents --collection drivers
firebase firestore:documents --collection rides
```

---

## Frequently Used Commands

### Firebase CLI Commands
```powershell
# Login
firebase login
firebase logout

# Project management
firebase projects:list
firebase use urban-glide-transport-25
firebase status

# Deployment
firebase deploy                           # Deploy everything
firebase deploy --only functions          # Functions only
firebase deploy --only firestore:rules    # Rules only
firebase deploy --only hosting            # Hosting only

# Monitoring
firebase functions:list                   # List deployed functions
firebase functions:log --limit 50         # View logs
firebase functions:log --follow           # Real-time logs
firebase functions:log onRideCreated      # Specific function logs

# Firestore
firebase firestore:indexes --list         # List indexes
firebase firestore:documents --collection passengers
firebase rules:list                       # List rules
```

### Flutter Commands
```powershell
# Clean and prepare
flutter clean
flutter pub get
flutter pub upgrade

# Build
flutter build apk                         # Android APK
flutter build ios                         # iOS (requires Mac)
flutter build web --release               # Web release

# Run
flutter run                               # Run on default device
flutter run -d [device_id]                # Run on specific device
flutter run -d chrome                     # Run on Chrome (web)
flutter devices                           # List available devices

# Testing
flutter test                              # Run all tests
flutter test test/unit_tests/             # Unit tests
flutter test --coverage                   # With coverage report

# Performance
flutter run --profile                     # Profile mode
flutter run --release                     # Release mode
```

---

## One-Line Deploy Scripts

### Deploy Everything
```powershell
cd firebase; firebase deploy --only functions,firestore:rules; cd ..; firebase deploy --only hosting
```

### Deploy Functions Only
```powershell
cd firebase; firebase deploy --only functions; cd ..
```

### Build & Run All Apps
```powershell
cd passenger_app; flutter clean; flutter pub get; flutter run; cd ..; cd driver_app; flutter clean; flutter pub get; flutter run; cd ..; cd admin_app; flutter clean; flutter pub get; flutter run -d chrome
```

### Clean All Apps
```powershell
cd passenger_app; flutter clean; cd ..; cd driver_app; flutter clean; cd ..; cd admin_app; flutter clean
```

### Get Dependencies for All Apps
```powershell
cd passenger_app; flutter pub get; cd ..; cd driver_app; flutter pub get; cd ..; cd admin_app; flutter pub get
```

---

## Environment Variables (Optional)

### Create .env file in firebase/functions/
```
MERCHANT_ID=10000100
MERCHANT_KEY=46f0cd694581a
PAYFAST_PASSPHRASE=your-passphrase
NOTIFICATION_TIMEOUT=30000
```

### Load environment variables in index.js
```javascript
require('dotenv').config();
const merchantId = process.env.MERCHANT_ID;
```

---

## Database Initialization (First Time)

### Create Initial Collections
```powershell
# These are created automatically on first use
# But you can pre-create if desired:

firebase firestore:documents --collection admins --upsert --data '{"created": true}'
firebase firestore:documents --collection analytics --upsert --data '{"created": true}'
firebase firestore:documents --collection earnings --upsert --data '{"created": true}'
```

---

## Rollback Commands (If Needed)

```powershell
# Rollback functions to previous version
firebase deploy --only functions --force

# Rollback rules
firebase deploy --only firestore:rules --force

# Clear all Firestore data (CAREFUL - destructive)
firebase firestore:documents --collection passengers --delete-all
```

---

## Performance Monitoring

```powershell
# Real-time performance stats
firebase functions:log --follow

# Detailed function info
firebase functions:describe [function-name]

# Check function execution times
firebase functions:log --limit 100 | grep "ms"
```

---

## Troubleshooting Quick Commands

```powershell
# Clear Firebase cache
firebase logout && firebase login

# Verify project
firebase use urban-glide-transport-25

# Check status
firebase status

# Full debug deployment
firebase deploy --debug

# Clear Flutter cache
flutter clean
flutter pub cache repair

# Check Flutter doctor
flutter doctor -v
```

---

## Estimated Execution Times

| Task | Duration |
|------|----------|
| Deploy backend | 3-5 min |
| Configure Android | 10-15 min |
| Configure iOS | 10-15 min |
| Build apps | 10-20 min |
| Test apps | 10-15 min |
| Deploy web admin | 2-3 min |
| **TOTAL** | **45-75 min** |

---

**Last Updated:** December 1, 2025  
**Status:** Ready to deploy ✅

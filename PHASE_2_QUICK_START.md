# 🎯 PHASE 2 - QUICK START GUIDE
**Urban Glide Mobile Configuration - 5 Minute Quick Reference**  
**December 1, 2025**

---

## ⚡ FASTEST PATH TO PHASE 2 EXECUTION

### What You Need to Know (2 min read)

**Phase 2 = Configure 2 mobile apps for iOS and Android**

Your task:
1. Download Firebase config files (2 files per platform = 4 total)
2. Get Google Maps API keys (1 key per platform = 2 total)
3. Add keys to app configs
4. Build and test both apps
5. Verify everything works

**Time:** 60 minutes  
**Difficulty:** Medium (mostly downloads and configuration)  
**Risk:** Low (no live data affected)

---

## 📖 THREE DOCUMENTS YOU NEED

### 1️⃣ MAIN GUIDE (Bookmark this)
```
PHASE_2_CONFIGURATION.md
├─ Follow from top to bottom
├─ Part A: Android Firebase
├─ Part B: iOS Firebase
├─ Part C: API Keys
├─ Part D: Android build/test
├─ Part E: iOS build/test
└─ Part F: Verification
```

### 2️⃣ QUICK COMMANDS (Keep open)
```
PHASES_2_4_COMMANDS.md
├─ Section: PHASE 2: MOBILE CONFIGURATION
├─ Copy exact commands
└─ Paste into terminal
```

### 3️⃣ WHEN YOU'RE STUCK
```
PHASE_2_CONFIGURATION.md
└─ Section: ⚠️ COMMON ISSUES & SOLUTIONS
```

---

## 🚀 5-STEP QUICK START

### Step 1: Prepare (5 min)
```powershell
# Check everything is working
flutter doctor

# Expected: All ✓ marks
```

### Step 2: Download (10 min)
```
1. https://console.firebase.google.com
2. Project: urban-glide-transport-25
3. Project Settings → Your apps
4. Download: google-services.json (×2)
5. Download: GoogleService-Info.plist (×2)
```

### Step 3: Configure (20 min)
```
1. Get Google Maps API key (5 min)
2. Edit AndroidManifest.xml (×2) (5 min)
3. Edit AppDelegate.swift (×2) (5 min)
4. Save all files (5 min)
```

### Step 4: Build (20 min)
```powershell
# Android
cd passenger_app
flutter clean
flutter pub get
flutter run  # Or: flutter build apk

# iOS
cd passenger_app\ios
pod install --repo-update
cd ..
flutter clean
flutter pub get
flutter run -d "iPhone 15 Pro"
```

### Step 5: Verify (5 min)
```
1. Apps launch without crashing
2. Firebase initializes
3. Location permissions work
4. Login screen appears
5. Create test user
```

---

## 📋 CRITICAL CHECKLIST

Before Phase 2:
- [ ] `flutter doctor` shows all ✓
- [ ] Firebase Console accessible
- [ ] Google Cloud Console accessible

During Phase 2:
- [ ] 4 config files downloaded
- [ ] API keys obtained
- [ ] Files placed in correct locations
- [ ] Both apps build without errors
- [ ] Both apps run without crashing

After Phase 2:
- [ ] Apps launch and don't crash
- [ ] Firebase initializes
- [ ] Test users created
- [ ] Ready for Phase 3

---

## 🔧 MINIMAL COMMAND REFERENCE

### One-Command Full Passenger App Setup:
```powershell
cd c:\src\Claude\passenger_app; flutter clean; flutter pub get; flutter run
```

### One-Command Full Driver App Setup:
```powershell
cd c:\src\Claude\driver_app; flutter clean; flutter pub get; flutter run
```

### iOS (if on Mac):
```powershell
cd c:\src\Claude\passenger_app\ios; pod install --repo-update; cd ..; flutter clean; flutter pub get; flutter run -d "iPhone 15 Pro"
```

---

## 🆘 3 WAYS TO TROUBLESHOOT

### Method 1: Read the Guide
```
Open: PHASE_2_CONFIGURATION.md
Search: Your error message
Follow: Solution
```

### Method 2: Run Diagnostic
```powershell
flutter doctor
flutter run -v
```

### Method 3: Clean Everything
```powershell
flutter clean
flutter pub get
# Try again
```

---

## ✅ YOU'RE READY TO START

**Status:** ✅ All systems prepared  
**Next:** Open `PHASE_2_CONFIGURATION.md`  
**Duration:** 60 minutes  
**Goal:** Both apps running on devices  

---

**Quick Start Guide Created:** December 1, 2025  
**Read Time:** 5 minutes  
**Execution Time:** 60 minutes

🚀 **PHASE 2 AWAITS - OPEN PHASE_2_CONFIGURATION.md AND BEGIN**

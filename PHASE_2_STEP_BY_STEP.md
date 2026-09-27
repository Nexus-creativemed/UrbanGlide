# 🎯 PHASE 2 STEP-BY-STEP EXECUTION GUIDE
**Urban Glide Mobile Configuration - Exact Steps to Follow**  
**December 2, 2025 - Live Execution**

---

## ⏱️ PHASE 2 = 60 MINUTES

Follow these steps in exact order. Estimated time shown for each step.

---

## 📝 STEP 1: FIREBASE CONFIG DOWNLOADS (10 MINUTES)

### 1a. Go to Firebase Console (1 min)
```
https://console.firebase.google.com/project/urban-glide-transport-25
```

### 1b. Download Android Config - Passenger App (2 min)
1. Click: **Project Settings** (⚙️ gear icon, top-left)
2. Go to: **Your apps** section
3. Find: `com.urbanglidebfn.passenger_app` with Android icon
4. Click it
5. **Download button** for `google-services.json`
6. **Save to:** `c:\src\Claude\passenger_app\android\app\google-services.json`

### 1c. Download Android Config - Driver App (2 min)
1. Go back to Firebase Console
2. **Project Settings** → **Your apps**
3. Find: `com.urbanglidebfn.driver_app` with Android icon
4. Click it
5. **Download `google-services.json`**
6. **Save to:** `c:\src\Claude\driver_app\android\app\google-services.json`

### 1d. Download iOS Config - Passenger App (2 min)
1. Go back to Firebase Console
2. **Project Settings** → **Your apps**
3. Find: `com.urbanglidebfn.passenger_app` with iOS icon
4. Click it
5. **Download `GoogleService-Info.plist`**
6. **Save to:** `c:\src\Claude\passenger_app\ios\Runner\GoogleService-Info.plist`

### 1e. Download iOS Config - Driver App (2 min)
1. Go back to Firebase Console
2. **Project Settings** → **Your apps**
3. Find: `com.urbanglidebfn.driver_app` with iOS icon
4. Click it
5. **Download `GoogleService-Info.plist`**
6. **Save to:** `c:\src\Claude\driver_app\ios\Runner\GoogleService-Info.plist`

### ✅ Verify Step 1:
Open file explorer and verify all 4 files exist:
```powershell
# Run in PowerShell to verify
Test-Path "c:\src\Claude\passenger_app\android\app\google-services.json"  # Should be True
Test-Path "c:\src\Claude\driver_app\android\app\google-services.json"     # Should be True
Test-Path "c:\src\Claude\passenger_app\ios\Runner\GoogleService-Info.plist" # Should be True
Test-Path "c:\src\Claude\driver_app\ios\Runner\GoogleService-Info.plist"    # Should be True
```

---

## 🔑 STEP 2: GOOGLE MAPS API KEY (5 MINUTES)

### 2a. Go to Google Cloud Console (1 min)
```
https://console.cloud.google.com/project/urban-glide-transport-25
```

### 2b. Enable Maps APIs (2 min)
1. Search bar: Type "Maps SDK"
2. Click: **Maps SDK for Android**
3. Click: **ENABLE**
4. Wait for enable to complete

Go back to home:
1. Search bar: Type "Maps SDK"
2. Click: **Maps SDK for iOS**
3. Click: **ENABLE**
4. Wait for enable to complete

### 2c. Create API Key (2 min)
1. Left sidebar: Click **Credentials**
2. Top button: **Create Credentials**
3. Choose: **API Key**
4. A new key is generated
5. **Copy the key** (looks like: `AIza...`)
6. **Save it to a text file for next step**

### ✅ Verify Step 2:
You have an API key that looks like:
```
AIza1234567890abcdefghij...
```

---

## ⚙️ STEP 3: CONFIGURE ANDROID FILES (5 MINUTES)

### 3a. Configure Passenger App (2 min)

1. Open file: `c:\src\Claude\passenger_app\android\app\src\main\AndroidManifest.xml`
2. Find this line:
   ```xml
   <meta-data android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_GOOGLE_MAPS_API_KEY_HERE" />
   ```
3. Replace: `YOUR_GOOGLE_MAPS_API_KEY_HERE`
4. With: Your API key (AIza...)
5. **Save file** (Ctrl+S)

### 3b. Configure Driver App (2 min)

1. Open file: `c:\src\Claude\driver_app\android\app\src\main\AndroidManifest.xml`
2. Find the same line
3. Replace: `YOUR_GOOGLE_MAPS_API_KEY_HERE`
4. With: Your API key (same one)
5. **Save file**

### 3c. Verify (1 min)

Open each file and confirm API key is there (not "YOUR_GOOGLE_MAPS...")

### ✅ Verify Step 3:
Both AndroidManifest.xml files have your actual API key.

---

## 📱 STEP 4: CONFIGURE IOS FILES (5 MINUTES)

### 4a. Configure Passenger App (2 min)

1. Open file: `c:\src\Claude\passenger_app\ios\Runner\AppDelegate.swift`
2. Look for section with:
   ```swift
   import GoogleMaps
   
   @UIApplicationMain
   @objc class AppDelegate: FlutterAppDelegate {
     override func application(
       _ application: UIApplication,
       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
     ) -> Bool {
       GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY_HERE")
   ```
3. Replace: `YOUR_GOOGLE_MAPS_API_KEY_HERE`
4. With: Your API key (AIza...)
5. **Save file**

### 4b. Configure Driver App (2 min)

1. Open file: `c:\src\Claude\driver_app\ios\Runner\AppDelegate.swift`
2. Make the same replacement
3. Replace: `YOUR_GOOGLE_MAPS_API_KEY_HERE`
4. With: Your API key
5. **Save file**

### 4c. Verify (1 min)

Open each file and confirm API key is there.

### ✅ Verify Step 4:
Both AppDelegate.swift files have your actual API key.

---

## 🏗️ STEP 5: BUILD ANDROID APPS (15 MINUTES)

### 5a. Passenger App Android (7 min)

**Open PowerShell, then run:**

```powershell
cd c:\src\Claude\passenger_app
flutter clean
flutter pub get
flutter run
```

**Expected output:**
```
Launching lib/main.dart on Android...
✓ Built build/app/outputs/apk/debug/app-debug.apk
```

**You should see:**
- App launches on Android emulator/device
- Splash screen appears
- Firebase initializes (no red errors)
- Login screen appears

**If you get errors:**
- Try: `flutter clean && flutter pub get` again
- Check: `flutter doctor` for missing tools

### 5b. Driver App Android (7 min)

**In a new PowerShell window:**

```powershell
cd c:\src\Claude\driver_app
flutter clean
flutter pub get
flutter run
```

**Same expected output as passenger app**

### ✅ Verify Step 5:
Both Android apps:
- Build without errors
- Run on emulator/device
- Show Firebase initialization
- Display login screen

---

## 🍎 STEP 6: BUILD IOS APPS (15 MINUTES)

### 6a. Passenger App iOS (7 min)

**Open PowerShell, then run:**

```powershell
cd c:\src\Claude\passenger_app\ios
pod install --repo-update
cd ..
flutter clean
flutter pub get
flutter run -d "iPhone 15 Pro"
```

**Expected output:**
```
Installing CocoaPods pods...
Launching lib/main.dart on iPhone 15 Pro...
✓ Built build/ios/Debug-iphonesimulator/Runner.app
```

**You should see:**
- CocoaPods installs (might take 2-3 min)
- App builds for iOS
- App launches in simulator
- Same as Android (splash, Firebase, login)

**If CocoaPods fails:**
- Try: `pod install --repo-update` again
- Or: Delete `Pods` folder and try again

### 6b. Driver App iOS (7 min)

**In a new PowerShell window:**

```powershell
cd c:\src\Claude\driver_app\ios
pod install --repo-update
cd ..
flutter clean
flutter pub get
flutter run -d "iPhone 15 Pro"
```

**Same expected output as passenger app**

### ✅ Verify Step 6:
Both iOS apps:
- CocoaPods installs successfully
- Build without errors
- Run on simulator
- Show same behavior as Android

---

## ✅ STEP 7: FIREBASE VERIFICATION (5 MINUTES)

### 7a. Create Test User (2 min)

1. Go to: https://console.firebase.google.com/project/urban-glide-transport-25
2. Go to: **Authentication** (left sidebar)
3. Click: **Create a new user** or **Add User**
4. Enter:
   - Email: `test@urbangglide.com`
   - Password: `Test@123456`
5. Click: **Create**

### 7b. Test Login in Passenger App (2 min)

1. On running passenger app (Android or iOS)
2. Go to: Login screen (should already be there)
3. Enter: `test@urbangglide.com`
4. Enter: `Test@123456`
5. Tap: **Sign Up** or **Login**
6. App should navigate to home screen

### 7c. Verify in Firebase Console (1 min)

1. Go to: https://console.firebase.google.com/project/urban-glide-transport-25
2. Go to: **Firestore Database**
3. Look at: **Collections** tab
4. Should see: `passengers`, `drivers`, `rides` collections
5. Click: **passengers** collection
6. Should see: New document with your test user

### ✅ Verify Step 7:
- Test user created in Firebase
- Can login in app
- User data appears in Firestore
- Real-time sync working

---

## 🎉 PHASE 2 COMPLETE!

If all 7 steps are verified, Phase 2 is complete.

### Final Checklist:
- [ ] All 4 config files downloaded & placed
- [ ] Google Maps API key obtained
- [ ] Android files configured with API key
- [ ] iOS files configured with API key
- [ ] Passenger app builds & runs (Android)
- [ ] Driver app builds & runs (Android)
- [ ] Passenger app builds & runs (iOS)
- [ ] Driver app builds & runs (iOS)
- [ ] Test user created
- [ ] Login works
- [ ] User data in Firestore

---

## 🚀 NEXT PHASE

**After Phase 2 Success:**

1. Open: `PHASE_3_DEPLOYMENT.md`
2. Build admin app for web
3. Deploy to Firebase Hosting
4. Access: https://urban-glide-transport-25.web.app

**Time:** 15 minutes

---

## 📊 PHASE 2 TIMER

```
Step 1 (Firebase Configs):      10 min
Step 2 (API Key):                5 min
Step 3 (Android Config):         5 min
Step 4 (iOS Config):             5 min
Step 5 (Android Build):         15 min
Step 6 (iOS Build):             15 min
Step 7 (Verification):           5 min
─────────────────────────────
TOTAL:                          60 min
```

---

## ✨ YOU ARE READY

You have:
- ✅ All documentation
- ✅ All commands
- ✅ Step-by-step guide
- ✅ Clear success criteria

**Begin now with Step 1 above.**

---

**Phase 2 Step-by-Step Guide:** December 2, 2025  
**Ready to Execute:** YES ✅  
**Difficulty:** Medium  
**Risk:** Low  

🚀 **FOLLOW THESE 7 STEPS AND PHASE 2 IS COMPLETE!**

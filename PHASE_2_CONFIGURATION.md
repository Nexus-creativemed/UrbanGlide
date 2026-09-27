# 📱 PHASE 2: MOBILE APP CONFIGURATION - EXECUTION GUIDE
**Urban Glide iOS & Android Configuration**  
**Start Time:** December 1, 2025  
**Estimated Duration:** 45-60 minutes  
**Status:** READY TO EXECUTE ✅

---

## 🎯 PHASE 2 OBJECTIVES

### What You're Configuring:
1. **Firebase Configuration Files** (2 files per app = 4 total)
   - `google-services.json` (Android)
   - `GoogleService-Info.plist` (iOS)

2. **Google Maps API Keys** (2 files per app = 4 total)
   - `AndroidManifest.xml` (Android)
   - `AppDelegate.swift` or `Info.plist` (iOS)

3. **Two Mobile Apps:**
   - **passenger_app** - Consumer app for booking rides
   - **driver_app** - Driver partner app for accepting rides

### Success Criteria:
- ✅ Both apps build without errors
- ✅ Firebase initialization completes on startup
- ✅ Location permissions request shows
- ✅ Google Maps displays successfully
- ✅ Apps can authenticate with Firebase
- ✅ Real-time Firestore updates working

---

## 📋 PRE-FLIGHT CHECKLIST

### Required Accounts & Access:
- [ ] Firebase Console access: https://console.firebase.google.com
- [ ] Google Cloud Console access: https://console.cloud.google.com
- [ ] Project: `urban-glide-transport-25`
- [ ] Google Maps API enabled

### Required Tools:
- [ ] **Android Studio** (for Android emulator or build)
- [ ] **Xcode** (for iOS emulator or build)
- [ ] **Flutter SDK** (latest version)
- [ ] **Dart SDK** (bundled with Flutter)
- [ ] **Git** (for version control)

### Verify Flutter Setup:
```powershell
flutter doctor
```

Expected output: ✓ for Flutter, Dart, Android, iOS

---

## ⚙️ STEP-BY-STEP EXECUTION

### PART A: FIREBASE CONFIGURATION FILES (Android)

#### STEP A1: Download google-services.json from Firebase Console (5 min)

1. Go to: https://console.firebase.google.com
2. Select project: **urban-glide-transport-25**
3. Click **Project Settings** (gear icon, top-left)
4. Go to **Your apps** section
5. Find the **Android app** entries:
   - `com.urbanglidebfn.passenger_app` (Passenger)
   - `com.urbanglidebfn.driver_app` (Driver)

**For passenger_app:**
6. Click the Android app (Passenger)
7. Click **google-services.json** button
8. Download the file

**Save to:** `c:\src\Claude\passenger_app\android\app\google-services.json`

> ⚠️ Replace the placeholder file: `passenger_app\android\app\google-services.json.PLACEHOLDER`

**For driver_app:**
9. Return to Firebase Console
10. Select the Android app (Driver)
11. Download `google-services.json`

**Save to:** `c:\src\Claude\driver_app\android\app\google-services.json`

> ⚠️ Replace the placeholder file: `driver_app\android\app\google-services.json.PLACEHOLDER`

---

#### STEP A2: Verify Android Configuration Files

Navigate and verify files exist:

```powershell
# Check passenger app
Test-Path "c:\src\Claude\passenger_app\android\app\google-services.json"

# Check driver app
Test-Path "c:\src\Claude\driver_app\android\app\google-services.json"
```

Expected output: `True` for both

---

### PART B: FIREBASE CONFIGURATION FILES (iOS)

#### STEP B1: Download GoogleService-Info.plist from Firebase Console (5 min)

1. Go to: https://console.firebase.google.com
2. Select project: **urban-glide-transport-25**
3. Click **Project Settings** (gear icon)
4. Go to **Your apps** section
5. Find the **iOS app** entries:
   - `com.urbanglidebfn.passenger_app` (Passenger)
   - `com.urbanglidebfn.driver_app` (Driver)

**For passenger_app:**
6. Click the iOS app (Passenger)
7. Click **GoogleService-Info.plist** button
8. Download the file

**Save to:** `c:\src\Claude\passenger_app\ios\Runner\GoogleService-Info.plist`

> ⚠️ Replace the placeholder: `passenger_app\ios\Runner\GoogleService-Info.plist.PLACEHOLDER`

**For driver_app:**
9. Return to Firebase Console
10. Select the iOS app (Driver)
11. Download `GoogleService-Info.plist`

**Save to:** `c:\src\Claude\driver_app\ios\Runner\GoogleService-Info.plist`

> ⚠️ Replace the placeholder: `driver_app\ios\Runner\GoogleService-Info.plist.PLACEHOLDER`

---

#### STEP B2: Verify iOS Configuration Files

```powershell
# Check passenger app
Test-Path "c:\src\Claude\passenger_app\ios\Runner\GoogleService-Info.plist"

# Check driver app
Test-Path "c:\src\Claude\driver_app\ios\Runner\GoogleService-Info.plist"
```

Expected output: `True` for both

---

### PART C: GOOGLE MAPS API KEY CONFIGURATION

#### STEP C1: Get Google Maps API Key (5 min)

1. Go to: https://console.cloud.google.com
2. Select project: **urban-glide-transport-25**
3. Search for "Maps SDK" in the search bar
4. Click **Maps SDK for Android** 
5. Click **ENABLE** (if not already enabled)
6. Do the same for **Maps SDK for iOS**

7. Go to **Credentials** (left sidebar)
8. Click **Create Credentials** → **API Key**
9. Choose **Restrict key** (important for security)
10. Under "Application restrictions":
    - Select **Android apps** (for one key)
    - Add your app package name: `com.urbanglidebfn.passenger_app` or `.driver_app`
11. Copy the API key

> Create separate keys for:
> - Passenger App Android
> - Passenger App iOS
> - Driver App Android
> - Driver App iOS

---

#### STEP C2: Add API Key to Android Apps (5 min per app)

**For passenger_app:**

1. Open: `c:\src\Claude\passenger_app\android\app\src\main\AndroidManifest.xml`
2. Find line with:
   ```xml
   <meta-data android:name="com.google.android.geo.API_KEY"
   ```
3. Replace `YOUR_GOOGLE_MAPS_API_KEY_HERE` with actual key
4. Save file

**Example:**
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="AIza..." />
```

**For driver_app:**

1. Open: `c:\src\Claude\driver_app\android\app\src\main\AndroidManifest.xml`
2. Find and replace API key line (same as above)
3. Save file

---

#### STEP C3: Add API Key to iOS Apps (5 min per app)

**For passenger_app:**

1. Open: `c:\src\Claude\passenger_app\ios\Runner\AppDelegate.swift` 
   (or check `Info.plist` if no AppDelegate changes needed)

2. Search for `YOUR_GOOGLE_MAPS_API_KEY_HERE`

3. Replace with actual API key

**Example:**
```swift
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY_HERE")
    GeneratedPluginRegistrant.register(as: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

**For driver_app:**

1. Open: `c:\src\Claude\driver_app\ios\Runner\AppDelegate.swift`
2. Make same change as passenger_app
3. Save file

---

### PART D: BUILD & TEST - ANDROID

#### STEP D1: Prepare passenger_app for Android (2 min)

```powershell
cd c:\src\Claude\passenger_app
flutter clean
flutter pub get
```

#### STEP D2: Build and Run passenger_app (5-10 min)

**On Android Emulator:**
```powershell
flutter run
```

> Select device when prompted (emulator or connected device)

**Expected output:**
- App launches
- Splash screen appears
- Firebase initialization completes
- Login screen displays
- No errors in console

**On Android Device:**
```powershell
flutter run -d <device_id>
```

> Get device ID with: `flutter devices`

---

#### STEP D3: Test Location Permission (2 min)

When app launches:
1. Look for location permission prompt
2. Tap **ALLOW** (or **ALLOW WHILE USING APP**)
3. Verify app doesn't crash

---

#### STEP D4: Prepare driver_app for Android (2 min)

```powershell
cd c:\src\Claude\driver_app
flutter clean
flutter pub get
```

#### STEP D5: Build and Run driver_app (5-10 min)

```powershell
flutter run
```

**Expected output:**
- Same as passenger_app
- Splash screen → Login screen
- No Firebase or permission errors

---

### PART E: BUILD & TEST - iOS

#### STEP E1: Prepare passenger_app for iOS (3 min)

```powershell
cd c:\src\Claude\passenger_app\ios
pod install --repo-update
cd ..
flutter clean
flutter pub get
```

#### STEP E2: Build and Run passenger_app on iOS Simulator (5-15 min)

```powershell
flutter run -d "iPhone 15 Pro" # or your preferred simulator
```

**Expected output:**
- App launches in simulator
- Splash screen appears
- Firebase initializes
- Login screen displays
- No errors

---

#### STEP E3: Test Permissions (2 min)

When app launches on iOS:
1. Look for location permission dialog
2. Tap **Allow Once** or **Allow While Using App**
3. Verify app responds

---

#### STEP E4: Prepare driver_app for iOS (3 min)

```powershell
cd c:\src\Claude\driver_app\ios
pod install --repo-update
cd ..
flutter clean
flutter pub get
```

#### STEP E5: Build and Run driver_app on iOS Simulator (5-15 min)

```powershell
flutter run -d "iPhone 15 Pro"
```

**Expected output:**
- Same as passenger_app
- Splash → Login
- No errors

---

### PART F: FIREBASE VERIFICATION

#### STEP F1: Verify Firebase Connection (2 min)

In each app, check Firebase Console:

1. Go to: https://console.firebase.google.com/project/urban-glide-transport-25
2. Go to **Firestore Database**
3. You should see collections:
   - passengers
   - drivers
   - rides
   - support
   - notifications
   - admins

4. Go to **Authentication**
5. Create a test account:
   - Email: `test@urbangglide.com`
   - Password: `Test@123456`

---

#### STEP F2: Test Authentication in Apps (5 min)

**In passenger_app:**
1. Go to Login screen (should be displayed)
2. Enter test email: `test@urbangglide.com`
3. Enter password: `Test@123456`
4. Tap **Login** or **Sign Up** (depending on screen)

**Expected:**
- No Firebase errors
- Either login succeeds or account created
- Redirects to home screen or booking screen

**In driver_app:**
1. Same process as passenger_app
2. Use same test credentials
3. Should show driver home with ride requests

---

#### STEP F3: Verify Firestore Rules (2 min)

Go to Firebase Console → Firestore → Rules tab

**Should see:**
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    ...
  }
}
```

Status should show **Published** (green checkmark)

---

## ✅ PHASE 2 SUCCESS CHECKLIST

### Firebase Files:
- [ ] `passenger_app/android/app/google-services.json` ✅
- [ ] `driver_app/android/app/google-services.json` ✅
- [ ] `passenger_app/ios/Runner/GoogleService-Info.plist` ✅
- [ ] `driver_app/ios/Runner/GoogleService-Info.plist` ✅

### Google Maps API Keys:
- [ ] Passenger app Android key configured ✅
- [ ] Driver app Android key configured ✅
- [ ] Passenger app iOS key configured ✅
- [ ] Driver app iOS key configured ✅

### Android Build & Run:
- [ ] Passenger app builds ✅
- [ ] Passenger app runs on emulator/device ✅
- [ ] Driver app builds ✅
- [ ] Driver app runs on emulator/device ✅

### iOS Build & Run:
- [ ] Passenger app builds for iOS ✅
- [ ] Passenger app runs on simulator ✅
- [ ] Driver app builds for iOS ✅
- [ ] Driver app runs on simulator ✅

### Firebase Integration:
- [ ] Firebase initializes on startup ✅
- [ ] Location permissions requested ✅
- [ ] Test user can authenticate ✅
- [ ] Firestore collections visible ✅
- [ ] Security rules published ✅

---

## 📊 CONFIGURATION SUMMARY

### Files Modified:

| File | App | Purpose | Status |
|------|-----|---------|--------|
| `google-services.json` | passenger_app (Android) | Firebase config | 📝 Download |
| `google-services.json` | driver_app (Android) | Firebase config | 📝 Download |
| `GoogleService-Info.plist` | passenger_app (iOS) | Firebase config | 📝 Download |
| `GoogleService-Info.plist` | driver_app (iOS) | Firebase config | 📝 Download |
| `AndroidManifest.xml` | passenger_app | Google Maps key | ✏️ Edit |
| `AndroidManifest.xml` | driver_app | Google Maps key | ✏️ Edit |
| `AppDelegate.swift` | passenger_app | Google Maps key | ✏️ Edit |
| `AppDelegate.swift` | driver_app | Google Maps key | ✏️ Edit |

---

## ⏱️ TIME BREAKDOWN

| Step | Time |
|------|------|
| Download Android config (2 apps) | 5 min |
| Download iOS config (2 apps) | 5 min |
| Get Google Maps API Keys | 5 min |
| Configure Android keys (2 apps) | 5 min |
| Configure iOS keys (2 apps) | 5 min |
| Android build & test (2 apps) | 15 min |
| iOS build & test (2 apps) | 15 min |
| Firebase verification | 5 min |
| **Total** | **60 min** |

---

## ⚠️ COMMON ISSUES & SOLUTIONS

### Issue: "google-services.json not found"
**Solution:**
1. Verify file downloaded from Firebase Console
2. Place in: `<app>/android/app/google-services.json`
3. Run: `flutter clean && flutter pub get`
4. Try again

### Issue: "GoogleService-Info.plist not found"
**Solution:**
1. Download from Firebase Console
2. Place in: `<app>/ios/Runner/GoogleService-Info.plist`
3. Add to Xcode project:
   - Open `ios/Runner.xcworkspace`
   - Drag file into project
   - Ensure "Copy items if needed" is checked
4. Run: `flutter clean && flutter pub get`

### Issue: "Google Maps API key missing" or map displays watermark
**Solution:**
1. Verify API key added to AndroidManifest.xml
2. Verify API key added to AppDelegate.swift
3. Verify Maps SDK enabled in Google Cloud Console
4. Clean and rebuild: `flutter clean && flutter pub get && flutter run`

### Issue: "Firebase initialization failed"
**Solution:**
1. Check `google-services.json`/`GoogleService-Info.plist` downloaded correctly
2. Verify project ID matches: `urban-glide-transport-25`
3. Check app package name matches Firebase Console configuration
4. Delete build folder: `rm -r build` then rebuild

### Issue: App crashes on startup
**Solution:**
1. Check Flutter logs: `flutter logs`
2. Look for Firebase initialization errors
3. Verify all config files present
4. Check Android/iOS permissions in manifest/plist

### Issue: "Permission denied" on location
**Solution:**
1. Verify permissions in AndroidManifest.xml:
   ```xml
   <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
   <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
   ```
2. On device, grant location permission when prompted
3. For iOS, verify Info.plist has:
   ```xml
   <key>NSLocationWhenInUseUsageDescription</key>
   <string>Urban Glide needs your location to track rides</string>
   ```

---

## 🔄 QUICK REFERENCE COMMANDS

### Full Android Setup & Run (Passenger):
```powershell
cd c:\src\Claude\passenger_app
flutter clean
flutter pub get
flutter run
```

### Full iOS Setup & Run (Passenger):
```powershell
cd c:\src\Claude\passenger_app\ios
pod install --repo-update
cd ..
flutter clean
flutter pub get
flutter run -d "iPhone 15 Pro"
```

### Build Both Apps Android:
```powershell
cd c:\src\Claude\passenger_app; flutter clean; flutter pub get; flutter build apk; cd ..\driver_app; flutter clean; flutter pub get; flutter build apk
```

### Clean All:
```powershell
cd c:\src\Claude\passenger_app; flutter clean; cd ..\driver_app; flutter clean; cd ..\admin_app; flutter clean
```

---

## 📝 NEXT STEPS

After Phase 2 completion:
1. ✅ Both apps configured
2. ✅ Both apps building successfully
3. ✅ Both apps running on emulators/devices
4. ✅ Firebase authentication working
5. ✅ Real-time updates verified

**Proceed to:**
- **Phase 3:** Web Admin Deployment (admin_app on Firebase Hosting)
- **Phase 4:** End-to-End Testing

---

## 🎯 PHASE 2 AUTHORIZATION: ✅ APPROVED FOR EXECUTION

**Status:** Ready to execute  
**Configuration:** Complete  
**Prerequisites:** All met  
**Authorization:** GO ✅

**Time to Complete:** 45-60 minutes  
**Difficulty:** Medium (requires Firebase Console access)  
**Risk:** Low (no live data affected)

---

**Phase 2 Guide Created:** December 1, 2025  
**Configuration Method:** Firebase Console + Manual API Key Setup  
**Execution Environment:** Windows PowerShell  
**Target Apps:** passenger_app, driver_app (Android & iOS)

📱 **READY TO CONFIGURE MOBILE APPS**

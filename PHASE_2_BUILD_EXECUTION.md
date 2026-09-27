# 🚀 PHASE 2: BUILD & TEST EXECUTION
**Urban Glide Mobile Apps - Build Commands & Verification**

---

## ✅ PRE-BUILD CHECKLIST

- [x] Firebase config files downloaded (4 files)
- [x] Android API key configured: `AIzaSyA5b1rJl8Pzd7gOxmqLCpeJycWJ-8Ky02U`
- [x] iOS API key configured: `AIzaSyBksBQ7P26dC61ElMbObt6FisQCLzF1ak0`
- [x] Web API key configured: `AIzaSyA5b1rJl8Pzd7gOxmqLCpeJycWJ-8Ky02U`
- [x] All pubspec.yaml verified
- [x] All dependencies ready

**Status:** 🟢 ALL SYSTEMS GO

---

## 🔧 STEP 5: ANDROID BUILD & TEST (15 minutes)

### **5a. Build Passenger App (Android)**

Open PowerShell and run:

```powershell
cd c:\src\Claude\passenger_app
flutter clean
flutter pub get
flutter run -d android
```

**Expected Output Timeline:**

```
✓ Running Gradle build...
✓ Built build/app/outputs/apk/debug/app-debug.apk
✓ Installing and launching app...
✓ Urban Glide splash screen appears
✓ Firebase initializes
✓ Maps ready
```

**Success Indicators:**
- No red errors in terminal
- App opens on Android device/emulator
- Splash screen shows "URBAN GLIDE - DRIVEN BY THE NEW GENERATION"
- Navigation to login screen works

**When you see the login screen:**
- ✅ Type `r` for hot reload (optional)
- ✅ Type `q` to quit and move to next build

---

### **5b. Build Driver App (Android)**

```powershell
cd c:\src\Claude\driver_app
flutter clean
flutter pub get
flutter run -d android
```

**Expected Output Timeline:**

```
✓ Running Gradle build...
✓ Built build/app/outputs/apk/debug/app-debug.apk
✓ Installing and launching app...
✓ Urban Glide Driver splash screen appears
✓ Firebase initializes
✓ Maps ready
```

**Success Indicators:**
- No red errors in terminal
- App opens on Android device/emulator
- Splash screen shows "URBAN GLIDE DRIVER - DRIVEN BY THE NEW GENERATION"
- Navigation works

---

## 📱 STEP 6: iOS BUILD & TEST (15 minutes)

### **6a. Build Passenger App (iOS)**

```powershell
cd c:\src\Claude\passenger_app
flutter clean
flutter pub get
flutter run -d ios
```

**Expected Output Timeline:**

```
✓ Building iOS project...
✓ Running Xcode build...
✓ Built iOS app
✓ Installing app on simulator...
✓ Urban Glide splash screen appears
✓ Firebase initializes
✓ Maps ready
```

**Success Indicators:**
- No red errors in terminal
- App launches on iOS simulator
- Splash screen displays correctly
- Navigation works smoothly

---

### **6b. Build Driver App (iOS)**

```powershell
cd c:\src\Claude\driver_app
flutter clean
flutter pub get
flutter run -d ios
```

**Expected Output Timeline:**

```
✓ Building iOS project...
✓ Running Xcode build...
✓ Built iOS app
✓ Installing app on simulator...
✓ Urban Glide Driver splash screen appears
✓ Firebase initializes
✓ Maps ready
```

---

## ✅ STEP 7: FIREBASE VERIFICATION (5 minutes)

### **7a. Create Test User in Firebase**

1. Open: **https://console.firebase.google.com/project/urban-glide-transport-25**
2. Navigate: **Authentication → Users**
3. Click: **Add user** (top right)
4. Enter details:
   - Email: `test@urbangilde.dev`
   - Password: `Test@123456`
5. Click: **Add user**

**Expected Result:**
```
✓ User created
✓ Email: test@urbangilde.dev
✓ Status: Enabled
```

---

### **7b. Test Login in Running App**

**While either app is still running:**

1. See: **Login Screen**
2. Enter:
   - Email: `test@urbangilde.dev`
   - Password: `Test@123456`
3. Tap: **Sign In** button
4. Expected result:

```
✓ Authentication succeeds
✓ Loading spinner shows
✓ Home screen loads
✓ User data displayed
```

**Troubleshooting if login fails:**
- Check internet connection
- Verify email/password entered correctly
- Check Firebase Console shows user created
- Check Firebase security rules (should allow reads/writes for authenticated users)

---

### **7c. Verify Firestore Data**

1. Open: **Firebase Console → Firestore Database**
2. Navigate: **Collections → passengers**
3. Look for: New document with email `test@urbangilde.dev`

**Expected Firestore Document:**
```
Document ID: [auto-generated]
Fields:
  - email: "test@urbangilde.dev"
  - name: "" (empty)
  - phone: "" (empty)
  - rating: 0
  - totalRides: 0
  - createdAt: [timestamp]
```

**Success Indicators:**
- ✅ New passenger document created
- ✅ User data synced to Firestore
- ✅ Real-time sync working

---

## 📊 BUILD EXECUTION CHECKLIST

### Android Builds:
- [ ] Passenger app builds without errors
- [ ] Passenger app runs on Android device/emulator
- [ ] Splash screen displays correctly
- [ ] Navigation works
- [ ] Driver app builds without errors
- [ ] Driver app runs on Android device/emulator
- [ ] Splash screen displays correctly
- [ ] Navigation works

### iOS Builds:
- [ ] Passenger app builds without errors
- [ ] Passenger app runs on iOS simulator
- [ ] Splash screen displays correctly
- [ ] Navigation works
- [ ] Driver app builds without errors
- [ ] Driver app runs on iOS simulator
- [ ] Splash screen displays correctly
- [ ] Navigation works

### Firebase Verification:
- [ ] Test user created in Firebase Console
- [ ] Login succeeds in at least one app
- [ ] User data visible in Firestore passengers collection
- [ ] Real-time sync confirmed

---

## 🆘 COMMON BUILD ISSUES & SOLUTIONS

### Issue: "Flutter command not found"
**Solution:**
```powershell
flutter doctor
# Should show Flutter SDK path. If not installed:
# Download from https://flutter.dev/docs/get-started/install
```

### Issue: "Android SDK not found"
**Solution:**
```powershell
flutter doctor
# Follow instructions to install Android SDK
# Or set ANDROID_HOME environment variable
```

### Issue: "No connected devices found"
**Solution:**
- Start Android emulator: Open Android Studio → Device Manager → Start emulator
- Or connect physical Android device via USB (Enable Developer Mode)
- Run: `flutter devices` to verify device shows

### Issue: "Pod install failed" (iOS)
**Solution:**
```powershell
cd ios
pod repo update
pod install
cd ..
flutter run -d ios
```

### Issue: "Xcode build failed" (iOS)
**Solution:**
```powershell
cd ios
xcode-select --reset
cd ..
flutter clean
flutter pub get
flutter run -d ios
```

### Issue: "API key not valid for Maps"
**Solution:**
- Verify API key is correctly configured in:
  - Android: `AndroidManifest.xml` (both apps)
  - iOS: `AppDelegate.swift` (both apps)
  - Web: `web/index.html` (admin app)
- Check Google Cloud Console that APIs are enabled:
  - Maps SDK for Android ✓
  - Maps SDK for iOS ✓

### Issue: "Firebase authentication failed"
**Solution:**
- Check internet connection
- Verify test user exists in Firebase Console
- Check password entered correctly (case-sensitive)
- Check Firebase security rules allow authentication

### Issue: "Firestore permission denied"
**Solution:**
- Open Firebase Console → Firestore Database → Rules
- Verify rules allow authenticated user writes:
  ```
  allow read, write: if request.auth != null;
  ```

---

## 📈 EXPECTED BUILD TIMES

```
Passenger App (Android):    8-12 minutes first build
Driver App (Android):       5-8 minutes (cached)
Passenger App (iOS):        10-15 minutes first build
Driver App (iOS):           8-12 minutes (cached)
Firebase Verification:      2-3 minutes
─────────────────────────────────────────────
TOTAL STEP 5-7:             ~45-60 minutes
```

---

## ✨ SUCCESS CRITERIA - PHASE 2 COMPLETE

**All of these must be true:**

1. ✅ Passenger app builds on Android
2. ✅ Passenger app runs on Android
3. ✅ Driver app builds on Android
4. ✅ Driver app runs on Android
5. ✅ Passenger app builds on iOS
6. ✅ Passenger app runs on iOS
7. ✅ Driver app builds on iOS
8. ✅ Driver app runs on iOS
9. ✅ Test user created in Firebase
10. ✅ Login works in at least one running app
11. ✅ User data appears in Firestore
12. ✅ Real-time sync confirmed

**When all 12 are true:** Phase 2 is **COMPLETE** ✅

---

## 🎯 NEXT STEPS AFTER PHASE 2

Once Phase 2 is complete:

### Phase 3: Web Admin Deployment (15 minutes)
```powershell
cd c:\src\Claude\admin_app
flutter build web --release
firebase deploy --only hosting
```

### Phase 4: System Testing (30 minutes)
- Create multiple test users
- Test ride booking workflow
- Verify real-time updates
- Check push notifications
- Test driver-passenger matching

### Phase 5: Launch to Production
- Enable billing in Firebase Console
- Set up App Store/Play Store releases
- Configure production builds
- Enable monitoring and analytics

---

## 📞 QUICK COMMAND REFERENCE

### Clean All:
```powershell
cd c:\src\Claude\passenger_app; flutter clean
cd c:\src\Claude\driver_app; flutter clean
cd c:\src\Claude\admin_app; flutter clean
```

### Get Dependencies (All):
```powershell
cd c:\src\Claude\passenger_app; flutter pub get
cd c:\src\Claude\driver_app; flutter pub get
cd c:\src\Claude\admin_app; flutter pub get
```

### List Available Devices:
```powershell
flutter devices
```

### Build APK (Android Release):
```powershell
cd c:\src\Claude\passenger_app
flutter build apk --release
flutter build appbundle --release
```

### Build for iOS Release:
```powershell
cd c:\src\Claude\passenger_app
flutter build ios --release
```

### Build for Web Release:
```powershell
cd c:\src\Claude\admin_app
flutter build web --release
```

---

## 🚀 START HERE

**Execute in this order:**

1. **Terminal 1:** Run Passenger App (Android)
2. **Terminal 2:** Run Driver App (Android)  
3. **Terminal 3:** Run Passenger App (iOS)
4. **Terminal 4:** Run Driver App (iOS)
5. **Browser:** Create test user in Firebase Console
6. **App:** Test login with test user
7. **Firebase Console:** Verify user data in Firestore

---

## ✅ FINAL CHECKLIST

Before starting builds:
- [ ] PowerShell terminal open
- [ ] Android emulator/device connected or started
- [ ] iOS simulator running or physical device connected
- [ ] Internet connection verified
- [ ] Flutter doctor shows all ✓
- [ ] API keys triple-checked

**Ready?** → Start with: `cd c:\src\Claude\passenger_app && flutter clean && flutter pub get && flutter run -d android`

🎉 **LET'S BUILD URBAN GLIDE!** 🎉

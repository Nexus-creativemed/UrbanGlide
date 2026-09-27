# Firebase Setup Checklist - Urban Glide
**Status:** Ready to Deploy  
**Project ID:** `urban-glide-transport-25`  
**Target Databases:** Firestore (real-time), Cloud Functions (4 triggers)

---

## Phase 1: Prerequisites (5 minutes)

### Local Setup
- [ ] **Node.js installed** (`node --version` should show v16+)
  ```powershell
  node --version
  ```

- [ ] **Firebase CLI installed** 
  ```powershell
  npm install -g firebase-tools
  firebase --version
  ```

- [ ] **Logged into Firebase**
  ```powershell
  firebase login
  ```

- [ ] **Correct project selected**
  ```powershell
  firebase use urban-glide-transport-25
  firebase projects:list
  ```

---

## Phase 2: Backend Deployment (10 minutes)

### Cloud Functions Setup
- [ ] Navigate to `firebase/functions` directory
- [ ] Install dependencies
  ```powershell
  cd firebase/functions
  npm install
  ```

- [ ] Verify functions syntax
  ```powershell
  npm run lint
  ```

- [ ] Deploy functions
  ```powershell
  cd ..
  firebase deploy --only functions
  ```

- [ ] Verify deployment
  ```powershell
  firebase functions:list
  firebase functions:log --limit 10
  ```

**Functions Deployed:**
- ✅ `onRideCreated` (searches nearby drivers, sends notifications)
- ✅ `onRideAccepted` (notifies passenger of driver acceptance)
- ✅ `onDriverArrived` (notifies passenger of driver arrival)
- ✅ `onRideCompleted` (notifies both parties, records earnings)

### Firestore Rules Deployment
- [ ] Deploy security rules
  ```powershell
  firebase deploy --only firestore:rules
  ```

- [ ] Verify rules deployed
  ```powershell
  firebase firestore:indexes --list
  ```

**Rules Configured:**
- ✅ Role-based access control (passengers, drivers, admins)
- ✅ Field validation (email, phone format)
- ✅ User data immutability protection
- ✅ Read-only collections for sensitive data

---

## Phase 3: Firestore Collections (5 minutes)

### Auto-Created Collections (On First App Use)
Collections are created automatically when apps first write data:

- ✅ `passengers` - Created when passenger signs up
- ✅ `drivers` - Created when driver signs up
- ✅ `rides` - Created when passenger requests ride
- ✅ `support` - Created on support request
- ✅ `notifications` - Created by Cloud Functions

### Manual Collections (Optional - Pre-Create)
For better Firestore Console experience:

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select `urban-glide-transport-25`
3. Click **Firestore Database**
4. Click **Create Collection**
5. Enter collection name and click **Next**

**Collections to create:**
- [ ] `admins` - Admin user profiles
- [ ] `analytics` - System analytics (server-only write)
- [ ] `earnings` - Driver earnings records (server-only write)

---

## Phase 4: Android Configuration (20 minutes)

### Passenger App (passenger_app)

#### 4.1 Firebase Configuration
- [ ] Download `google-services.json` from Firebase Console
  1. Go to [Firebase Console](https://console.firebase.google.com)
  2. Select `urban-glide-transport-25` → Project Settings
  3. Click **Your Apps** → Android app (create if needed)
  4. Download **google-services.json**

- [ ] Place file in correct location
  ```
  passenger_app/android/app/google-services.json
  ```

- [ ] Verify file exists
  ```powershell
  Test-Path passenger_app\android\app\google-services.json
  ```

#### 4.2 Google Maps API Key
- [ ] Create Google Maps API Key
  1. Go to [Google Cloud Console](https://console.cloud.google.com)
  2. Select `urban-glide-transport-25` project
  3. Enable APIs: Maps SDK for Android, Geocoding, Directions
  4. Create API Key (Credentials → API Key)
  5. Restrict to Android package: `com.urban_glide.passenger_app`

- [ ] Update AndroidManifest.xml
  ```bash
  # File: passenger_app/android/app/src/main/AndroidManifest.xml
  # Find: YOUR_GOOGLE_MAPS_API_KEY_HERE
  # Replace with: [actual API key]
  ```

- [ ] Verify update
  ```powershell
  Select-String -Path "passenger_app\android\app\src\main\AndroidManifest.xml" `
    -Pattern "com.google.android.geo.API_KEY"
  ```

### Driver App (driver_app)

#### 4.3 Firebase Configuration
- [ ] Download `google-services.json` from Firebase Console
  1. Same as Passenger App step 1-4
  2. For Android app with package: `com.urban_glide.driver_app`

- [ ] Place file in correct location
  ```
  driver_app/android/app/google-services.json
  ```

#### 4.4 Google Maps API Key
- [ ] Create API Key restriction for driver app
  1. Same as Passenger App step 2-3
  2. Restrict to Android package: `com.urban_glide.driver_app`

- [ ] Update AndroidManifest.xml
  ```bash
  # File: driver_app/android/app/src/main/AndroidManifest.xml
  # Find: YOUR_GOOGLE_MAPS_API_KEY_HERE
  # Replace with: [driver app API key]
  ```

---

## Phase 5: iOS Configuration (20 minutes)

### Passenger App (passenger_app)

#### 5.1 Firebase Configuration
- [ ] Download `GoogleService-Info.plist` from Firebase Console
  1. Go to [Firebase Console](https://console.firebase.google.com)
  2. Select `urban-glide-transport-25` → Project Settings
  3. Click **Your Apps** → iOS app (create if needed)
  4. Bundle ID: `com.urban-glide.passenger-app`
  5. Download **GoogleService-Info.plist**

- [ ] Place file in correct location
  ```
  passenger_app/ios/Runner/GoogleService-Info.plist
  ```

- [ ] Add to Xcode project
  1. Open `passenger_app/ios/Runner.xcworkspace` in Xcode
  2. Right-click **Runner** folder → Add Files to Runner
  3. Select GoogleService-Info.plist
  4. Ensure target is checked for Runner
  5. Click Add

#### 5.2 Google Maps API Key
- [ ] Create Google Maps API Key (if not already done for Android)
  ```swift
  // File: passenger_app/ios/Runner/AppDelegate.swift
  // Add: GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY_HERE")
  ```

- [ ] Update AppDelegate.swift
  ```swift
  import GoogleMaps
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GMSServices.provideAPIKey("YOUR_API_KEY_HERE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  ```

#### 5.3 Location Permissions
- [ ] Update Info.plist with location permissions
  1. Open `passenger_app/ios/Runner/Info.plist` in Xcode
  2. Add keys:
     - `NSLocationWhenInUseUsageDescription`
     - `NSLocationAlwaysAndWhenInUseUsageDescription`

### Driver App (driver_app)

#### 5.4 Firebase Configuration
- [ ] Download `GoogleService-Info.plist` for driver app
  1. Bundle ID: `com.urban-glide.driver-app`

- [ ] Place file in correct location
  ```
  driver_app/ios/Runner/GoogleService-Info.plist
  ```

#### 5.5 Google Maps API Key
- [ ] Update AppDelegate.swift (same as passenger app)

#### 5.6 Location Permissions
- [ ] Update Info.plist (same as passenger app)

#### 5.7 Push Notifications (iOS Only)
- [ ] Enable Push Notifications capability
  1. Open `ios/Runner.xcworkspace` in Xcode
  2. Select **Runner** → **Signing & Capabilities**
  3. Click **+ Capability**
  4. Add **Push Notifications**
  5. Repeat for driver_app

---

## Phase 6: Web Admin App Configuration (10 minutes)

### Admin App (admin_app)

#### 6.1 Firebase Web Configuration
- [ ] Get Firebase Web Config
  1. Go to [Firebase Console](https://console.firebase.google.com)
  2. Select `urban-glide-transport-25` → Project Settings
  3. Click **Your Apps** → Web app (create if needed)
  4. Copy Firebase config (JavaScript)

- [ ] Update web/index.html
  ```bash
  # File: admin_app/web/index.html
  # Find: firebaseConfig = { ... }
  # Replace with: [copied config from console]
  ```

#### 6.2 CORS Configuration (Optional)
If admin app is on different domain:
```powershell
# Configure Firestore CORS in firebase.json
# Already configured for development
```

---

## Phase 7: Push Notifications Setup (15 minutes)

### Android Push Notifications

#### 7.1 Permissions
- [ ] Verify AndroidManifest.xml has required permissions
  ```xml
  <uses-permission android:name="android.permission.INTERNET" />
  <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
  ```

#### 7.2 Notification Channels
Already configured in Dart code:
- ✅ "Ride Requests" (high priority, sound, vibration)
- ✅ "Ride Updates" (high priority)

### iOS Push Notifications

#### 7.3 APNs Certificate
- [ ] Create APNs certificate in Apple Developer Console
  1. Go to [Apple Developer Console](https://developer.apple.com)
  2. Certificates, Identifiers & Profiles → Keys
  3. Create new key with Apple Push Notifications service (APNs)
  4. Download .p8 file

- [ ] Upload to Firebase
  1. Firebase Console → Project Settings → Cloud Messaging
  2. Click **Upload APNs certificate**
  3. Upload .p8 file
  4. Enter Key ID and Team ID

---

## Phase 8: Testing (10 minutes)

### Firebase Connectivity Test

#### 8.1 Cloud Functions Test
```powershell
# Test function deployment
firebase functions:log --limit 20

# Create test ride to trigger onRideCreated
# Check logs for successful execution
```

#### 8.2 Firestore Access Test
```powershell
# Check if collections exist
firebase firestore:documents --collection passengers --limit 1

# Test write permissions
firebase firestore:documents --collection test --upsert --data '{"test": true}'
```

#### 8.3 Push Notifications Test
1. Firebase Console → Cloud Messaging
2. Click "Send your first message"
3. Create test notification
4. Select app instance
5. Send test
6. Verify notification received on device

### App Connectivity Test

#### 8.4 Passenger App Test
```powershell
cd passenger_app
flutter clean
flutter pub get
flutter run -d [device_id]

# Test Firebase login
# Verify real-time Firestore connections
```

#### 8.5 Driver App Test
```powershell
cd driver_app
flutter clean
flutter pub get
flutter run -d [device_id]

# Test Firebase login
# Verify location tracking enabled
# Verify real-time ride requests received
```

#### 8.6 Admin App Test
```powershell
cd admin_app
flutter clean
flutter pub get
flutter run -d chrome

# Verify hardcoded login: admin/admin123
# Verify real-time dashboard updates
```

---

## Phase 9: Pre-Launch Verification (5 minutes)

### Deployment Checklist
- [ ] Cloud Functions deployed and verified
- [ ] Firestore Rules deployed and verified
- [ ] google-services.json in both Android apps
- [ ] GoogleService-Info.plist in both iOS apps
- [ ] Google Maps API keys configured
- [ ] Push notifications enabled
- [ ] All three apps compile without errors
- [ ] Firebase connectivity tests passed
- [ ] Admin can login to dashboard
- [ ] Passenger can sign up and book ride
- [ ] Driver can accept and complete ride

### Production Readiness
- [ ] PayFast merchant credentials configured (if using payments)
- [ ] Firebase backup enabled (optional)
- [ ] Error reporting configured (optional)
- [ ] Performance monitoring enabled (optional)
- [ ] Cloud logging reviewed

---

## Phase 10: Launch (Ongoing)

### Immediate Post-Launch
- [ ] Monitor Cloud Functions logs for errors
- [ ] Monitor Firestore for data integrity
- [ ] Monitor push notification delivery
- [ ] Gather user feedback on payment processing

### First Week Monitoring
- [ ] Track app crash reports
- [ ] Review real-time database performance
- [ ] Verify location accuracy in production
- [ ] Check payment success rates

### Scaling & Optimization
- [ ] Increase Cloud Functions max instances if needed
- [ ] Optimize Firestore indexes based on queries
- [ ] Enable Firestore backup for production data
- [ ] Configure Firebase Alerts for quota limits

---

## Quick Command Reference

```powershell
# Deploy everything
cd firebase
firebase deploy --only functions,firestore:rules

# Check deployment status
firebase functions:list
firebase firestore:indexes --list

# View logs
firebase functions:log --limit 50
firebase firestore:documents --collection rides

# Test connection
firebase projects:list
firebase status

# Clean and restart
firebase logout
firebase login
firebase use urban-glide-transport-25
```

---

## Support & Troubleshooting

**Firebase CLI Issues:**
- Clear cache: `firebase logout && firebase login`
- Verify project: `firebase use urban-glide-transport-25`
- Check status: `firebase status`

**Cloud Functions Issues:**
- Check syntax: `npm run lint`
- View logs: `firebase functions:log --limit 100`
- Deploy debug: `firebase deploy --only functions --debug`

**Firestore Access Issues:**
- Verify rules: `firebase rules:list`
- Test rules: Use Firestore Console Rules Playground
- Check permissions: Ensure `request.auth != null`

**Google Maps Issues:**
- Enable APIs: Google Cloud Console → APIs & Services
- Verify API key: Check AndroidManifest.xml / AppDelegate.swift
- Test key: Try map URL with API key in browser

---

## Estimated Timeline

| Phase | Duration | Status |
|-------|----------|--------|
| Prerequisites | 5 min | ⏳ Pending |
| Backend Deployment | 10 min | ⏳ Pending |
| Firestore Setup | 5 min | ⏳ Pending |
| Android Config | 20 min | ⏳ Pending |
| iOS Config | 20 min | ⏳ Pending |
| Web Config | 10 min | ⏳ Pending |
| Notifications | 15 min | ⏳ Pending |
| Testing | 10 min | ⏳ Pending |
| Verification | 5 min | ⏳ Pending |
| **TOTAL** | **~90 min** | ⏳ Pending |

---

**Last Updated:** December 1, 2025  
**Next Action:** Start with Phase 1 (Prerequisites)  
**Support:** Refer to FIREBASE_INITIALIZATION_GUIDE.md for detailed instructions

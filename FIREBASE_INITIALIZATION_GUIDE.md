# Firebase Initialization Guide - Urban Glide
**Date:** December 1, 2025  
**Project:** Urban Glide Transportation  
**Firebase Project ID:** `urban-glide-transport-25`

---

## 🚀 Quick Start (15 minutes)

### Step 1: Prerequisites
```powershell
# Install Firebase CLI (if not already installed)
npm install -g firebase-tools

# Verify installation
firebase --version

# Login to Firebase
firebase login
```

### Step 2: Verify Firebase Project Connection
```powershell
# Navigate to firebase directory
cd firebase

# Check current project
firebase projects:list

# Select project (should be urban-glide-transport-25)
firebase use urban-glide-transport-25

# Verify connection
firebase projects:list --json
```

### Step 3: Deploy Cloud Functions (5 min)
```powershell
# Navigate to functions directory
cd firebase/functions

# Install dependencies
npm install

# Deploy functions
firebase deploy --only functions

# Verify deployment
firebase functions:list
firebase functions:log
```

### Step 4: Deploy Firestore Rules (2 min)
```powershell
# From firebase directory
firebase deploy --only firestore:rules

# Verify rules deployed
firebase rules:list
```

---

## 📱 Mobile App Configuration (Android)

### For `passenger_app` and `driver_app`:

#### Step 1: Download google-services.json
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select project: `urban-glide-transport-25`
3. Click ⚙️ **Project Settings**
4. Go to **Your Apps** tab
5. Find **Android** app (if not exists, create one)
6. Download **google-services.json**

#### Step 2: Place Configuration File
```
📁 passenger_app/
  📁 android/
    📁 app/
      ✏️ google-services.json  ← Place file here
      
📁 driver_app/
  📁 android/
    📁 app/
      ✏️ google-services.json  ← Place file here
```

#### Step 3: Verify AndroidManifest.xml
Both apps should have Google Maps API key configured:

**File:** `android/app/src/main/AndroidManifest.xml`

Find this section and add your Google Maps API key:
```xml
<application>
    <!-- Google Maps API Key -->
    <meta-data
        android:name="com.google.android.geo.API_KEY"
        android:value="YOUR_GOOGLE_MAPS_API_KEY_HERE" />
    
    <!-- Other manifest content -->
</application>
```

**To get Google Maps API Key:**
1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Select project: `urban-glide-transport-25`
3. Enable APIs:
   - Maps SDK for Android
   - Geocoding API
   - Directions API
   - Places API
4. Create API key (Credentials → Create Credentials → API Key)
5. Restrict to Android with package names:
   - `com.urban_glide.passenger_app`
   - `com.urban_glide.driver_app`

---

## 📱 Mobile App Configuration (iOS)

### For `passenger_app` and `driver_app`:

#### Step 1: Download GoogleService-Info.plist
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select project: `urban-glide-transport-25`
3. Click ⚙️ **Project Settings**
4. Go to **Your Apps** tab
5. Find **iOS** app (if not exists, create one with bundle ID: `com.urban-glide.passenger-app` or `com.urban-glide.driver-app`)
6. Download **GoogleService-Info.plist**

#### Step 2: Place Configuration File
```
📁 passenger_app/
  📁 ios/
    📁 Runner/
      ✏️ GoogleService-Info.plist  ← Place file here
      
📁 driver_app/
  📁 ios/
    📁 Runner/
      ✏️ GoogleService-Info.plist  ← Place file here
```

#### Step 3: Configure AppDelegate.swift
**File:** `ios/Runner/AppDelegate.swift`

Ensure this import exists:
```swift
import Firebase
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Initialize Firebase
    FirebaseApp.configure()
    
    // Configure Google Maps API Key
    GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY_HERE")
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```

#### Step 4: Update Info.plist
**File:** `ios/Runner/Info.plist`

Add these location permission keys:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Urban Glide needs your location to find nearby drivers</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Urban Glide needs your location to track your ride</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Urban Glide needs your location in the background for ride tracking</string>
```

---

## 🌐 Web Admin App Configuration

### For `admin_app`:

#### Step 1: Get Firebase Web Configuration
1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select project: `urban-glide-transport-25`
3. Click ⚙️ **Project Settings**
4. Go to **Your Apps** tab
5. Find **Web** app (if not exists, create one)
6. Copy the Firebase configuration (JavaScript snippet)

#### Step 2: Update web/index.html
**File:** `admin_app/web/index.html`

Replace Firebase config in the `<script>` section:
```html
<!-- Initialize Firebase -->
<script type="module">
  import { initializeApp } from "https://www.gstatic.com/firebasejs/10.7.0/firebase-app.js";
  import { getAuth } from "https://www.gstatic.com/firebasejs/10.7.0/firebase-auth.js";
  import { getFirestore } from "https://www.gstatic.com/firebasejs/10.7.0/firebase-firestore.js";

  const firebaseConfig = {
    apiKey: "YOUR_API_KEY",
    authDomain: "urban-glide-transport-25.firebaseapp.com",
    projectId: "urban-glide-transport-25",
    storageBucket: "urban-glide-transport-25.appspot.com",
    messagingSenderId: "572805775337",
    appId: "1:572805775337:web:YOUR_APP_ID"
  };

  const app = initializeApp(firebaseConfig);
  const auth = getAuth(app);
  const db = getFirestore(app);
</script>
```

---

## 🔥 Firestore Database Setup

### Collections to Create (Automatic on First Write)

The following collections are created automatically when the apps first write to them. No manual creation needed.

| Collection | Purpose | Documents |
|-----------|---------|-----------|
| `passengers` | User profiles | Auto-created on passenger signup |
| `drivers` | Driver profiles | Auto-created on driver signup |
| `rides` | Ride records | Auto-created when passenger requests ride |
| `admins` | Admin users | Manual creation needed |
| `support` | Support tickets | Auto-created on support request |
| `notifications` | Push notification logs | Auto-created by Cloud Functions |
| `earnings` | Driver earnings reports | Auto-created by Cloud Functions |
| `analytics` | System analytics | Manual creation (server-only write) |

### Manual Collection Creation (Optional)

To pre-create collections:
```powershell
# Open Firebase Console → Firestore Database
# Click "Create Collection"
# Enter collection name (e.g., "admins")
# Skip "Add first document" for now (optional)
```

---

## ☁️ Cloud Functions Deployment

### Prerequisites
- Node.js 18+ installed
- Firebase CLI logged in
- Located in `firebase/functions` directory

### Deployment Steps

```powershell
# Navigate to functions directory
cd firebase/functions

# Install dependencies
npm install

# Verify functions are correct
cat index.js  # Should show 4 functions: onRideCreated, onRideAccepted, onDriverArrived, onRideCompleted

# Deploy functions
firebase deploy --only functions

# Wait for deployment to complete (2-3 minutes)

# Verify deployment
firebase functions:list
firebase functions:log --limit 50
```

### Deployed Functions
1. **onRideCreated** - Triggers on new ride (status: searching)
   - Finds nearby drivers within 5km
   - Sends FCM notifications
   
2. **onRideAccepted** - Triggers when ride status changes (accepted)
   - Notifies passenger with driver details
   
3. **onDriverArrived** - Triggers when ride status changes (pickup)
   - Notifies passenger driver has arrived
   
4. **onRideCompleted** - Triggers when ride status changes (completed)
   - Notifies both passenger and driver
   - Records earnings

### Testing Cloud Functions Locally

```powershell
# From firebase directory
firebase emulators:start

# In another terminal, test a function
curl http://localhost:5001/urban-glide-transport-25/us-central1/onRideCreated
```

---

## 🔐 Firestore Security Rules

### Current Rules Implementation
- ✅ Role-based access control (passengers, drivers, admins)
- ✅ Field-level validation (email, phone format)
- ✅ User can only modify their own data
- ✅ Read-only collections for sensitive data (analytics, earnings)
- ✅ Audit trail protection (rides cannot be deleted)

### Deploy Rules

```powershell
# From firebase directory
firebase deploy --only firestore:rules

# Verify rules deployed
firebase firestore:indexes --list
```

### Test Rules in Firebase Console
1. Go to Firestore Database → Rules tab
2. Click "Rules Playground" to test access patterns
3. Select a rule and verify access control

---

## 📲 Push Notifications Setup

### Firebase Messaging Configuration

#### Android Setup
**File:** `android/app/src/main/AndroidManifest.xml`

Ensure these permissions exist:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

#### iOS Setup
**File:** `ios/Runner/Info.plist`

Add notification permissions:
```xml
<key>UIUserInterfaceStyle</key>
<string>Dark</string>
```

Enable push notifications in Xcode:
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select **Runner** target
3. Go to **Signing & Capabilities**
4. Click **+ Capability**
5. Search and add **Push Notifications**

### Test Push Notifications

1. Go to Firebase Console → Cloud Messaging
2. Create a test notification
3. Select app instance
4. Send test message
5. Check device for notification

---

## 🔗 Environment Variables

### Create `.env` file for sensitive data

**File:** `firebase/functions/.env`
```
MERCHANT_ID=10000100
MERCHANT_KEY=46f0cd694581a
PAYFAST_PASSPHRASE=your-passphrase
NOTIFICATION_TIMEOUT=30000
MAX_SEARCH_RADIUS=5000
```

### Usage in Code
```dart
// In PaymentService
const String merchantId = 'YOUR_MERCHANT_ID';
const String merchantKey = 'YOUR_MERCHANT_KEY';
```

---

## ✅ Verification Checklist

### Pre-Launch Verification

- [ ] Firebase project `urban-glide-transport-25` created
- [ ] Android app registered with Firebase (Bundle ID: `com.urban_glide.passenger_app`, `com.urban_glide.driver_app`)
- [ ] iOS app registered with Firebase (Bundle ID: `com.urban-glide.passenger-app`, `com.urban-glide.driver-app`)
- [ ] Web app registered with Firebase
- [ ] google-services.json downloaded to `passenger_app/android/app/` and `driver_app/android/app/`
- [ ] GoogleService-Info.plist downloaded to `passenger_app/ios/Runner/` and `driver_app/ios/Runner/`
- [ ] Google Maps API keys configured in AndroidManifest.xml (both apps)
- [ ] Google Maps API keys configured in AppDelegate.swift (both apps)
- [ ] Cloud Functions deployed: `firebase deploy --only functions` ✅
- [ ] Firestore Rules deployed: `firebase deploy --only firestore:rules` ✅
- [ ] Firestore collections verified (can view in Console)
- [ ] Push notifications tested (send test message from Cloud Messaging)
- [ ] PayFast merchant credentials configured (if using production)

### Post-Launch Verification

- [ ] Passenger can sign up and create account
- [ ] Driver can sign up and create account
- [ ] Passenger can request ride
- [ ] Driver receives ride notification
- [ ] Driver can accept ride
- [ ] Real-time location tracking works
- [ ] Ride completion updates both parties
- [ ] Admin dashboard shows real-time data
- [ ] Payment gateway processes transactions

---

## 📞 Troubleshooting

### Firebase CLI Issues
```powershell
# Clear Firebase cache
firebase logout
firebase login

# Verify project
firebase use urban-glide-transport-25

# Check status
firebase status
```

### Cloud Functions Not Deploying
```powershell
# Check for syntax errors
npm run lint

# Install dependencies
cd firebase/functions
npm install

# Try deployment again
firebase deploy --only functions --debug
```

### Firestore Rules Test Failed
```powershell
# Deploy in test mode (not production)
firebase deploy --only firestore:rules --debug

# Check rules syntax
firebase firestore:rules:list
```

### Missing google-services.json
- Download from Firebase Console → Project Settings → Your Apps → Android → Download google-services.json
- Place in `<app>/android/app/` directory
- Rebuild: `flutter clean && flutter pub get && flutter run`

### Google Maps Not Loading
- Verify API key in AndroidManifest.xml
- Verify API key in AppDelegate.swift
- Enable Maps SDK for Android/iOS in Google Cloud Console
- Verify API key restrictions (allow all for development, restrict later)

---

## 🎯 Next Steps

1. **Immediate:** Run all steps in "Quick Start" section
2. **Android Setup:** Configure google-services.json and Google Maps keys
3. **iOS Setup:** Configure GoogleService-Info.plist and Google Maps keys
4. **Testing:** Run apps and verify Firebase connectivity
5. **Launch:** Deploy to production Firebase project

---

**Estimated Total Time:** ~90 minutes (depending on API key configuration)

**Support:** Refer to `/firebase/SERVICE_ACCOUNT_GUIDE.md` for advanced configuration

---

**Last Updated:** December 1, 2025

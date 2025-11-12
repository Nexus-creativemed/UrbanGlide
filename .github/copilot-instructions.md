# Urban Glide - AI Agent Instructions

## 🏗️ Architecture Overview

**Flutter/Dart monorepo** with 3 production apps + Firebase backend + 10 optional feature modules:

```
Claude/                               # Main workspace
├── passenger_app/                    # Consumer app (Flutter mobile)
├── driver_app/                       # Driver partner app (Flutter mobile)  
├── admin_app/                        # Admin dashboard (Flutter web)
├── firebase/                         # Backend (Firestore rules, Cloud Functions)
│   ├── firestore.rules               # Production security rules
│   └── functions/index.js            # 4 notification triggers
└── Functions2/                       # Optional feature modules (isolated)
    ├── urban_glide_admin_levels/     # Multi-tier admin with OTP freeze
    ├── urban_glide_panic_demo/       # Emergency panic button
    ├── urban_glide_scheduling_system/ # Pre-scheduled rides
    └── [7 more independent modules...]
```

**Critical Distinction:** Root apps are **production-ready** (2.0 release). `Functions2/` contains **experimental feature modules** — each self-contained with own Firebase Functions, Flutter apps, and deployment scripts. Do not mix them into core apps without explicit user request.

**Tech Stack:**
- **Backend**: Firebase (Auth, Firestore real-time sync, Cloud Functions, FCM)
- **State Management**: Provider pattern (passenger/driver apps); direct `StreamBuilder` (admin)
- **Mapping**: Google Maps Platform (live tracking, geocoding, route polylines)
- **Payment**: PayFast (South African market, sandbox mode available)
- **Testing**: 36+ tests (unit, widget, integration, performance, security)

## ✅ Production Readiness Status

**READY FOR LAUNCH** after Firebase/Google Maps configuration (~90min setup).

**Core Features Complete:**
- ✅ Real-time location tracking (`RealtimeLocationService` - 10m/5s broadcasts)
- ✅ Push notifications (`NotificationService` + 4 Cloud Functions triggers)
- ✅ Intelligent matching (`MatchingService` - scoring algorithm, surge pricing)
- ✅ Payment integration (`PaymentService` - PayFast gateway with MD5 signatures)
- ✅ Security rules (role-based access, field validation, audit trails)
- ✅ Error handling (`ErrorHandler`, `RetryHandler`, `ConnectivityService`)

**Missing (not blockers for MVP):**
- Phone/SMS verification (currently email/password only)
- Driver background check workflow (isVerified flag exists, no UI)
- In-app navigation (no Google Maps deep linking)
- Rating submission UI (fields exist in Firestore models)
- Promo codes, commission calculations, in-app support

**Test Coverage:** 36+ tests across 5 categories (see `passenger_app/test/` and `driver_app/test/`)

## 📦 Three Core Apps

**`passenger_app/`** (Mobile: Android/iOS)
- Ride booking flow: pickup/dropoff selection, fare estimation
- Real-time driver tracking with live map markers + ETA
- Firebase Auth, ride history, profile management
- Provider state: `AuthProvider`, `RideProvider`, `LocationProvider`, `RealtimeRideProvider`
- Theme: Neon cyan (#00D9FF) on dark navy (#0A1628)

**`driver_app/`** (Mobile: Android/iOS)  
- Real-time ride requests via Firestore streams (`.snapshots()`)
- Availability toggle, ride acceptance/rejection
- Continuous location broadcasting via `Geolocator.getPositionStream()`
- Provider state: `DriverAuthProvider`, `DriverRideProvider`, `DriverLocationProvider`
- Same neon aesthetic as passenger app

**`admin_app/`** (Web: Chrome/Edge)
- Dashboard: metrics, user management, ride monitoring, analytics
- **No Provider** - uses direct `StreamBuilder<QuerySnapshot>` inline
- Hardcoded auth: `admin` / `admin123`
- Uses `fl_chart` for visualization

## 🎯 What to Expect from This Codebase

**Monorepo Structure:** Each app (`passenger_app/`, `driver_app/`, `admin_app/`) is a **standalone Flutter project**. Always `cd` into the app directory before running Flutter commands.

**State Management Patterns:**
- `passenger_app/` & `driver_app/`: Provider pattern (`provider: ^6.1.1`)
  - Registered in `main.dart` with `MultiProvider`
  - Access: `Provider.of<T>(context, listen: false)` for one-time reads, `context.watch<T>()` for reactive updates
  - **Critical:** Always use `listen: false` in `initState()`, event handlers, and async callbacks to avoid rebuild loops
- `admin_app/`: NO Provider - direct `StreamBuilder` queries
  - Firestore queries inline in widgets: `StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection('rides').snapshots())`
  - Simpler for read-only dashboards, but harder to share state across widgets

**Firebase Collections & Schema:**
- `passengers` (id, name, email, phone, rating, totalRides, createdAt)
- `drivers` (id, name, email, phone, vehicleModel, vehicleNumber, licenseNumber, rating, totalRides, earnings, **isAvailable**, **isVerified**, **currentLocation** {lat, lng, lastUpdated}, **fcmToken**)
- `rides` (id, passengerId, driverId, status: **searching** → **accepted** → **pickup** → **in_progress** → **completed**, pickupLocation, dropoffLocation, fare, createdAt, acceptedAt, completedAt, driverRating, passengerRating)
- `admins`, `support`, `notifications`, `promoCodes`, `earnings`, `analytics`
- **Key Pattern:** All location fields use GeoPoint type for Firestore; converted to LatLng for Google Maps

**Real-Time Data Flows:**
1. **Ride Request:** Passenger creates ride → Cloud Function finds nearby drivers → Sends FCM notifications
2. **Driver Accepts:** Driver updates ride status → Passenger notified → Real-time location stream starts
3. **Location Tracking:** Driver broadcasts via `Geolocator.getPositionStream()` → Firestore `drivers/{id}/currentLocation` → Passenger listens via `RealtimeLocationService`
4. **Ride Completion:** Driver marks complete → Cloud Function notifies both parties → Earnings calculated

## ⚠️ Critical: No `--no-sound-null-safety` Needed

**VS Code Tasks** (`.vscode/tasks.json`): 12 predefined tasks for common operations
- Run: `flutter: Run Passenger App`, `flutter: Run Driver App`, `flutter: Run Admin App (Chrome)`
- Build: `flutter: Build APK (Passenger)`, `flutter: Build APK (Driver)`
- Maintenance: `flutter: Clean All`, `flutter: Get Dependencies (All Apps)`
- Firebase: `firebase: Deploy Functions`, `firebase: Deploy Firestore Rules`, `firebase: Emulate Functions`

**Manual Commands:**
```powershell
# Run apps (always cd into app directory first)
cd passenger_app; flutter run
cd driver_app; flutter run
cd admin_app; flutter run -d chrome

# Install dependencies for all apps
cd passenger_app; flutter pub get; cd ../driver_app; flutter pub get; cd ../admin_app; flutter pub get

# Run tests
flutter test                           # All tests
flutter test test/unit_tests/          # Unit tests only
flutter test test/integration_tests/   # Integration tests only
flutter test --coverage                # With coverage report
```

## 🚀 Agent Onboarding Checklist

When starting work, verify these key locations:
1. **App structure:** `passenger_app/`, `driver_app/`, `admin_app/` (each has own `pubspec.yaml`, `lib/`, `test/`)
2. **State management:** Check `lib/providers/` in passenger/driver apps (admin uses no Provider)
3. **Services:** `lib/services/` contains Firebase, location, notification, matching, payment integrations
4. **Models:** `lib/models/` for data structures with Firestore serialization
5. **Tests:** `test/unit_tests/`, `test/widget_tests/`, `test/integration_tests/`, `test/performance_tests/`, `test/security_tests/`
6. **Firebase:** `firebase/firestore.rules` (security) and `firebase/functions/index.js` (notification triggers)

## 🔧 Common Development Workflows

### Adding a New Provider (State Management)
1. Create provider in `lib/providers/new_provider.dart` extending `ChangeNotifier`
2. Register in `main.dart` `MultiProvider`:
   ```dart
   MultiProvider(
     providers: [
       ChangeNotifierProvider(create: (_) => AuthProvider()),
       ChangeNotifierProvider(create: (_) => NewProvider()), // Add here
     ],
   )
   ```
3. Access in widgets: `Provider.of<NewProvider>(context, listen: false).methodName()`
4. Trigger rebuilds: Call `notifyListeners()` after state changes

### Adding a New Firebase Cloud Function
1. Edit `firebase/functions/index.js`
2. Add trigger: `exports.onNewEvent = functions.firestore.document('collection/{docId}').onCreate((snap, context) => { ... });`
3. Deploy: `cd firebase && firebase deploy --only functions` (or use VS Code task)
4. Test locally: `firebase emulators:start` (requires Java 11+)

### Modifying Firestore Security Rules
1. Edit `firebase/firestore.rules`
2. Test syntax: `firebase deploy --only firestore:rules --debug`
3. Deploy: `firebase deploy --only firestore:rules` (or use VS Code task)
4. Verify in Firebase Console → Firestore Database → Rules tab

### Debugging Real-Time Location Issues
1. Check driver's `isAvailable` flag in Firestore: `drivers/{driverId}.isAvailable == true`
2. Verify location permissions: `Geolocator.checkPermission()` returns `LocationPermission.always` or `LocationPermission.whileInUse`
3. Monitor Firestore writes: `drivers/{driverId}.currentLocation.lastUpdated` should update every 5-10 seconds
4. Check passenger's listener: `RealtimeRideProvider.startListeningToRide()` called in `initState()`

### Testing Payment Integration
1. Use PayFast sandbox mode: `PaymentService._baseUrl = 'https://sandbox.payfast.co.za'`
2. Sandbox credentials in `lib/services/payment_service.dart` (merchant_id: `10000100`, merchant_key: `46f0cd694581a`)
3. Test cards: Visa `4000000000000002`, Mastercard `5200000000000015` (always succeed in sandbox)
4. Verify webhook: Check Firebase Functions logs for ITN callback handling

## What to document in your first summary
- Project language: Dart (SDK `>=3.0.0 <4.0.0` from `pubspec.yaml`).
- **Package manager**: `flutter pub get` to install dependencies.
- **Build command**: `flutter build <platform>` (e.g., `flutter build apk`, `flutter build ios`, `flutter build web`).
- **Test commands**: 
  - `flutter test` — Run all tests (unit, widget, integration)
  - `flutter test test/unit_tests/` — Run unit tests only
  - `flutter test test/widget_tests/` — Run widget tests only
  - `flutter test test/integration_tests/ --integration` — Run integration tests only
  - `flutter test test/<file>_test.dart` — Run specific test file
  - `flutter test --coverage` — Generate coverage report
- **Run command**: `cd passenger_app && flutter run` (or `driver_app`, `admin_app`; specify device with `-d <device_id>`).
- **Dependencies** (from `passenger_app/pubspec.yaml` v1.0.0+1):
  - **Core Flutter**: `flutter`, `cupertino_icons ^1.0.2`
  - **Firebase**: `firebase_core ^2.24.2`, `firebase_auth ^4.15.3`, `cloud_firestore ^4.13.6`, `firebase_messaging ^14.7.9`
  - **Google Maps**: `google_maps_flutter ^2.5.0`, `geolocator ^10.1.0`, `geocoding ^2.1.1`, `flutter_polyline_points ^2.0.1`
  - **Notifications**: `flutter_local_notifications ^16.2.0`
  - **Networking**: `http ^1.1.0`, `connectivity_plus ^5.0.2`
  - **State Management**: `provider ^6.1.1`
  - **Utilities**: `uuid ^4.2.1`, `intl ^0.18.1`, `url_launcher ^6.2.2`
  - **Payment**: `crypto` (for PayFast MD5 signatures), `webview_flutter` (for in-app payment flow)
  - **Dev Dependencies**: `flutter_test`, `flutter_lints ^3.0.0`
  - **Assets**: `assets/images/` (logo.png, logo_white.png, splash_bg.png), `assets/icons/` (location_pin.png, driver_icon.png, passenger_icon.png)
  - **Logo Usage**: Location pin icon replaces taxi icons for brand consistency, logo appears on splash screen and app bar
  - Note: `driver_app` uses similar dependencies; `admin_app` uses web-focused dependencies with `fl_chart` for analytics
- **Key integration points**:
  - **Firebase**: `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_messaging` (check `google-services.json`, `GoogleService-Info.plist`)
  - **Google Maps**: `google_maps_flutter`, `geolocator`, `geocoding`, `flutter_polyline_points` (requires API keys in platform manifests)
  - **State management**: Provider (see `lib/providers/`)
  - **HTTP clients**: `http` package for REST APIs (check `lib/services/`)
  - **Error handling**: `connectivity_plus` for network status monitoring (see `lib/services/error_handler.dart`)
  - **Real-time location**: `RealtimeLocationService` for driver location broadcasting and passenger tracking (see `lib/services/realtime_location_service.dart`)
  - **Push notifications**: `firebase_messaging`, `flutter_local_notifications` for FCM and local notification delivery (see `lib/services/notification_service.dart`), requires Firebase Cloud Functions deployment
  - **Driver matching**: `MatchingService` for intelligent driver-passenger matching with scoring algorithm (see `lib/services/matching_service.dart`)
  - **Payment processing**: PayFast payment gateway integration (see `lib/services/payment_service.dart`), requires merchant credentials and webhook configuration

## Project-specific conventions (Flutter/Dart)
- **Monorepo layout**: each app (`driver_app/`, `passenger_app/`, `admin_app/`) is a standalone Flutter project. Always `cd` into the app directory before running Flutter commands.
- **State management**: 
  - **`passenger_app/`** and **`driver_app/`** use Provider (`provider: ^6.1.1`) with three main providers in `lib/providers/`:
    - **`passenger_app/`**:
      - `AuthProvider` — handles authentication state (`currentUser`)
      - `RideProvider` — manages ride booking (`requestRide()`, `calculateFare()`, `estimatedFare`, `activeRide`, `isSearchingDriver`)
      - `LocationProvider` — tracks user location (`getCurrentLocation()`, `currentLocation`)
      - `RealtimeRideProvider` — real-time ride tracking with driver location updates (`startListeningToRide()`, `driverLatLng`, `distanceToDriver`, `etaToPickup`)
    - **`driver_app/`**:
      - `DriverAuthProvider` — manages driver authentication (`currentDriver: DriverModel`, `signIn()`, `signUp()`, `toggleAvailability()`, `isAvailable`)
      - `DriverRideProvider` — listens to pending rides via Firestore streams (`listenToPendingRides()`, `acceptRide()`, `updateRideStatus()`, `pendingRides`, `activeRide`, `rideHistory`)
      - `DriverLocationProvider` — continuous location tracking with `Geolocator.getPositionStream()` and Firebase updates (`startTracking()`, `stopTracking()`, `currentPosition`)
    - Providers are registered in `lib/main.dart` using `MultiProvider` and accessed via:
      - `Provider.of<T>(context, listen: false)` for one-time reads (e.g., in `initState`, event handlers)
      - `Provider.of<T>(context)` or `context.watch<T>()` for reactive updates in `build()`
  - **`admin_app/`** uses NO state management library — uses direct `StreamBuilder<QuerySnapshot>` with Firestore queries inline in widgets. Simpler architecture suitable for admin/dashboard use cases.
- **Routing**: Named routes defined in `lib/main.dart`: `/` (splash), `/login`, `/home`, `/booking`, `/active-ride`, `/history`, `/profile`. Navigate using `Navigator.pushNamed(context, '/route')` or `Navigator.pushReplacementNamed()` for flow transitions.
- **Theming & Brand Identity**: All three apps use "URBAN GLIDE - DRIVEN BY THE NEW GENERATION" branding with modern neon cyan aesthetic:
  - **Colors**: Primary cyan `#00D9FF`, secondary blue `#0080FF`, dark navy background `#0A1628`, surface `#1A2742`
  - **Visual style**: Neon glow effects (cyan shadows on containers), rounded corners, elevated shadows, gradient backgrounds
  - **Typography**: Uppercase headings with increased letter spacing for bold, modern look
  - **Icons**: Location pin icon (replaces taxi icons) for brand consistency
  - **UI components**: Cyan accent buttons, cards with elevated shadows, glowing circular containers
  - Configured via `MaterialApp.theme` with `ColorScheme.dark()` customization across all apps
- **Screens**: organized in `lib/screens/` or inline in `main.dart`
  - **`passenger_app/`**: `splash_screen.dart`, `login_screen.dart`, `home_screen.dart`, `ride_booking_screen.dart`, `active_ride_screen.dart` (legacy), `active_ride_screen_realtime.dart` (with live driver tracking), `ride_history_screen.dart`, `profile_screen.dart`
  - **`driver_app/`**: `DriverSplashScreen`, `DriverLoginScreen`, `DriverHomeScreen`, `ActiveRideScreen` (real-time ride list with Firestore streams)
  - **`admin_app/`**: All screens in `main.dart` — `AdminLoginScreen` (hardcoded auth: admin/admin123), `AdminDashboard` (drawer navigation), `DashboardHome`, `PassengersManagement`, `DriversManagement`, `RidesManagement`, `AnalyticsScreen`
  - Screens use `StatefulWidget` for local UI state (controllers, markers, loading states)
  - Access providers in `initState()` with `listen: false`, and in `build()` with default `listen: true` (passenger/driver apps only)
  - Conditional rendering based on provider state (e.g., `if (rideProvider.activeRide == null)` to show/hide buttons)
  - **Admin app UI patterns**: `Drawer` for navigation, `GridView` for stat cards, `StreamBuilder<QuerySnapshot>` for real-time data tables, `ExpansionTile` for expandable list items
  - `GoogleMap` widget (passenger app): manage via `GoogleMapController`, use `Set<Marker>` for map markers, set `myLocationEnabled: true` for user location
- **Models**: expect `lib/models/` with data classes:
  - **`passenger_app/`**: `LocationData` (latitude, longitude, address)
  - **`driver_app/`**: `DriverModel` (id, name, email, phone, vehicleModel, vehicleNumber, licenseNumber, rating, totalRides, earnings, isAvailable, isVerified) with `toJson()`/`fromJson()` for Firestore
- **Firebase setup**: `Firebase.initializeApp()` called in `main()` before `runApp()`. Apps using Firebase require `google-services.json` (Android) in `android/app/` and `GoogleService-Info.plist` (iOS) in `ios/Runner/`.
- **Google Maps API keys**: check `android/app/src/main/AndroidManifest.xml` for `com.google.android.geo.API_KEY` and `ios/Runner/AppDelegate.swift` or `Info.plist` for iOS keys.
- **Assets**: images/icons in `assets/images/` (logo.png, logo_white.png, splash_bg.png) and `assets/icons/` (location_pin.png, driver_icon.png, passenger_icon.png) declared in `pubspec.yaml` `flutter.assets`. Logo variants: full color for light backgrounds, white for dark backgrounds/app bars.
- **Platform-specific code**: permissions in `android/app/src/main/AndroidManifest.xml` (location, internet, etc.) and `ios/Runner/Info.plist` (NSLocationWhenInUseUsageDescription, etc.).

## Integration and cross-component signals to capture
- **CI workflows** (`.github/workflows/*.yml`) — record exact commands used for build/test/release (e.g., `flutter test`, `flutter build apk --release`).
- **Firebase**: All three apps use `firebase_core` and `cloud_firestore`. Check for Firebase initialization in `lib/main.dart`.
  - **`passenger_app/`**: `firebase_core ^2.24.2`, `firebase_auth ^4.15.3`, `cloud_firestore ^4.13.6`, `firebase_messaging ^14.7.9` for push notifications
  - **`driver_app/`**: Uses Firestore real-time listeners (`.snapshots()`) for pending ride updates and location tracking via `Geolocator.getPositionStream()`
  - **`admin_app/`**: Uses `StreamBuilder<QuerySnapshot>` for real-time dashboard updates, no authentication library (hardcoded login), includes `fl_chart` for analytics
- **Google Maps**: `passenger_app` uses `google_maps_flutter ^2.5.0`, `geolocator ^10.1.0`, `geocoding ^2.1.1`, `flutter_polyline_points ^2.0.1`. Requires API keys in `AndroidManifest.xml` and iOS config.
- **HTTP/REST**: `http ^1.1.0` package — look for API service classes in `lib/services/`.
- **Platform permissions**: Android needs `INTERNET`, `ACCESS_FINE_LOCATION`, `ACCESS_COARSE_LOCATION` in `AndroidManifest.xml`; iOS needs location usage descriptions in `Info.plist`.
- **Firestore collections**: 
  - `passengers` (passenger profiles: id, name, email, phone, rating, totalRides)
  - `drivers` (driver profiles with location: id, name, email, phone, vehicleModel, vehicleNumber, licenseNumber, rating, totalRides, earnings, isAvailable, isVerified, currentLocation, lastUpdated)
  - `rides` (status, passengerId, driverId, driverName, vehicleNumber, fare, pickupLocation, dropoffLocation, createdAt, acceptedAt, completedAt, driverRating, passengerRating)
  - `admins` (role-based access for admin panel)
  - `support` (user tickets: userId, category, message, status)
  - `notifications` (userId, read status)
  - `promoCodes` (read-only for clients)
  - `earnings` (read-only for drivers, calculated server-side)
  - `analytics` (no client access)
- **Firestore Security Rules**: Production-ready rules implemented with:
  - Role-based access control (passengers, drivers, admins)
  - Field-level validation (email format, phone format)
  - User can only modify their own data
  - Specific permissions per collection (passengers can create rides, drivers can accept rides, etc.)
  - Audit trail protection (rides cannot be deleted)
  - Read-only collections for sensitive data (earnings, analytics)
  - Helper functions: `isSignedIn()`, `isOwner(userId)`, `isValidEmail()`, `isValidPhone()`
- **Error Handling System**: Comprehensive service layer in `lib/services/error_handler.dart`:
  - **Custom Exceptions**: `NetworkException`, `AuthException`, `LocationException`, `RideException`, `PaymentException` — typed errors for specific failure modes
  - **ErrorHandler Service**: Singleton with `logError()` (debug + Crashlytics prep), `getErrorMessage()` (user-friendly messages), `showErrorDialog()`/`showErrorSnackbar()` (UI feedback)
  - **RetryHandler**: Exponential backoff retry logic (`retry<T>()` with configurable maxAttempts, delay, shouldRetry predicate) for transient failures
  - **ConnectivityService**: Real-time network status via `connectivity_plus` package (`isConnected()`, `connectivityStream`)
  - **FirebaseServiceWrapper**: Centralized Firebase operation wrapper with timeout (30s), connectivity check, and exception translation (FirebaseAuthException → AuthException, FirebaseException → RideException)
  - **Provider Integration**: Updated `AuthProviderWithErrorHandling`, `LocationProviderWithErrorHandling` with `_isLoading`/`_errorMessage` state, input validation (phone regex, password length), and user-facing error display
  - **UI Component**: `AsyncButton` widget with built-in loading state and error handling for form submissions
  - **Usage Pattern**: Wrap Firestore/Auth calls in `FirebaseServiceWrapper.executeFirestoreOperation()`, use `RetryHandler.retry()` for flaky operations (location, HTTP), check `ConnectivityService().isConnected()` before network calls
- **Real-Time Location Tracking**: Complete implementation in `lib/services/realtime_location_service.dart` and `lib/providers/realtime_ride_provider.dart`:
  - **RealtimeLocationService**: Singleton for managing driver location broadcasts and passenger tracking
    - `startLocationBroadcast(driverId)` — Driver starts broadcasting location via `Geolocator.getPositionStream()` with 10m distance filter and 5s time limit
    - `stopLocationBroadcast()` — Stops location updates and cleans up subscriptions
    - `listenToDriverLocation(driverId)` — Returns Firestore stream of driver location (latitude, longitude, accuracy, heading, speed, lastUpdate)
    - `calculateDistance()` — Haversine formula via `Geolocator.distanceBetween()`
    - `calculateETA()` — Estimates arrival time based on distance and current speed (defaults to 30 km/h if stationary)
    - Backup timer updates every 10s for stationary drivers
    - Duplicate position filtering to avoid unnecessary Firestore writes
  - **RealtimeRideProvider**: Provider for passenger-side real-time ride tracking
    - `startListeningToRide(rideId, pickupLocation)` — Listens to ride status changes via Firestore `.snapshots()`
    - Automatically starts driver location tracking when driver is assigned
    - Exposes `driverLatLng`, `distanceToDriver`, `etaToPickup` for UI binding
    - `stopListening()` — Cleanup method to cancel all subscriptions
  - **ActiveRideScreenRealtime**: UI with live map updates
    - Google Maps with real-time driver marker (updates position, rotation based on heading)
    - Pickup marker with green color, driver marker with azure color
    - Status card showing driver info, distance, and ETA
    - Auto-fit camera to show both driver and pickup locations
    - Live distance/ETA updates as driver moves
    - Cancel ride button for searching/accepted status
- **Push Notification System**: Complete FCM implementation in `lib/services/notification_service.dart` with Firebase Cloud Functions backend:
  - **NotificationService**: Singleton managing FCM tokens and local notifications
    - `initialize()` — Requests permissions, initializes local notifications, obtains FCM token, sets up foreground/background message handlers
    - `saveFCMToken(userId, userType)` / `removeFCMToken()` — Manages token lifecycle in Firestore (save on login, remove on logout)
    - `showNotification(message)` — Displays local notification with platform-specific styling (Android channels: ride_requests, ride_updates)
    - `subscribeToTopic()` / `unsubscribeFromTopic()` — Topic-based notifications
    - Background message handler (`firebaseMessagingBackgroundHandler`) for notification delivery when app is closed
    - Notification channels: "Ride Requests" (high priority, sound, vibration), "Ride Updates" (high priority)
  - **Firebase Cloud Functions** (Node.js, deploy to Firebase): Located in provided code comments
    - `onRideCreated` — Triggers when new ride document created, queries available verified drivers within 5km radius using Haversine distance calculation, sends "New Ride Request" notifications with pickup address and fare
    - `onRideAccepted` — Triggers on ride status change (searching → accepted), notifies passenger with driver name and vehicle number
    - `onDriverArrived` — Triggers on status change (accepted → pickup), sends "Driver Has Arrived" notification to passenger
    - `onRideCompleted` — Triggers on status change (in_progress → completed), notifies both passenger (with fare, rating prompt) and driver (with earnings)
    - Helper: `calculateDistance()` — Haversine formula for proximity-based driver filtering (5km = 5000m threshold)
  - **AuthProviderWithNotifications**: Extends `AuthProviderWithErrorHandling`, integrates token management into auth flow (signIn saves token, signOut removes token)
  - **Initialization**: Call `await NotificationService().initialize()` and `FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler)` in `main()` before `runApp()`
  - **Platform Setup**: Requires notification permissions in AndroidManifest.xml / Info.plist, Firebase project with Cloud Messaging enabled
- **Driver-Passenger Matching System**: Intelligent matching in `lib/services/matching_service.dart`:
  - **MatchingService**: Singleton for proximity-based driver discovery and assignment
    - `findNearbyDrivers(rideId, pickupLocation, fareAmount)` — Queries available/verified drivers, calculates distance via Haversine formula, filters within 5km radius, scores drivers using multi-factor algorithm, returns sorted list of top 10 matches
    - `autoAssignRide(rideId, pickupLocation, fareAmount)` — Attempts automatic assignment to best-scored driver with fallback to next-best if assignment fails
    - `assignDriverManually(rideId, driverId)` — Handles driver acceptance from notifications with Firestore transaction for atomicity (prevents double-assignment)
    - `releaseDriver(driverId)` — Returns driver to available pool after ride completion/cancellation
    - `analyzeDemand(location, radius)` — Supply/demand analysis for surge pricing (calculates active rides vs. available drivers, returns surge multiplier: 1.0-2.0x)
    - Configuration: 5km max search radius, 10 max drivers notified, 30s response timeout, 3 max retries
  - **Driver Scoring Algorithm** (0-100 points):
    - Distance score (0-40 pts): Closer drivers ranked higher (5km = 0 pts, 0km = 40 pts)
    - Rating score (0-30 pts): Based on driver rating (5.0 = 30 pts)
    - Experience score (0-20 pts): Total rides completed (100+ rides = 20 pts)
    - Acceptance rate score (0-10 pts): Historical acceptance rate (80%+ = 8+ pts)
  - **DriverMatch Model**: Result object with driverId, name, vehicle info, rating, distance, ETA, score, FCM token
  - **RideProviderWithMatching**: Enhanced ride provider with matching integration
    - `calculateFareWithSurge(distance, pickupLocation)` — Fare calculation with dynamic surge multiplier based on demand analysis
    - `requestRideWithMatching(passengerId, pickup, dropoff, useAutoAssign)` — Creates ride, finds nearby drivers, auto-assigns or notifies drivers
    - `cancelRide(rideId)` — Cancels ride and releases assigned driver
    - Exposes `nearbyDrivers`, `surgeMultiplier` for UI display
  - **Transaction Safety**: Uses Firestore transactions for driver assignment to prevent race conditions (two passengers cannot book same driver)
- **Payment Integration System**: PayFast gateway implementation in `lib/services/payment_service.dart`:
  - **PaymentService**: Singleton managing PayFast payment flow
    - `initiatePayment(rideId, amount, passengerId)` — Creates payment request with secure signature (MD5 hash), generates PayFast payment URL, opens in WebView or browser
    - `generateSignature(data)` — MD5 signature generation for PayFast API security (uses merchant ID, merchant key, return URL, cancel URL, notify URL)
    - `verifyPaymentCallback(params)` — Validates ITN (Instant Transaction Notification) webhook callbacks with signature verification
    - `handlePaymentSuccess(rideId)` — Updates ride status to 'paid', records transaction in Firestore, triggers receipt generation
    - `handlePaymentFailure(rideId, reason)` — Logs failed payments, notifies user, updates ride status
    - Configuration: Sandbox mode (sandbox.payfast.co.za) for testing, production mode (www.payfast.co.za) for live transactions
  - **PayFast Features**: Card payments (Visa, Mastercard), instant EFT, SnapScan, Zapper, Mobicred, other South African payment methods
  - **Security**: MD5 signature verification, ITN callback validation, amount verification, merchant ID validation
  - **Webhook Setup**: Configure `notify_url` in PayFast merchant dashboard to point to Firebase Cloud Function or backend endpoint for ITN handling
  - **Environment Variables**: Store merchant credentials securely (merchant_id, merchant_key, passphrase) — never commit to repository
  - **Testing**: Sandbox credentials available from PayFast developer portal, test card numbers provided for development
  - **Dependencies**: `crypto` package for MD5 hashing, `url_launcher` for browser/WebView integration, `webview_flutter` for in-app payment flow

## VS Code Development Workflow

**Task Management**: This workspace has 12 predefined VS Code tasks in `.vscode/tasks.json` for common operations:
- **Run tasks**: Passenger App, Driver App, Admin App (Chrome)
- **Build tasks**: APK builds for Passenger/Driver apps
- **Maintenance tasks**: Clean All, Get Dependencies (All Apps), Run Tests
- **Firebase tasks**: Deploy Functions, Deploy Firestore Rules, Emulate Functions

**Access tasks via**: 
- Command Palette: `Ctrl+Shift+P` → "Tasks: Run Task"
- Terminal menu: "Terminal → Run Task"
- Keyboard shortcut: `Ctrl+Shift+B` (default build task)

**PowerShell Environment**: This workspace uses PowerShell as the default shell. Multi-app commands use `;` separator:
```powershell
cd passenger_app; flutter pub get; cd ../driver_app; flutter pub get
```

## Firebase Cloud Functions Deployment

**Functions Location**: `firebase/functions/index.js` contains 4 notification triggers:
- `onRideCreated` — Notifies nearby drivers (5km radius) when passenger requests ride
- `onRideAccepted` — Notifies passenger when driver accepts
- `onDriverArrived` — Notifies passenger when driver reaches pickup location
- `onRideCompleted` — Notifies both parties with ride completion details

**Deploy Command** (from workspace root):
```powershell
cd firebase/functions
npm install
firebase deploy --only functions
```

**VS Code Task**: Use `firebase: Deploy Functions` task from task menu.

**Requirements**: 
- Firebase CLI installed: `npm install -g firebase-tools`
- Logged in: `firebase login`
- Project configured: `firebase use urban-glide-transport-25`
- Node.js 20+ (specified in `functions/package.json`)

## ⚠️ Common Pitfalls & Solutions

### Provider Access Errors
**Problem:** `Tried to listen to a value exposed with provider, outside of the widget tree`
**Solution:** Ensure `MultiProvider` wraps `MaterialApp` in `main.dart`. Never access providers in `main()` before `runApp()`.

**Problem:** Widget rebuilding infinitely
**Solution:** Use `listen: false` in `initState()`, event handlers, and async callbacks. Only use `context.watch<T>()` in `build()`.

### Firebase/Firestore Issues
**Problem:** `google-services.json not found` or Firebase initialization fails
**Solution:** Verify config files exist (not `.PLACEHOLDER` versions) in `android/app/` and `ios/Runner/`. Re-download from Firebase Console if needed.

**Problem:** Firestore permission denied errors
**Solution:** Check `firebase/firestore.rules`. Ensure user is authenticated (`request.auth != null`) and rules match your collection access pattern.

**Problem:** Cloud Functions not triggering
**Solution:** 
1. Verify function deployed: `firebase functions:list`
2. Check function logs: `firebase functions:log`
3. Ensure Firestore trigger path matches: `collection/{docId}` syntax

### Location Tracking Issues
**Problem:** Driver location not updating in Firestore
**Solution:** 
1. Check location permissions: Android requires `ACCESS_FINE_LOCATION` + runtime permission request
2. Verify `DriverLocationProvider.startTracking()` called when driver goes online
3. Check `Geolocator.getPositionStream()` settings: `distanceFilter: 10` meters, `timeLimit: Duration(seconds: 5)`

**Problem:** Passenger not seeing real-time driver location
**Solution:**
1. Confirm `RealtimeRideProvider.startListeningToRide()` called in `ActiveRideScreenRealtime.initState()`
2. Check Firestore stream subscription: `drivers/{driverId}/currentLocation` path correct
3. Verify driver's `currentLocation` field updated in Firestore (check with Firebase Console)

### Google Maps Issues
**Problem:** Map not loading or showing "For development purposes only" watermark
**Solution:** 
1. Verify API keys in `AndroidManifest.xml` (Android) and `AppDelegate.swift` (iOS)
2. Enable required APIs in Google Cloud Console: Maps SDK for Android/iOS, Geocoding API, Directions API
3. Check API key restrictions (bundle ID for iOS, package name for Android)

### Payment Integration Issues
**Problem:** PayFast payment page returns "Invalid signature"
**Solution:**
1. Verify merchant credentials (ID, key, passphrase) match Firebase Functions configuration
2. Check signature generation order: fields must be alphabetically sorted before MD5 hash
3. Use sandbox credentials for testing: `merchant_id: 10000100`, `merchant_key: 46f0cd694581a`

**Problem:** Payment callback (ITN) not received
**Solution:**
1. Configure `notify_url` in PayFast dashboard to point to deployed Cloud Function
2. Verify Cloud Function has public HTTPS endpoint (not localhost)
3. Check Firebase Functions logs for incoming webhook requests

## Examples of concrete, repository-specific checks (copy these into your run log)
- "Found `passenger_app/pubspec.yaml` with SDK `>=3.0.0 <4.0.0` and Provider ^6.1.1; use `cd passenger_app && flutter pub get` then `flutter test`."
- "Found `.vscode/tasks.json` with 12 predefined tasks including `flutter: Run Passenger App` with `--no-sound-null-safety` flag."
- "Found `firebase/functions/index.js` with 4 Cloud Functions for push notifications (onRideCreated, onRideAccepted, onDriverArrived, onRideCompleted)."
- "Found `passenger_app/lib/main.dart` with `MultiProvider` setup: `AuthProvider`, `RideProvider`, `LocationProvider`. Add new providers here when creating shared state."
- "Found `driver_app/lib/main.dart` with `MultiProvider` setup: `DriverAuthProvider`, `DriverRideProvider`, `DriverLocationProvider`. Uses Firestore streams for real-time ride updates."
- "Found `admin_app/lib/main.dart` with NO Provider — uses direct `StreamBuilder<QuerySnapshot>` for Firestore data. All screens inline in main.dart. Hardcoded auth: admin/admin123."
- "Found `firebase/firestore.rules` with production-ready security rules: role-based access, field validation, audit trail protection (rides cannot be deleted)."
- "Found `passenger_app/lib/main.dart` entry point with Firebase initialization (`Firebase.initializeApp()`) and named routes. Requires `google-services.json` and API keys before `flutter run`."
- "Screens follow pattern: `lib/screens/<screen_name>_screen.dart`. Routes use named navigation: `Navigator.pushNamed(context, '/route')`."
- "`driver_app/` uses `DriverModel` with `toJson()`/`fromJson()` for Firestore serialization. Check `lib/models/` for data model patterns."
- "`DriverRideProvider.listenToPendingRides()` uses Firestore `.snapshots()` for real-time updates. Called in `initState()` of `DriverHomeScreen`."
- "`admin_app/` queries Firestore collections: `passengers`, `drivers`, `rides`. Uses `StreamBuilder` with `.where()`, `.orderBy()`, `.limit()` for filtering."
- "Monorepo layout: `driver_app/`, `passenger_app/`, and `admin_app/` are separate apps. Always `cd` into the target app directory. Never run Flutter commands from workspace root."
- "For complete setup from scratch, refer to `docs/vscode_setup_guide.md` — 15-step guide covering Flutter SDK installation, VS Code configuration, Firebase setup, Google Maps API keys, and platform-specific permissions."

## Setup Requirements

**Firebase Project Configuration:**
- **Project Name**: Urban Glide
- **Project ID**: `urban-glide-transport-25`
- **Project Number**: `572805775337`
- **Environment**: Production
- **Support Email**: urbanglidebfn@gmail.com

**Before running the apps, configure:**
1. **Firebase Project**: Connect to existing Firebase project `urban-glide-transport-25` at console.firebase.google.com and add three apps (Android/iOS for passenger_app, driver_app; Web for admin_app)
2. **Firebase Config Files**: 
   - Android: Download `google-services.json` and place in `<app>/android/app/` (replace `.PLACEHOLDER` files)
   - iOS: Download `GoogleService-Info.plist` and place in `<app>/ios/Runner/` (replace `.PLACEHOLDER` files)
   - **Note**: Placeholder files exist in repository to prevent Firebase configuration errors; actual config files are gitignored
3. **Firebase Cloud Functions**: Deploy notification triggers from `firebase/functions/index.js`:
   - Install Firebase CLI: `npm install -g firebase-tools`
   - Login: `firebase login`
   - Select project: `firebase use urban-glide-transport-25`
   - Install dependencies: `cd firebase/functions && npm install`
   - Deploy: `firebase deploy --only functions` (or use VS Code task)
   - Required functions: `onRideCreated`, `onRideAccepted`, `onDriverArrived`, `onRideCompleted`
4. **Firestore Security Rules**: Deploy production-ready rules from `firebase/firestore.rules`:
   - Deploy: `firebase deploy --only firestore:rules` (or use VS Code task)
   - Rules include: role-based access control, field validation, audit trail protection
5. **Google Maps API Keys**: Obtain keys from Google Cloud Console (project: `urban-glide-transport-25`) and configure:
   - Android: Search for `YOUR_GOOGLE_MAPS_API_KEY_HERE` in `<app>/android/app/src/main/AndroidManifest.xml` and replace with actual key
   - iOS: Search for `YOUR_GOOGLE_MAPS_API_KEY_HERE` in `<app>/ios/Runner/AppDelegate.swift` and replace with actual key
   - Enable APIs: Maps SDK for Android/iOS, Geocoding API, Directions API, Places API
6. **Firestore Database**: Collections created automatically on first use (`passengers`, `drivers`, `rides`, `support`, `notifications`)
7. **Platform Permissions**: Already configured in manifests — location (FINE/COARSE), internet, notification (POST_NOTIFICATIONS for Android 13+)

**Quick Setup References**:
- `QUICK_SETUP.md` — 4-step manual configuration checklist (~90 min)
- `FIREBASE_SETUP.md` — Detailed Firebase console instructions
- `docs/vscode_setup_guide.md` — Complete 15-step setup from scratch (3-4 hours)
- `RUN_APPS.md` — Troubleshooting guide for common runtime issues

**Deployment Readiness:**
- Code is production-ready and follows Flutter best practices
- All three apps are configured for cross-platform deployment (Android, iOS, Web)
- Firebase backend provides scalable real-time infrastructure
- Location tracking uses efficient streams with configurable distance filters

**Setup Guide:**
- Complete VS Code setup instructions available in `docs/vscode_setup_guide.md`
- 15-step walkthrough covering prerequisites, Firebase setup, Google Maps configuration, and deployment
- Includes troubleshooting guide, quick start checklist, and useful commands reference
- Estimated setup time: 3-4 hours for complete environment configuration

## Merge guidance (if `.github/copilot-instructions.md` already exists)
- Preserve any existing bullet points that reference specific files/commands. Only replace generic/obsolete commands after confirming with `pubspec.yaml`, `README.md`, or CI workflows.
- Add a short 'last-checked' line with the file list you used to derive changes.

## When you can't find intended behavior
- If `pubspec.yaml` or `lib/main.dart` is missing in an app directory, report: "App directory `<name>` is missing required Flutter files; propose: run `flutter create <name>` or verify app structure."

## Safety and PR style
- Make minimal, localizable changes: docs, small refactors, or tests. Leave large refactors until a human confirms.
- Each PR should include a 1–2 line description: what changed, why, and one command to validate locally.

## Questions to ask the user (include in PR description if unclear)
- Which app should I focus on (driver_app, passenger_app, or admin_app)?
- Are there specific platform targets (Android, iOS, web) for this project?
- Is there a backend API or Firebase project connected to these apps?

---
**Last updated**: November 12, 2025 (Enhanced with detailed development workflows, common pitfalls guide, real-time data flow patterns, and Provider best practices. Added debugging procedures for location tracking, Firebase integration, and payment processing.)

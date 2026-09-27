# Firebase Testing Guide for Urban Glide 🔥

**Date:** November 10, 2025  
**Project:** Urban Glide E-Hailing Platform  
**Firebase Project:** urban-glide-transport-25

---

## 🎯 Firebase Testing Overview

This guide helps you test all Firebase components of Urban Glide:
- Firebase Authentication
- Cloud Firestore (database and security rules)
- Firebase Cloud Messaging (push notifications)
- Cloud Functions
- Firebase Configuration

---

## ⚠️ Current Status

**Configuration Files:**
- ❌ `google-services.json` - NOT configured (PLACEHOLDER files only)
- ❌ `GoogleService-Info.plist` - NOT configured (PLACEHOLDER files only)
- ✅ `firestore.rules` - Production-ready security rules exist
- ✅ `firebase.json` - Firebase project configuration exists
- ✅ Cloud Functions code - Ready in `firebase/functions/`

**To test Firebase, you must first add real configuration files!**

---

## 📋 Pre-Testing Setup Checklist

### Step 1: Download Firebase Config Files

1. **Go to Firebase Console:**
   - URL: https://console.firebase.google.com/project/urban-glide-transport-25

2. **For Android (both passenger_app and driver_app):**
   - Project Settings → Your apps → Android app
   - Click "Download google-services.json"
   - Copy to:
     - `passenger_app/android/app/google-services.json`
     - `driver_app/android/app/google-services.json`

3. **For iOS (both passenger_app and driver_app):**
   - Project Settings → Your apps → iOS app
   - Click "Download GoogleService-Info.plist"
   - Copy to:
     - `passenger_app/ios/Runner/GoogleService-Info.plist`
     - `driver_app/ios/Runner/GoogleService-Info.plist`

4. **Remove placeholder files:**
   ```powershell
   Remove-Item *\**\google-services.json.PLACEHOLDER
   Remove-Item *\**\GoogleService-Info.plist.PLACEHOLDER
   ```

### Step 2: Install Firebase CLI

```powershell
# Install Firebase CLI globally
npm install -g firebase-tools

# Login to Firebase
firebase login

# Verify installation
firebase --version
```

### Step 3: Initialize Firebase Project

```powershell
cd C:\src\Claude\firebase

# Set active project
firebase use urban-glide-transport-25

# Verify connection
firebase projects:list
```

---

## 🧪 Firebase Testing Methods

### Method 1: Firestore Rules Testing (Emulator)

**Install Java 11+ (required for emulators):**
```powershell
# Check if Java is installed
java -version

# If not, download from: https://adoptium.net/
```

**Start Firestore Emulator:**
```powershell
cd C:\src\Claude\firebase

# Install emulators (first time only)
firebase setup:emulators:firestore

# Start Firestore emulator
firebase emulators:start --only firestore

# Emulator will run at: http://localhost:8080
```

**Run Rules Tests:**
```powershell
# Create test file first (see test examples below)
firebase emulators:exec "npm test" --only firestore
```

---

### Method 2: Deploy and Test on Production

**Deploy Firestore Rules:**
```powershell
cd C:\src\Claude\firebase

# Deploy only rules (safe, no data changes)
firebase deploy --only firestore:rules

# View deployment
firebase firestore:indexes
```

**Deploy Cloud Functions:**
```powershell
cd C:\src\Claude\firebase\functions

# Install dependencies
npm install

# Deploy all functions
cd ..
firebase deploy --only functions

# Deploy specific function
firebase deploy --only functions:onRideCreated
```

---

### Method 3: Test from Flutter App

**Run App with Firebase:**
```powershell
# After adding google-services.json
cd C:\src\Claude\passenger_app

# Run on Chrome (web testing)
flutter run -d chrome

# Or Android emulator
flutter run
```

**Test Authentication:**
1. Open app
2. Go to Register/Login screen
3. Try creating account
4. Check Firebase Console → Authentication → Users

**Test Firestore:**
1. Create a ride in passenger app
2. Check Firebase Console → Firestore Database → rides collection
3. Verify data is saved correctly

**Test Cloud Messaging:**
1. Driver accepts ride
2. Passenger should receive notification
3. Check Firebase Console → Cloud Messaging

---

## 📝 Firestore Rules Unit Tests

Create `firebase/firestore.test.js`:

```javascript
const firebase = require('@firebase/rules-unit-testing');
const fs = require('fs');

const PROJECT_ID = 'urban-glide-transport-25';
const RULES = fs.readFileSync('./firestore.rules', 'utf8');

describe('Firestore Security Rules', () => {
  let testEnv;

  beforeAll(async () => {
    testEnv = await firebase.initializeTestEnvironment({
      projectId: PROJECT_ID,
      firestore: {
        rules: RULES,
        host: 'localhost',
        port: 8080,
      },
    });
  });

  afterAll(async () => {
    await testEnv.cleanup();
  });

  afterEach(async () => {
    await testEnv.clearFirestore();
  });

  describe('Passengers Collection', () => {
    test('allows passenger to read their own data', async () => {
      const context = testEnv.authenticatedContext('user1');
      const passenger = context.firestore().collection('passengers').doc('user1');
      
      await firebase.assertSucceeds(passenger.get());
    });

    test('denies passenger from reading other user data', async () => {
      const context = testEnv.authenticatedContext('user1');
      const passenger = context.firestore().collection('passengers').doc('user2');
      
      await firebase.assertFails(passenger.get());
    });

    test('allows passenger to create their own profile', async () => {
      const context = testEnv.authenticatedContext('user1');
      const passenger = context.firestore().collection('passengers').doc('user1');
      
      await firebase.assertSucceeds(passenger.set({
        id: 'user1',
        email: 'test@example.com',
        name: 'Test User',
        phone: '+27123456789',
        rating: 5.0,
        totalRides: 0
      }));
    });

    test('denies passenger creation with invalid email', async () => {
      const context = testEnv.authenticatedContext('user1');
      const passenger = context.firestore().collection('passengers').doc('user1');
      
      await firebase.assertFails(passenger.set({
        id: 'user1',
        email: 'invalid-email',
        name: 'Test User',
        phone: '+27123456789'
      }));
    });
  });

  describe('Rides Collection', () => {
    test('allows passenger to create ride', async () => {
      const context = testEnv.authenticatedContext('user1');
      const ride = context.firestore().collection('rides').doc();
      
      await firebase.assertSucceeds(ride.set({
        passengerId: 'user1',
        status: 'searching',
        pickupLocation: { latitude: -26.2041, longitude: 28.0473 },
        dropoffLocation: { latitude: -26.1076, longitude: 27.9892 },
        fare: 50.0,
        createdAt: new Date()
      }));
    });

    test('denies passenger from accepting ride', async () => {
      const context = testEnv.authenticatedContext('user1');
      const ride = context.firestore().collection('rides').doc('ride1');
      
      await firebase.assertFails(ride.update({
        status: 'accepted',
        driverId: 'driver1'
      }));
    });
  });

  describe('Drivers Collection', () => {
    test('allows any authenticated user to read driver data', async () => {
      const context = testEnv.authenticatedContext('user1');
      const driver = context.firestore().collection('drivers').doc('driver1');
      
      await firebase.assertSucceeds(driver.get());
    });

    test('allows driver to update their location', async () => {
      const context = testEnv.authenticatedContext('driver1');
      const driver = context.firestore().collection('drivers').doc('driver1');
      
      await firebase.assertSucceeds(driver.update({
        currentLocation: {
          latitude: -26.2041,
          longitude: 28.0473
        },
        lastUpdated: new Date()
      }));
    });
  });
});
```

**Run Tests:**
```powershell
cd C:\src\Claude\firebase

# Start emulator in one terminal
firebase emulators:start --only firestore

# In another terminal, run tests
npm test
```

---

## 🔍 Manual Firebase Testing Checklist

### ✅ Authentication Testing

**Test Cases:**
1. **User Registration:**
   ```
   - Open passenger app
   - Navigate to Register screen
   - Enter: name, email, password, phone
   - Click Register
   - ✅ Check: User created in Firebase Console → Authentication
   ```

2. **User Login:**
   ```
   - Open passenger app
   - Enter email and password
   - Click Login
   - ✅ Check: User logged in, redirected to home screen
   ```

3. **Driver Registration:**
   ```
   - Open driver app
   - Fill in: name, email, password, phone, vehicle details
   - Click Register
   - ✅ Check: Driver created with vehicle info in Firestore
   ```

**Verify in Firebase Console:**
- Go to: Authentication → Users
- Should see registered users

---

### ✅ Firestore Testing

**Test Cases:**
1. **Create Ride (Passenger):**
   ```
   - Login as passenger
   - Select pickup and dropoff on map
   - Request ride
   - ✅ Check: Ride document created in Firestore → rides collection
   - ✅ Verify: status = 'searching', passengerId, fare, locations
   ```

2. **Accept Ride (Driver):**
   ```
   - Login as driver
   - Toggle availability ON
   - Wait for ride request notification
   - Accept ride
   - ✅ Check: Ride updated with driverId, status = 'accepted'
   ```

3. **Real-time Location Updates:**
   ```
   - Driver starts ride
   - Move around (or simulate location)
   - ✅ Check: Driver location updated in Firestore
   - ✅ Check: Passenger sees driver moving on map
   ```

**Verify in Firebase Console:**
- Go to: Firestore Database
- Check collections: passengers, drivers, rides
- Verify document structure and data

---

### ✅ Cloud Messaging Testing

**Test Cases:**
1. **New Ride Notification (Driver):**
   ```
   - Passenger requests ride
   - ✅ Driver receives push notification
   - ✅ Notification shows: pickup address, fare
   ```

2. **Ride Accepted Notification (Passenger):**
   ```
   - Driver accepts ride
   - ✅ Passenger receives notification
   - ✅ Shows: driver name, vehicle number
   ```

3. **Driver Arrived Notification:**
   ```
   - Driver reaches pickup location
   - ✅ Passenger receives notification
   ```

**Verify in Firebase Console:**
- Go to: Cloud Messaging → Analytics
- Check: Message delivery rates
- View: Recent messages sent

---

### ✅ Cloud Functions Testing

**Deployed Functions:**
1. `onRideCreated` - Notifies nearby drivers
2. `onRideAccepted` - Notifies passenger
3. `onDriverArrived` - Notifies passenger
4. `onRideCompleted` - Notifies both users

**Test:**
```powershell
# View function logs
firebase functions:log

# Test specific function
firebase functions:shell

# In shell:
> onRideCreated({data: {/* ride data */}})
```

**Verify:**
- Check function execution in Firebase Console → Functions
- View logs for errors
- Check notification delivery

---

## 🛠️ Firebase CLI Commands

```powershell
# Project Management
firebase projects:list                    # List all projects
firebase use urban-glide-transport-25     # Set active project
firebase projects:describe                # Show project details

# Firestore
firebase firestore:delete --all-collections    # Clear all data (DANGER!)
firebase firestore:indexes                     # List indexes

# Functions
firebase functions:list                   # List all functions
firebase functions:log                    # View function logs
firebase functions:delete functionName    # Delete function

# Deploy
firebase deploy --only firestore:rules    # Deploy rules only
firebase deploy --only functions          # Deploy functions only
firebase deploy                           # Deploy everything

# Emulators
firebase emulators:start                  # Start all emulators
firebase emulators:start --only firestore # Firestore only
firebase emulators:export ./data          # Export emulator data
firebase emulators:import ./data          # Import emulator data
```

---

## 📊 Firebase Testing Results Template

```
Firebase Testing Report
Date: ___________
Tester: __________

Authentication:
☐ User Registration - PASS/FAIL
☐ User Login - PASS/FAIL
☐ Password Reset - PASS/FAIL

Firestore:
☐ Create Documents - PASS/FAIL
☐ Read Documents - PASS/FAIL
☐ Update Documents - PASS/FAIL
☐ Security Rules - PASS/FAIL
☐ Real-time Updates - PASS/FAIL

Cloud Messaging:
☐ Receive Notifications - PASS/FAIL
☐ Notification Actions - PASS/FAIL

Cloud Functions:
☐ onRideCreated - PASS/FAIL
☐ onRideAccepted - PASS/FAIL
☐ onDriverArrived - PASS/FAIL
☐ onRideCompleted - PASS/FAIL

Performance:
☐ Load Time < 3s - PASS/FAIL
☐ Real-time Sync < 1s - PASS/FAIL

Issues Found:
1. __________________
2. __________________
```

---

## 🚨 Common Issues & Solutions

### Issue 1: "Default Firebase app not initialized"
**Solution:**
- Ensure `google-services.json` is in `android/app/`
- Ensure `GoogleService-Info.plist` is in `ios/Runner/`
- Rebuild app: `flutter clean && flutter pub get && flutter run`

### Issue 2: Firestore permission denied
**Solution:**
- Check security rules in Firebase Console
- Verify user is authenticated
- Deploy latest rules: `firebase deploy --only firestore:rules`

### Issue 3: Cloud Functions not triggering
**Solution:**
- Check function logs: `firebase functions:log`
- Verify function is deployed: `firebase functions:list`
- Check triggers in Firebase Console

### Issue 4: Notifications not received
**Solution:**
- Verify FCM token is saved in Firestore
- Check Cloud Messaging settings in Firebase Console
- Test on physical device (emulator has limitations)

---

## ✅ Quick Test Commands

```powershell
# Quick Firebase connectivity test
cd C:\src\Claude\firebase
firebase projects:list

# Deploy rules
firebase deploy --only firestore:rules

# View real-time logs
firebase functions:log --follow

# Start local testing
firebase emulators:start

# Run app with Firebase
cd C:\src\Claude\passenger_app
flutter run -d chrome
```

---

## 📞 Resources

**Firebase Console:**
- Project: https://console.firebase.google.com/project/urban-glide-transport-25
- Authentication: https://console.firebase.google.com/project/urban-glide-transport-25/authentication
- Firestore: https://console.firebase.google.com/project/urban-glide-transport-25/firestore
- Functions: https://console.firebase.google.com/project/urban-glide-transport-25/functions
- Cloud Messaging: https://console.firebase.google.com/project/urban-glide-transport-25/notification

**Documentation:**
- Firebase Docs: https://firebase.google.com/docs
- Firestore Rules: https://firebase.google.com/docs/firestore/security/get-started
- Cloud Functions: https://firebase.google.com/docs/functions
- Cloud Messaging: https://firebase.google.com/docs/cloud-messaging

---

**Status:** ⚠️ **FIREBASE NOT CONFIGURED**  
**Next Step:** Download and add firebase config files, then run tests  
**Documentation:** See FIREBASE_SETUP.md for detailed configuration

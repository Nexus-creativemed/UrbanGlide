# Firebase Deployment Execution Log
# Urban Glide Project
# Date: December 1, 2025
# Project ID: urban-glide-transport-25

## Deployment Steps

### Step 1: Verify Firebase CLI and Project Selection
```powershell
# Commands to execute:
firebase --version
firebase projects:list
firebase use urban-glide-transport-25
firebase status
```

**What this does:**
- Checks Firebase CLI installation
- Lists available Firebase projects
- Selects the correct project (urban-glide-transport-25)
- Displays current Firebase project status

---

### Step 2: Install Cloud Functions Dependencies
```powershell
cd firebase\functions
npm install
cd ..\..
```

**What this does:**
- Installs all dependencies from package.json:
  - firebase-admin ^12.7.0
  - firebase-functions ^5.1.0
  - eslint (dev dependency)

**Expected output:**
```
added XX packages
up to date
```

---

### Step 3: Deploy Cloud Functions
```powershell
cd firebase
firebase deploy --only functions
```

**What this deploys:**
1. **onRideCreated** - Triggered when new ride document created
   - Searches for available drivers within 5km radius
   - Uses Haversine formula for distance calculation
   - Sends FCM notifications to matching drivers
   
2. **onRideAccepted** - Triggered when ride status changes to "accepted"
   - Sends notification to passenger with driver name and vehicle details
   
3. **onDriverArrived** - Triggered when ride status changes to "pickup"
   - Sends notification to passenger that driver has arrived
   
4. **onRideCompleted** - Triggered when ride status changes to "completed"
   - Notifies passenger with ride fare and rating prompt
   - Notifies driver with earnings amount
   - Updates driver earnings record

**Expected output:**
```
✓ functions[onRideCreated(us-central1)]: Successful create operation.
✓ functions[onRideAccepted(us-central1)]: Successful create operation.
✓ functions[onDriverArrived(us-central1)]: Successful create operation.
✓ functions[onRideCompleted(us-central1)]: Successful create operation.

Functions deployed successfully!
```

---

### Step 4: Verify Cloud Functions Deployment
```powershell
firebase functions:list
firebase functions:log --limit 20
```

**What this does:**
- Lists all deployed functions with status
- Shows recent function execution logs

**Expected output:**
```
onRideCreated(us-central1)         READY
onRideAccepted(us-central1)        READY
onDriverArrived(us-central1)       READY
onRideCompleted(us-central1)       READY
```

---

### Step 5: Deploy Firestore Security Rules
```powershell
firebase deploy --only firestore:rules
```

**What this deploys:**
Security rules with:
- ✅ Role-based access control (passengers, drivers, admins)
- ✅ Field-level validation (email format, phone format)
- ✅ User data protection (only owners can modify their data)
- ✅ Audit trail protection (rides cannot be deleted)
- ✅ Read-only collections for sensitive data (analytics, earnings)

**Expected output:**
```
✓ firestore: rules for 'cloud.firestore' updated successfully

Rules deployed successfully!
```

---

### Step 6: Verify Firestore Rules Deployment
```powershell
firebase firestore:indexes --list
firebase rules:list
```

**What this does:**
- Lists Firestore indexes
- Confirms rules are deployed

---

### Step 7: Create Initial Firestore Collections (Optional)
```powershell
# Collections auto-created on first app use, but can pre-create:

# Create admins collection
firebase firestore:documents --collection admins --upsert --data '{"created": true}'

# Create analytics collection
firebase firestore:documents --collection analytics --upsert --data '{"created": true}'

# Create earnings collection
firebase firestore:documents --collection earnings --upsert --data '{"created": true}'
```

---

## Summary of Deployed Services

### Cloud Functions (4 Total)
| Function | Trigger | Purpose | Region |
|----------|---------|---------|--------|
| onRideCreated | Firestore create | Find drivers, send notifications | us-central1 |
| onRideAccepted | Firestore update | Notify passenger | us-central1 |
| onDriverArrived | Firestore update | Driver arrival notification | us-central1 |
| onRideCompleted | Firestore update | Ride completion, earnings | us-central1 |

### Firestore Security Rules
- ✅ 4 helper functions (isSignedIn, isOwner, isValidEmail, isValidPhone)
- ✅ 6 collection rules (passengers, drivers, rides, support, notifications, admins)
- ✅ Full audit trail protection

### Configuration
```json
{
  "project": "urban-glide-transport-25",
  "region": "us-central1",
  "maxInstances": 10,
  "runtime": "Node.js 20"
}
```

---

## Next Steps After Deployment

1. **Configure Mobile Apps**
   - Add google-services.json (Android)
   - Add GoogleService-Info.plist (iOS)
   - Add Google Maps API keys

2. **Test Cloud Functions**
   - Create test ride → Check onRideCreated logs
   - Verify notifications sent to drivers
   - Test each status update

3. **Verify Firestore Rules**
   - Test passenger write access
   - Test driver write access
   - Verify admin restrictions

4. **Test Push Notifications**
   - Enable Firebase Messaging in apps
   - Send test notification from Firebase Console
   - Verify delivery on devices

---

## Troubleshooting

### Function Deployment Fails
```powershell
# Clear and reinstall
cd firebase\functions
npm cache clean --force
npm install
cd ..
firebase deploy --only functions --debug
```

### Rules Deployment Fails
```powershell
# Validate rules syntax
firebase firestore:rules --validate

# Deploy with debug info
firebase deploy --only firestore:rules --debug
```

### Function Logs Not Showing
```powershell
# Check if functions have been triggered
firebase functions:log --limit 100

# Create a test ride to trigger onRideCreated
# Then check logs again
firebase functions:log --follow
```

---

## Deployment Time Estimate

| Task | Duration |
|------|----------|
| Verify Firebase CLI | 1 min |
| Install dependencies | 2 min |
| Deploy Cloud Functions | 3 min |
| Verify functions | 1 min |
| Deploy Firestore Rules | 2 min |
| Verify rules | 1 min |
| **TOTAL** | **~10 minutes** |

---

**Status:** Ready to Deploy ✅  
**Last Updated:** December 1, 2025  
**Next:** Execute deployment steps in order

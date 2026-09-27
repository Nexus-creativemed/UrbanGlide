# Android Studio Setup Guide for Urban Glide

**Last Updated:** November 9, 2025  
**Version:** Android Studio Hedgehog | 2023.1.1 or later  
**Target:** Windows Development Environment

---

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Android SDK Configuration](#android-sdk-configuration)
4. [Flutter Plugin Setup](#flutter-plugin-setup)
5. [Emulator Configuration](#emulator-configuration)
6. [Project Import](#project-import)
7. [Gradle Configuration Verification](#gradle-configuration-verification)
8. [Troubleshooting](#troubleshooting)
9. [Quick Reference](#quick-reference)

---

## 🎯 Prerequisites

### System Requirements

**Minimum:**
- Windows 10 (64-bit) or later
- 8 GB RAM (16 GB recommended)
- 20 GB free disk space
- Intel Core i5 or equivalent

**Recommended:**
- Windows 11 (64-bit)
- 16 GB RAM or more
- SSD with 30+ GB free space
- Intel Core i7 or equivalent
- Graphics card supporting Hardware Acceleration

### Required Software

- [x] Java Development Kit (JDK) 17
- [x] Git for Windows
- [x] Flutter SDK 3.35.7+
- [x] Chrome or Edge browser (for web debugging)

---

## 📥 Installation

### Step 1: Download Android Studio

1. Visit: https://developer.android.com/studio
2. Download **Android Studio Hedgehog (2023.1.1)** or later
3. File size: ~1.5 GB (installer)

### Step 2: Run Installer

```powershell
# Run the downloaded installer
.\android-studio-2023.1.1-windows.exe
```

**Installation Options:**
- ✅ Android Studio
- ✅ Android SDK
- ✅ Android Virtual Device (AVD)
- ✅ Performance (Intel HAXM or AMD Virtualization)

**Installation Path:**
```
Default: C:\Program Files\Android\Android Studio
SDK: C:\Users\<username>\AppData\Local\Android\Sdk
```

**Estimated Time:** 15-20 minutes

---

## 🔧 Android SDK Configuration

### Step 3: Initial Setup Wizard

**Launch Android Studio** → First-time setup wizard:

1. **Welcome Screen** → Click "Next"
2. **Install Type** → Select "Standard" → Click "Next"
3. **UI Theme** → Choose theme (Darcula recommended) → Click "Next"
4. **SDK Components** → Verify selections:
   - ✅ Android SDK
   - ✅ Android SDK Platform
   - ✅ Android Virtual Device
5. **Verify Settings** → Click "Finish"

### Step 4: SDK Manager Configuration

**Open SDK Manager:**
```
Tools → SDK Manager
or
File → Settings → Appearance & Behavior → System Settings → Android SDK
```

#### **SDK Platforms Tab**

Install the following:

- ✅ **Android 14.0 (API 34)** - Compile SDK
  - Android SDK Platform 34
  - Sources for Android 34
  
- ✅ **Android 13.0 (API 33)** - Emulator
  - Android SDK Platform 33
  - Google APIs Intel x86 Atom System Image
  - Google Play Intel x86 Atom System Image
  
- ✅ **Android 5.0 (API 21)** - Min SDK testing
  - Android SDK Platform 21

#### **SDK Tools Tab**

Ensure these are installed/updated:

- ✅ Android SDK Build-Tools (34.0.0)
- ✅ Android SDK Command-line Tools (latest)
- ✅ Android SDK Platform-Tools (latest)
- ✅ Android Emulator (latest)
- ✅ Google Play services
- ✅ Intel x86 Emulator Accelerator (HAXM) - if Intel CPU
- ✅ Android SDK Tools (Obsolete) - for legacy support

**Click "Apply" → "OK"**

**Estimated Time:** 10-15 minutes (depending on internet speed)

---

## 🔌 Flutter Plugin Setup

### Step 5: Install Flutter Plugin

**Method 1: Via Welcome Screen**
1. Click "Plugins"
2. Search "Flutter"
3. Click "Install"
4. Restart Android Studio

**Method 2: Via Settings**
```
File → Settings → Plugins → Marketplace
```
1. Search "Flutter"
2. Install **Flutter** plugin (by flutter.io)
3. Install **Dart** plugin (auto-installed with Flutter)
4. Click "Apply" → Restart

**Verification:**
```powershell
# Open terminal in Android Studio
flutter doctor -v
```

Expected output:
```
[✓] Flutter (Channel stable, 3.35.7, on Microsoft Windows)
[✓] Android toolchain - develop for Android devices (Android SDK 34.0.0)
[✓] Android Studio (version 2023.1)
[✓] Connected device (1 available)
```

**Estimated Time:** 5-10 minutes

---

## 🖥️ Emulator Configuration

### Step 6: Create Android Virtual Device (AVD)

**Open AVD Manager:**
```
Tools → Device Manager
or
Click AVD Manager icon in toolbar
```

#### **Recommended Configuration**

**Device Profile:**
```
Name:              Pixel 6 API 33
Device:            Pixel 6
Screen:            6.4" 1080x2400 (FHD+)
API Level:         33 (Android 13.0)
Target:            Google Play (x86_64)
```

**Hardware Settings:**
```
RAM:               4096 MB (4 GB)
VM Heap:           256 MB
Internal Storage:  4096 MB (4 GB)
SD Card:           512 MB (or as needed)
```

**Graphics:**
```
Graphics:          Hardware - GLES 2.0
Boot Option:       Cold Boot
```

**Advanced Settings:**
```
Camera:            VirtualScene (Front), Emulated (Back)
Network:           NAT
Speed:             Full
Latency:           None
Enable Keyboard:   ✅
```

#### **Step-by-Step Creation**

1. **Device Manager** → Click "Create Device"
2. **Select Hardware** → Choose "Pixel 6" → Click "Next"
3. **System Image** → Select "R" (API 33) with Google Play → Download if needed → Click "Next"
4. **AVD Name** → Enter "Pixel_6_API_33" → Verify settings → Click "Finish"

**Estimated Time:** 5-10 minutes (15-20 if downloading system image)

---

## 📂 Project Import

### Step 7: Import Urban Glide Project

#### **Method 1: Via Welcome Screen**
1. Click "Open"
2. Navigate to: `C:\src\Claude\passenger_app`
3. Select the folder → Click "OK"

#### **Method 2: Via Menu**
```
File → Open → C:\src\Claude\passenger_app
```

### Step 8: Gradle Sync

Android Studio will automatically:
1. Detect Flutter project
2. Run Gradle sync
3. Download dependencies
4. Index project files

**Monitor progress:** Bottom status bar shows "Gradle Build Running..."

**Expected Duration:** 5-10 minutes (first time)

#### **If Gradle Sync Fails:**

```powershell
# Clean and rebuild
cd passenger_app\android
.\gradlew clean
.\gradlew build --refresh-dependencies
```

---

## ✅ Gradle Configuration Verification

### Step 9: Verify Build Configuration

#### **Check SDK Versions**

**File:** `passenger_app/android/app/build.gradle.kts`

```kotlin
android {
    compileSdk = 34           // ✅ Should be 34
    
    defaultConfig {
        minSdk = 21           // ✅ Should be 21
        targetSdk = 34        // ✅ Latest
        multiDexEnabled = true // ✅ Should be enabled
    }
}
```

#### **Verify Dependencies**

**Terminal in Android Studio:**
```powershell
# Navigate to android directory
cd android

# Check dependencies
.\gradlew app:dependencies
```

**Look for:**
```
+--- com.google.firebase:firebase-bom:32.7.0
+--- com.google.firebase:firebase-analytics-ktx
+--- com.google.firebase:firebase-messaging-ktx
+--- androidx.multidex:multidex:2.0.1
+--- com.google.android.gms:play-services-maps
```

#### **Test Build**

```powershell
# From passenger_app root
flutter build apk --debug

# Or from Android directory
cd android
.\gradlew assembleDebug
```

**Successful Output:**
```
✓ Built build\app\outputs\flutter-apk\app-debug.apk (XX MB)
```

---

## 🚀 Running the App

### Step 10: Run on Emulator

1. **Start Emulator:**
   - Open AVD Manager
   - Click ▶ next to "Pixel_6_API_33"
   - Wait for emulator to boot (~2 minutes)

2. **Select Device:**
   - Android Studio toolbar → Device dropdown
   - Select "Pixel_6_API_33"

3. **Run App:**
   - Click ▶ Run button (Shift+F10)
   - Or: `flutter run` in terminal

**First Run:** 5-10 minutes (initial compilation)  
**Subsequent Runs:** 30-60 seconds (hot reload available)

---

## 🛠️ Troubleshooting

### Issue 1: Gradle Sync Failed

**Error:** "Gradle sync failed: Could not find com.android.tools.build:gradle"

**Solution:**
```powershell
# Clean Gradle cache
cd passenger_app\android
.\gradlew clean

# Delete .gradle directory
Remove-Item -Recurse -Force .gradle

# Re-sync
.\gradlew build --refresh-dependencies
```

---

### Issue 2: Emulator Won't Start

**Error:** "Emulator: ERROR: x86 emulation currently requires hardware acceleration!"

**Solution (Intel CPU - HAXM):**
1. Download HAXM: https://github.com/intel/haxm/releases
2. Run installer: `intelhaxm-android.exe`
3. Disable Hyper-V (if needed):
   ```powershell
   # Run as Administrator
   bcdedit /set hypervisorlaunchtype off
   # Restart computer
   ```

**Solution (AMD CPU - SVM):**
1. Enable SVM in BIOS:
   - Restart → Enter BIOS (F2/Del)
   - Advanced → CPU Configuration
   - Enable "SVM Mode" or "AMD-V"
   - Save and exit

2. Disable Hyper-V:
   ```powershell
   # Run as Administrator
   Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All
   # Restart computer
   ```

**Verify:**
```powershell
# Check emulator acceleration
emulator -accel-check

# Expected output:
# "HAXM version x.x.x is installed and usable."
# or
# "SVM is enabled"
```

---

### Issue 3: App Crashes on Launch

**Error:** "Application has stopped" or crash on startup

**Solution:**

**Check Logs:**
```powershell
# View device logs
flutter logs

# Or Android Studio Logcat:
# View → Tool Windows → Logcat
```

**Common Causes:**

1. **Missing google-services.json:**
   ```
   Error: google-services.json not found
   ```
   **Fix:** Download from Firebase Console → `android/app/`

2. **MultiDex not enabled:**
   ```
   Error: Cannot fit requested classes in a single dex file
   ```
   **Fix:** Already enabled in `build.gradle.kts`:
   ```kotlin
   multiDexEnabled = true
   ```

3. **Google Maps API key:**
   ```
   Error: Google Maps API key not found
   ```
   **Fix:** Add to `AndroidManifest.xml`:
   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_API_KEY_HERE"/>
   ```

---

### Issue 4: SDK Not Found

**Error:** "Android SDK not found at specified location"

**Solution:**

**Set SDK Path:**
```powershell
# Add to environment variables
$env:ANDROID_SDK_ROOT = "C:\Users\<username>\AppData\Local\Android\Sdk"
$env:ANDROID_HOME = $env:ANDROID_SDK_ROOT

# Or in Flutter config:
flutter config --android-sdk "C:\Users\<username>\AppData\Local\Android\Sdk"
```

**Verify:**
```powershell
flutter doctor -v

# Should show:
# [✓] Android toolchain - develop for Android devices
```

---

### Issue 5: Slow Gradle Builds

**Solution:**

**Optimize Gradle:**

Already configured in `gradle.properties`:
```properties
org.gradle.jvmargs=-Xmx4096M -XX:MaxMetaspaceSize=2G
org.gradle.daemon=true
org.gradle.parallel=true
org.gradle.caching=true
org.gradle.configureondemand=true
```

**Additional Optimization:**

1. **Disable antivirus scanning** on project directory (temporarily)
2. **Use SSD** for Android SDK and project files
3. **Increase RAM allocation** if available:
   ```properties
   org.gradle.jvmargs=-Xmx8192M -XX:MaxMetaspaceSize=4G
   ```

---

## 📊 Quick Reference

### Installation Time Breakdown
```
Android Studio Install:     20 minutes
SDK Configuration:          15 minutes
Flutter Plugin:             10 minutes
Emulator Setup:             15 minutes
Flutter Doctor:             10 minutes
Project Setup:              15 minutes
First Run:                  10 minutes
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TOTAL TIME:                 95 minutes (~1.5 hours)
```

### Disk Space Requirements
```
Android Studio:             ~1.5 GB
Android SDK:                ~5 GB
Gradle Dependencies:        ~1 GB
System Images:              ~2 GB per API level
Flutter Cache:              ~1 GB
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
TOTAL:                      ~15-20 GB
```

### Emulator Specifications (Recommended)
```
Device:                     Pixel 6
Screen:                     6.4" 1080x2400 (FHD+)
API Level:                  33 (Android 13)
Target:                     Google Play (x86_64)
RAM:                        4096 MB (4 GB recommended)
Internal Storage:           4096 MB
SD Card:                    512 MB (optional)
Graphics:                   Hardware - GLES 2.0
Boot Option:                Cold Boot
Camera:                     Emulated (both)
Network:                    NAT
```

### Useful Commands
```powershell
# Flutter commands
flutter doctor -v           # Check Flutter setup
flutter devices             # List available devices
flutter run                 # Run app on device
flutter build apk           # Build APK
flutter clean               # Clean build cache
flutter pub get             # Get dependencies

# Gradle commands
cd android
.\gradlew tasks             # List available tasks
.\gradlew clean             # Clean build
.\gradlew assembleDebug     # Build debug APK
.\gradlew assembleRelease   # Build release APK
.\gradlew app:dependencies  # Show dependencies
.\gradlew --stop            # Stop Gradle daemon

# Emulator commands
emulator -list-avds         # List AVDs
emulator -avd Pixel_6_API_33  # Start specific AVD
emulator -accel-check       # Check acceleration
adb devices                 # List connected devices
adb logcat                  # View device logs
```

### Keyboard Shortcuts
```
Run App:                    Shift + F10
Stop App:                   Ctrl + F2
Hot Reload:                 Ctrl + \
Hot Restart:                Ctrl + Shift + \
Format Code:                Ctrl + Alt + L
Find File:                  Ctrl + Shift + N
Search Everywhere:          Shift + Shift (double tap)
Open Settings:              Ctrl + Alt + S
Terminal:                   Alt + F12
Logcat:                     Alt + 6
```

---

## 🎓 Next Steps

After completing Android Studio setup:

1. **Configure Firebase:**
   - See `FIREBASE_SETUP.md`
   - Add `google-services.json` files

2. **Configure Google Maps:**
   - See `PLATFORM_CONFIG.md`
   - Add API keys to manifests

3. **Review Gradle Config:**
   - See `GRADLE_CONFIG.md`
   - Verify SDK versions

4. **Run Full Verification:**
   - See `VERIFICATION.md`
   - Complete setup checklist

5. **Start Development:**
   - See `README.md`
   - Review project structure

---

## 📞 Support & Resources

**Official Documentation:**
- Android Studio: https://developer.android.com/studio/intro
- Flutter: https://docs.flutter.dev/get-started/install/windows
- Firebase: https://firebase.google.com/docs/flutter/setup

**Urban Glide Docs:**
- `README.md` - Project overview
- `SETUP_COMPLETE.md` - Full setup guide
- `FIREBASE_SETUP.md` - Firebase configuration
- `PLATFORM_CONFIG.md` - Platform-specific setup
- `GRADLE_CONFIG.md` - Gradle build configuration
- `VERIFICATION.md` - Setup verification checklist

**Troubleshooting Resources:**
- Flutter Doctor: `flutter doctor -v`
- Gradle Build Scan: `.\gradlew build --scan`
- Stack Overflow: https://stackoverflow.com/questions/tagged/flutter

---

**Document Version:** 1.0  
**Last Verified:** November 9, 2025  
**Maintained By:** Urban Glide Development Team  
**Status:** ✅ Complete and Tested

# Release Build Guide for Google Play

Complete guide for building and publishing Flutter apps to Google Play Store.

## 📋 Pre-Release Checklist

Before building your release:

- [ ] Update version in `pubspec.yaml` (e.g., `2.0.0+2`)
- [ ] Update `CHANGELOG.md` with release notes
- [ ] Remove all debug logs and print statements
- [ ] Test all features thoroughly
- [ ] Verify Firebase/backend configurations
- [ ] Update screenshots (if UI changed)
- [ ] Review privacy policy (if applicable)

## 🔑 Step 1: Prepare Signing Files

### Create Keystore (First Time Only)

```bash
keytool -genkey -v -keystore upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload
```

**Important**: 
- Store keystore file in a **secure location** outside your project
- **Backup** your keystore - you cannot publish updates without it!
- Never commit keystore to Git

### Create Password File

Create a file (e.g., `pass.env`) with your credentials:

```env
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=upload
```

**Security**:
- Store **outside** your project directory
- Never commit to Git
- Keep backups in secure location

## 🛠️ Step 2: Configure Android Signing

Your `android/app/build.gradle.kts` should have:

```kotlin
// Load signing properties
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    // ... other config ...
    
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }
    
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            // ... other settings ...
        }
    }
}
```

## 📦 Step 3: Build Release

### Option A: Automated Script (Recommended)

```bash
# Make script executable (first time only)
chmod +x build_release.sh

# Run build script
./build_release.sh
```

The script will:
1. Prompt for password file path
2. Prompt for keystore path
3. Validate all files
4. Build signed App Bundle
5. Clean up temporary files

### Option B: Manual Build

```bash
# 1. Create temporary key.properties
cat > android/key.properties << EOF
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=upload
storeFile=/full/path/to/keystore.jks
EOF

# 2. Clean and prepare
flutter clean
flutter pub get

# 3. Build App Bundle (recommended)
flutter build appbundle --release

# 4. Or build APK
flutter build apk --release

# 5. Clean up (IMPORTANT!)
rm android/key.properties
```

## 📍 Build Output Locations

After successful build:

- **App Bundle** (for Google Play): 
  ```
  build/app/outputs/bundle/release/app-release.aab
  ```

- **APK** (for direct distribution):
  ```
  build/app/outputs/flutter-apk/app-release.apk
  ```

- **Split APKs** (smaller size):
  ```bash
  flutter build apk --split-per-abi --release
  ```
  Output:
  - `app-armeabi-v7a-release.apk` (32-bit ARM)
  - `app-arm64-v8a-release.apk` (64-bit ARM)
  - `app-x86_64-release.apk` (64-bit x86)

## 🧪 Step 4: Test Release Build

**Always test before uploading!**

```bash
# Install on connected device
flutter install --release

# Or use adb
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Testing Checklist

- [ ] App launches without crashes
- [ ] All features work correctly
- [ ] Authentication/login works
- [ ] Network requests succeed
- [ ] Database operations work
- [ ] No debug logs in console
- [ ] App performance is good
- [ ] App size is acceptable

## 🔍 Step 5: Verify Signing

Check that your app is properly signed:

```bash
# For App Bundle
jarsigner -verify -verbose -certs build/app/outputs/bundle/release/app-release.aab

# For APK
keytool -list -printcert -jarfile build/app/outputs/flutter-apk/app-release.apk
```

Should show your certificate details, not debug certificate.

## 📤 Step 6: Upload to Google Play Console

1. **Login** to [Google Play Console](https://play.google.com/console)

2. **Select your app** (or create new app if first release)

3. **Navigate to Release**:
   - For new release: Production → Create new release
   - For update: Production → View → New release

4. **Upload App Bundle**:
   - Click "Upload" button
   - Select `app-release.aab` file
   - Wait for upload and processing

5. **Fill Release Details**:
   - Release name (e.g., "2.0.0")
   - Release notes (see template below)
   - Target countries/regions
   - Staged rollout percentage (optional)

6. **Review and Roll Out**:
   - Review all details
   - Click "Save" then "Review release"
   - Click "Start rollout to Production"

### Release Notes Template

```
Version X.Y.Z

🎉 New Features:
• Feature 1 description
• Feature 2 description

⚡ Improvements:
• Improvement 1
• Improvement 2

🐛 Bug Fixes:
• Fixed issue 1
• Fixed issue 2

📝 Other:
• Updated dependencies
• Performance optimizations
```

## 🔄 Version Management

Update version in `pubspec.yaml`:

```yaml
version: MAJOR.MINOR.PATCH+BUILD_NUMBER
# Example: 2.0.1+3
```

- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes
- **BUILD_NUMBER**: Must increase with each upload to Play Store

## 📸 Required Play Store Assets

### App Screenshots (Required)
- **Phone**: Minimum 2 screenshots
  - Size: 16:9 or 9:16 aspect ratio
  - Min: 320px, Max: 3840px
  
- **7-inch Tablet** (Optional but recommended)
  - At least 1 screenshot
  
- **10-inch Tablet** (Optional but recommended)
  - At least 1 screenshot

### Feature Graphic (Required)
- Size: **1024 x 500 px**
- Format: PNG or JPEG
- No transparency

### App Icon (Required)
- Size: **512 x 512 px**
- Format: PNG
- 32-bit with alpha

## 🔒 Security Checklist

Before release:

- [ ] No hardcoded API keys or secrets
- [ ] No debug logs or print statements
- [ ] Firebase security rules configured
- [ ] Keystore secured and backed up
- [ ] SSL certificate pinning (if applicable)
- [ ] ProGuard/R8 enabled for obfuscation
- [ ] Sensitive data encrypted
- [ ] Permissions properly requested

## 🐛 Common Issues & Solutions

### Issue: "App not signed"
**Solution**: Verify `key.properties` paths are correct and keystore exists

### Issue: "Version code must be higher"
**Solution**: Increment build number in `pubspec.yaml`

### Issue: "Duplicate resources"
**Solution**: Check for conflicting dependencies, run `flutter clean`

### Issue: "Keystore was tampered with"
**Solution**: Verify keystore password is correct

### Issue: "Upload rejected: Wrong signing key"
**Solution**: Ensure you're using the same keystore as previous releases

### Issue: Build fails with signing errors
**Solution**: 
```bash
# Clean everything
flutter clean
rm -rf build/
rm android/key.properties

# Rebuild
./build_release.sh
```

## 📊 Post-Release Monitoring

After publishing:

1. **Monitor Crashes**:
   - Google Play Console → Quality → Android vitals
   - Check crash reports and ANRs

2. **Track Metrics**:
   - User acquisition
   - Retention rates
   - Uninstall rates

3. **Respond to Reviews**:
   - Reply to user feedback
   - Address common complaints
   - Thank users for positive reviews

4. **Plan Next Release**:
   - Gather user feedback
   - Fix reported bugs
   - Plan new features

## 🆘 Support & Resources

- **Flutter Docs**: https://flutter.dev/docs/deployment/android
- **Play Console Help**: https://support.google.com/googleplay/android-developer
- **Check signing**: `keytool -list -v -keystore /path/to/keystore.jks`
- **Flutter doctor**: `flutter doctor -v`

## 📝 Important Notes

- **App Bundle vs APK**: Always upload App Bundle (.aab) to Play Store
  - Smaller downloads for users
  - Play Store optimizes APKs per device
  - Required for apps over 150MB

- **First Release Timeline**:
  - Review typically takes 1-3 days
  - May take longer for first submission
  - Be patient and monitor Play Console

- **Update Releases**:
  - Usually reviewed faster (hours to 1 day)
  - Must use same signing key as original

- **Backup Checklist**:
  - ✅ Keystore file
  - ✅ Keystore passwords
  - ✅ Play Store account credentials
  - ✅ Service account keys (if using)

---

## 🎯 Quick Reference Commands

```bash
# Check Flutter setup
flutter doctor -v

# Clean project
flutter clean

# Get dependencies
flutter pub get

# Build App Bundle
flutter build appbundle --release

# Build APK
flutter build apk --release

# Install release build
flutter install --release

# Check signing
keytool -list -v -keystore /path/to/keystore.jks

# Verify signed APK
jarsigner -verify -verbose -certs build/app/outputs/flutter-apk/app-release.apk
```

---

**Good luck with your release! 🚀**

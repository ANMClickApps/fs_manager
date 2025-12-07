# Quick Start: Build Release for Google Play

This guide helps you build a signed release App Bundle for any Flutter project.

## 🚀 Quick Build (Automated Script)

### 1. Prerequisites

You need two files:

**A) Password File** (example: `pass.env`):
```env
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
```
Store this file **outside** your project directory in a secure location.

**B) Keystore File** (example: `upload-keystore.jks`):
- If you don't have one, create it:
```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA \
  -keysize 2048 -validity 10000 -alias upload
```
- Store this file **outside** your project directory in a secure location.

### 2. Run Build Script

```bash
dart build_release.dart
```

The script will prompt you for:
1. **Path to password file** - Enter the full path or drag-and-drop the file
2. **Path to keystore file** - Enter the full path or drag-and-drop the file

The script will then:
- ✅ Load your credentials securely
- ✅ Validate files
- ✅ Clean previous builds
- ✅ Get dependencies
- ✅ Build signed App Bundle
- ✅ Clean up temporary files

### 4. Output Location

Your signed release will be at:
```
build/app/outputs/bundle/release/app-release.aab
```

## 📋 Manual Build (Alternative)

If you prefer to build manually:

```bash
# 1. Create android/key.properties file:
cat > android/key.properties << EOF
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=upload
storeFile=/path/to/your/keystore.jks
EOF

# 2. Clean and build
flutter clean
flutter pub get
flutter build appbundle --release

# 3. Don't forget to delete key.properties after build!
rm android/key.properties
```

## 📤 Upload to Google Play

1. Go to [Google Play Console](https://play.google.com/console)
2. Select your app
3. Navigate to **Production** → **Create new release**
4. Upload `app-release.aab`
5. Add release notes
6. Review and publish

## 🧪 Test Release Build

Before uploading:

```bash
# Install on connected device
flutter install --release

# Or install manually
adb install build/app/outputs/flutter-apk/app-release.apk
```

## 🔧 Troubleshooting

### Dart not found
```bash
# Make sure Flutter SDK is in PATH
flutter doctor -v
```

### File not found when prompted
- Use **absolute paths** (e.g., `/Users/username/Documents/pass.env`)
- Or **drag-and-drop** the file into terminal
- Check file exists: `ls -l /path/to/file`

### Build fails
```bash
# Check Flutter installation
flutter doctor -v

# Clean and retry
flutter clean
rm -rf build/
```

### Signing errors
- Verify passwords in `pass.env` are correct
- Check keystore file is not corrupted:
```bash
keytool -list -v -keystore /path/to/keystore.jks
```

## 📁 Recommended File Structure

Keep signing files **outside** your project:

```
~/Documents/
├── MyFlutterProject/          # Your project
│   ├── android/
│   ├── lib/
│   └── build_release.sh       # This script
│
└── AndroidSigning/            # Signing files (NEVER commit to Git!)
    ├── pass.env               # Passwords
    └── upload-keystore.jks    # Keystore
```

## 🔒 Security Best Practices

- ✅ **Never** commit `pass.env` or keystore to Git
- ✅ Store signing files in a secure location
- ✅ Backup your keystore (you can't publish updates without it!)
- ✅ Use different passwords for different projects
- ✅ The script automatically removes `key.properties` after build

## 📝 Notes

- The script is **universal** and works with any Flutter project
- You only need to configure it once per project
- Paths are requested interactively, so no hardcoded values
- Safe to share this script - it contains no sensitive information

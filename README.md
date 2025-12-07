# FS Manager - Secure Password Manager

A Flutter-based password manager with end-to-end encryption using Firebase as the backend.

## 🔒 Security Features

- **AES-256 Encryption**: All data is encrypted using military-grade AES encryption
- **PIN-Based Security**: User-defined PIN code serves as the encryption key
- **Local Encryption**: Data is encrypted on device before syncing to Firebase
- **Zero-Knowledge Architecture**: Even the database admin cannot decrypt your data

## ✨ Features

- 📱 **Account Management**: Store credentials for 42+ popular services
- 🔍 **Tag-Based Search**: Organize and find accounts using custom tags
- 🗑️ **Trash System**: Safely delete and restore accounts
- 📋 **Quick Copy**: One-tap copy of usernames and passwords
- 🎨 **Font Awesome Icons**: Beautiful icons for all major services
- 🔐 **Multi-Selection**: Bulk move accounts to trash
- 📧 **Password Reset**: Email-based password recovery for Firebase account
- ⚙️ **Settings**: Manage your account and view security information

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Firebase account
- Android Studio / Xcode for mobile development

### Firebase Setup

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable **Firebase Authentication** (Email/Password provider)
3. Enable **Firebase Realtime Database**
4. Add your Android/iOS app to Firebase project
5. Download configuration files:
   - Android: `google-services.json` → `android/app/`
   - iOS: `GoogleService-Info.plist` → `ios/Runner/`

### Database Rules

Set these rules in Firebase Realtime Database:

```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid"
      }
    },
    "trash": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid"
      }
    }
  }
}
```

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/fs_manager.git
cd fs_manager
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your project
flutterfire configure
```

4. Run the app:
```bash
flutter run
```

## 📦 Dependencies

- `firebase_core: ^3.6.0` - Firebase core functionality
- `firebase_auth: ^5.3.1` - User authentication
- `firebase_database: ^11.1.4` - Realtime database
- `encrypt: ^5.0.3` - AES encryption
- `shared_preferences: ^2.3.2` - Local storage for PIN
- `font_awesome_flutter: ^10.7.0` - Icon library

## 🏗️ Project Structure

```
lib/
├── data/
│   ├── account_logo.dart        # Service icons and colors
│   ├── db_helper.dart           # Firebase CRUD operations
│   ├── my_encryption.dart       # AES encryption logic
│   └── model/
│       └── records_model.dart   # Data models
├── ui/
│   ├── screens/
│   │   ├── login/              # Authentication screens
│   │   ├── signup/             # Registration screens
│   │   ├── pincode/            # PIN setup/entry
│   │   ├── account_tab.dart    # Main accounts list
│   │   ├── settings_tab.dart   # Settings screen
│   │   ├── trash_screen.dart   # Trash management
│   │   └── add_account_screen.dart
│   └── widget/                 # Reusable UI components
├── style/
│   ├── brand_color.dart        # Color palette
│   └── brand_text.dart         # Text styles
└── main.dart                   # App entry point
```

## ⚠️ Important Security Notes

- **Never forget your PIN code**: There is no way to recover it
- **PIN is not stored in Firebase**: It's only stored locally on your device
- **Backup your data**: If you lose your device and PIN, data cannot be recovered
- **Keep your PIN private**: Never share it with anyone

## 🛠️ Development

### Running Tests
```bash
flutter test
```

### Building for Production

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**ANM Click Apps**

- GitHub: [@ANMClickApps](https://github.com/ANMClickApps)
- Google Play: [FS Manager](https://play.google.com/store/apps/details?id=com.anm.click.fmanager)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend infrastructure
- Font Awesome for beautiful icons
- The open-source community

## 📧 Support

For support, email anmclick@gmail.com or open an issue on GitHub.

---

**⚠️ Disclaimer**: This app is provided as-is. Always maintain backups of critical passwords in a secure location.

# Changelog

All notable changes to FS Manager will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2025-12-07

### Added
- 🗑️ **Trash System**: Move accounts to trash instead of immediate deletion
  - View deleted accounts in Settings → Trash
  - Restore accounts with swipe gesture
  - Permanently delete with confirmation
  - Empty trash button for bulk deletion
- ✅ **Multi-Selection Mode**: Long-press to select multiple accounts
  - Select All functionality
  - Bulk move to trash
  - Visual selection feedback with checkboxes
- 🔐 **Security Info Dialog**: Detailed information about encryption
  - AES-256 encryption explanation
  - PIN code importance warnings
  - Data recovery limitations
- 📱 **Enhanced UI**:
  - AppBar with selection counter
  - "Account Info" vs "Create Account" titles
  - Back button in view mode
  - Update button for editing existing accounts
- 🎨 **Font Awesome Icons**: Replaced SVG with 42+ scalable icons
- ✨ **Optional Fields**: Website and Tags now optional with confirmation
- 💬 **Better Validation**: Emoji-enhanced error messages
- 🔄 **Update Functionality**: Edit existing accounts without creating duplicates

### Changed
- 🔧 **Fixed IV Generation**: Changed from random to deterministic IV
  - Resolves "Invalid or corrupted pad block" errors
  - Consistent encryption/decryption
- 📝 **Empty Field Handling**: Uses `__EMPTY__` marker for empty values
- 🎯 **Improved Null Safety**: Better handling of null values in RecordModel
- 🔒 **Database Security**: Added trash node to Firebase rules
- 🧹 **Code Cleanup**: Commented out all debug print statements

### Fixed
- 🐛 Fixed encryption/decryption key mismatch issues
- 🐛 Fixed keyboard overlapping input fields on login/signup
- 🐛 Fixed password reset email delivery (check spam folder)
- 🐛 Fixed empty string encryption errors
- 🐛 Fixed Firebase Realtime Database type casting issues
- 🐛 Fixed settings item touch feedback with InkWell

### Removed
- ❌ Removed flutter_svg dependency
- ❌ Removed temporary "Clear All Data" button
- ❌ Removed firebase_app_check dependency

### Security
- 🔐 Implemented deterministic IV generation for consistent decryption
- 🔒 Added trash node security rules
- 🛡️ Enhanced encryption key derivation
- 📋 Added SECURITY.md with detailed security information

## [1.0.0] - 2022-05-XX

### Added
- Initial release
- Firebase Authentication (Email/Password)
- AES-256 encryption with PIN code
- Account storage with tags
- Password reset functionality
- Search by tags
- Copy to clipboard features
- 42+ service logos (SVG)

---

[2.0.0]: https://github.com/ANMClickApps/fs_manager/releases/tag/v2.0.0
[1.0.0]: https://github.com/ANMClickApps/fs_manager/releases/tag/v1.0.0

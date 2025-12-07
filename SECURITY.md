# Security Policy

## 🔒 Security Features

FS Manager implements multiple layers of security to protect your sensitive data:

### Encryption

- **Algorithm**: AES-256 encryption in CBC mode
- **Key Derivation**: User PIN code is extended to 32 characters to create encryption key
- **Initialization Vector**: Deterministic IV derived from encryption key for consistency
- **Scope**: All account data (passwords, usernames, websites, tags) is encrypted before storage

### Data Storage

- **Local Storage**: PIN code stored locally using SharedPreferences (not synced to cloud)
- **Cloud Storage**: Only encrypted data is stored in Firebase Realtime Database
- **Zero-Knowledge**: Firebase administrators cannot decrypt user data without PIN code

### Authentication

- **Firebase Authentication**: Email/password based authentication
- **Password Reset**: Email-based password recovery for Firebase account
- **Session Management**: Secure session handling with automatic logout

## 🔐 PIN Code Security

### Important Information

⚠️ **CRITICAL**: Your PIN code is the master key to all your encrypted data.

- PIN is **only** stored on your device
- PIN is **never** transmitted to Firebase servers
- If you forget your PIN, **data cannot be recovered**
- No backdoor or master key exists

### Best Practices

1. **Choose a Strong PIN**: Use 6+ characters combining letters and numbers
2. **Remember Your PIN**: Write it down in a secure physical location
3. **Don't Share**: Never share your PIN with anyone
4. **Device Security**: Enable device lock screen protection

## 🛡️ Data Protection

### What's Encrypted

✅ Account names  
✅ Usernames/emails  
✅ Passwords  
✅ Websites  
✅ Tags  
✅ Service identifiers  

### What's Not Encrypted

❌ User email (Firebase account email)  
❌ User UID (Firebase unique identifier)  
❌ Encryption metadata (IV, algorithm version)  

## 📊 Firebase Security Rules

The app uses Firebase Realtime Database with strict security rules:

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

These rules ensure:
- Users can only access their own data
- No cross-user data access is possible
- Anonymous access is denied

## 🐛 Reporting Security Vulnerabilities

If you discover a security vulnerability, please:

1. **DO NOT** open a public issue
2. Email details to: anmclick@gmail.com
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

We will respond within 48 hours and work on a fix promptly.

## ⚠️ Limitations & Disclaimers

### Known Limitations

1. **Device Loss**: Losing device + forgetting PIN = permanent data loss
2. **PIN Compromise**: If someone gets your PIN, they can decrypt all data
3. **Device Backup**: System backups may include unencrypted PIN
4. **Memory Attacks**: Advanced attacks on device memory could potentially extract PIN

### User Responsibilities

- Maintain physical security of your device
- Use strong device authentication (fingerprint, face ID, pattern)
- Keep app updated to latest version
- Regularly backup important passwords to alternative secure storage
- Monitor account for unauthorized access

## 🔄 Security Updates

- Security patches released as soon as possible
- Critical vulnerabilities fixed within 7 days
- Users notified through app updates and GitHub releases

## 📜 Compliance

This app:
- Does not collect or sell user data
- Does not share data with third parties
- Follows GDPR principles for data protection
- Implements encryption at rest and in transit

## 🔍 Third-Party Dependencies

Security is maintained through:
- Regular dependency updates
- Monitoring security advisories for Flutter and Firebase
- Using well-audited encryption libraries (`encrypt` package)
- Following Flutter security best practices

## 📞 Contact

For security concerns: anmclick@gmail.com  
For general support: GitHub Issues

---

Last Updated: December 2025

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widget/settings_item.dart';
import 'forgot_password_screen.dart';
import 'login/login_screens.dart';
import 'trash_screen.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  signOut() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
        context, LoginScreen.id, (route) => false);
  }

  String getEmail() {
    String email = '';
    final currentEmail = FirebaseAuth.instance.currentUser!.email;
    if (currentEmail != null) {
      email = currentEmail;
    }

    return email;
  }

  void showSecurityInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.security, color: Colors.blue, size: 28),
            SizedBox(width: 12),
            Text('Security Information'),
          ],
        ),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data Encryption',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'All your account data is encrypted using AES-256 encryption with your personal PIN code.',
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.vpn_key, color: Colors.orange, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your PIN Code',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'The PIN code you created during first login is used as the encryption key for all your data.',
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.red, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'IMPORTANT!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'If you forget your PIN code, you will NOT be able to decrypt and access your saved accounts. There is no way to recover forgotten PIN codes.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 16),
              Text(
                '🔒 Keep your PIN code safe and memorable!\n'
                '🔐 Never share your PIN code with anyone.\n'
                '💾 Your data is only accessible with your PIN.',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24.0),
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12.0),
            SettingsItem(
              iconData: Icons.mail,
              title: 'Your email',
              subtitle: getEmail(),
              onTap: () {
                // Можна додати копіювання email або просто порожня дія
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Email: ${getEmail()}')),
                );
              },
            ),
            const SizedBox(height: 12.0),
            SettingsItem(
              iconData: Icons.lock_reset_outlined,
              title: 'Reset password',
              subtitle: 'Reset email password',
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const ForgotPasswordScreen()))),
            ),
            const SizedBox(height: 12.0),
            SettingsItem(
              iconData: Icons.delete_outline,
              title: 'Trash',
              subtitle: 'View deleted accounts',
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const TrashScreen()))),
            ),
            const SizedBox(height: 12.0),
            SettingsItem(
              iconData: Icons.security,
              title: 'Security Info',
              subtitle: 'About data encryption & PIN code',
              onTap: showSecurityInfoDialog,
            ),
            const Spacer(),
            SettingsItem(
              iconData: Icons.logout,
              title: 'Sign out',
              subtitle: 'Exit the application',
              onTap: signOut,
            ),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
}

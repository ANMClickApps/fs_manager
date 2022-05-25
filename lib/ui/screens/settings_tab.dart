import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widget/settings_item.dart';
import 'login/login_screens.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  singOut() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
        context, LoginScreen.id, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24.0),
            const Text(
              'Settings',
              style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18.0),
            SettingsItem(
              iconData: Icons.logout,
              title: 'Sign out',
              subtitle: 'Exit the application',
              ontap: singOut,
            ),
          ],
        ),
      ),
    );
  }
}

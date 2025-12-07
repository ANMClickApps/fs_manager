import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../style/brand_color.dart';
import '../../util/show_message_helper.dart';
import '../widget/custom_button.dart';
import '../widget/textfield_email.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    // Автоматично заповнюємо email поточного користувача
    final currentUser = FirebaseAuth.instance.currentUser;
    _emailController = TextEditingController(
      text: currentUser?.email ?? '',
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    try {
      // print('Sending password reset email to: ${_emailController.text.trim()}');
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      // print('Password reset email sent successfully');

      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading dialog

      ShowMessageHelper.showMessage(
          context: context,
          text: 'Password reset email sent. Check your inbox.',
          isError: false);

      // ignore: use_build_context_synchronously
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      // print('FirebaseAuthException code: ${e.code}');
      // print('FirebaseAuthException message: ${e.message}');

      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading dialog

      String errorMessage = 'Error: ${e.message}';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found with this email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email address.';
      }

      ShowMessageHelper.showMessage(context: context, text: errorMessage);
    } catch (e) {
      // print('General error: $e');

      if (!mounted) return;
      Navigator.of(context).pop(); // Close loading dialog

      ShowMessageHelper.showMessage(
          context: context, text: 'An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            BrandColor.dark,
            BrandColor.green,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Receive an email to\nreset your password',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36.0),
              TextFieldEmail(emailController: _emailController),
              const SizedBox(height: 18.0),
              CustomButton(
                  text: 'Reset Password',
                  onPressed: () {
                    if (_emailController.text.isEmpty) {
                      ShowMessageHelper.showMessage(
                          context: context, text: 'Enter a valide email');
                      return;
                    } else if (!_emailController.text.contains('@')) {
                      ShowMessageHelper.showMessage(
                          context: context, text: 'Enter a valide email');
                      return;
                    }

                    resetPassword();
                  })
            ],
          ),
        ),
      ),
    );
  }
}

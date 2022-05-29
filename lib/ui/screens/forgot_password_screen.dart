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
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      ShowMessageHelper.showMessage(
          context: context, text: 'Password reset Email send', isError: false);
      // ignore: use_build_context_synchronously
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);
      ShowMessageHelper.showMessage(
          context: context, text: e.message.toString());
      Navigator.of(context).pop();
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

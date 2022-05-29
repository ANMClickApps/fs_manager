import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fs_manager/ui/screens/pincode_screen.dart';

import '../../style/brand_color.dart';
import '../../util/show_message_helper.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false;
  Timer? timer;
  bool canResendEmail = false;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
          const Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    //call after email verification!
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  Future<void> sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      ShowMessageHelper.showMessage(context: context, text: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return isEmailVerified
        ? const PinCodeScreen()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Verify Email'),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                colors: [
                  BrandColor.dark,
                  BrandColor.green,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ))),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'A verification email has been sent to your email.',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                        onPressed:
                            canResendEmail ? sendVerificationEmail : null,
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0))),
                        child: Ink(
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  BrandColor.green,
                                  BrandColor.dark,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Container(
                            height: 50.0,
                            alignment: Alignment.center,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.mail,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 4.0),
                                  Text(
                                    'Resent Email',
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                    const SizedBox(height: 8.0),
                    TextButton(
                        onPressed: () => FirebaseAuth.instance.signOut(),
                        child: const Text(
                          'Cancel',
                          style:
                              TextStyle(fontSize: 24.0, color: BrandColor.red),
                        ))
                  ],
                ),
              ),
            ),
          );
  }
}

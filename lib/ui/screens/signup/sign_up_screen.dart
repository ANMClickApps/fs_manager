import 'package:flutter/material.dart';
import 'package:fs_manager/ui/screens/signup/sign_up_form.dart';

import '../../../style/brand_color.dart';

class SignUpScreen extends StatelessWidget {
  static const String id = 'signUp';
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            BrandColor.dark,
            BrandColor.green,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
        child: Stack(
          children: [
            Positioned(
                right: -280.0,
                top: -220.0,
                child: Image.asset(
                  'assets/images/bg_card.png',
                  width: 700.0,
                  height: 700.0,
                  fit: BoxFit.fill,
                )),
            const Positioned(
                right: 40.0,
                top: 95.0,
                child: Icon(
                  Icons.lock_outline,
                  color: Colors.white12,
                  size: 60.0,
                )),
            SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 18.0,
                right: 18.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: const SignUpForm(),
            ),
          ],
        ),
      ),
    );
  }
}

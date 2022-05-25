import 'package:flutter/material.dart';
import 'package:fs_manager/style/brand_color.dart';

import 'pincode/pincode_form.dart';

class PinCodeScreen extends StatelessWidget {
  static const String id = 'pincode';
  const PinCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          BrandColor.dark,
          BrandColor.green,
        ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
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
              ),
            ),
            const Positioned(
                top: 95.0,
                right: 40.0,
                child: Icon(
                  Icons.lock_outline,
                  color: Colors.white12,
                  size: 60.0,
                )),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0),
              child: PinCodeForm(),
            ),
          ],
        ),
      ),
    );
  }
}

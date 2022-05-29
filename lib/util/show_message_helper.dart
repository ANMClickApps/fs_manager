import 'package:flutter/material.dart';

import '../../../style/brand_color.dart';

class ShowMessageHelper {
  static showMessage(
      {required BuildContext context,
      required String text,
      bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        ),
      ),
      backgroundColor: isError ? BrandColor.red : BrandColor.green,
    ));
  }
}

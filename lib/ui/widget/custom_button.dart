import 'package:flutter/material.dart';

import '../../style/brand_color.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0))),
              child: Ink(
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        BrandColor.red,
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
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                ),
              )),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../style/brand_color.dart';
import 'account_title.dart';

class AccountTextField extends StatelessWidget {
  final TextEditingController controller;
  final String title;
  final String hintText;

  const AccountTextField(
      {Key? key,
      required this.controller,
      required this.title,
      required this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AccountTitle(
          title: title,
        ),
        SizedBox(
          height: 36.0,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
            ),
            style: const TextStyle(color: BrandColor.dark),
          ),
        ),
        const SizedBox(height: 24.0),
      ],
    );
  }
}

class AccountPasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String title;

  const AccountPasswordField({
    Key? key,
    required this.controller,
    required this.title,
  }) : super(key: key);

  @override
  State<AccountPasswordField> createState() => _AccountPasswordFieldState();
}

class _AccountPasswordFieldState extends State<AccountPasswordField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AccountTitle(
          title: widget.title,
        ),
        SizedBox(
            height: 36.0,
            child: TextField(
              controller: widget.controller,
              obscureText: _obscureText,
              style: const TextStyle(color: BrandColor.dark),
              decoration: InputDecoration(
                  hintText: '********',
                  suffixIcon: IconButton(
                      onPressed: () => setState(() {
                            _obscureText = !_obscureText;
                          }),
                      icon: Icon(_obscureText
                          ? Icons.visibility_off
                          : Icons.visibility))),
            )),
        const SizedBox(height: 24.0),
      ],
    );
  }
}

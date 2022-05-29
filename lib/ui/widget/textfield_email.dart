import 'package:flutter/material.dart';

class TextFieldEmail extends StatelessWidget {
  const TextFieldEmail({
    Key? key,
    required TextEditingController emailController,
  })  : _emailController = emailController,
        super(key: key);

  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _emailController,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        labelStyle: TextStyle(color: Colors.white70),
        floatingLabelStyle: TextStyle(color: Colors.white70),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white70),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white70),
        ),
        labelText: 'Email',
        prefixIcon: Icon(
          Icons.email,
          color: Colors.white70,
        ),
      ),
    );
  }
}

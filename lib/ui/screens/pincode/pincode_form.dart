import 'package:flutter/material.dart';
import 'package:fs_manager/ui/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../style/brand_color.dart';

class PinCodeForm extends StatefulWidget {
  const PinCodeForm({Key? key}) : super(key: key);

  @override
  State<PinCodeForm> createState() => _PinCodeFormState();
}

class _PinCodeFormState extends State<PinCodeForm> {
  late TextEditingController _controller;
  bool visibility = true;
  bool _hasPin = false;

  @override
  void initState() {
    _controller = TextEditingController();
    checkPin();
    super.initState();
  }

  Future<void> checkPin() async {
    final prefs = await SharedPreferences.getInstance();
    final String? pinCode = prefs.getString('pin');
    if (pinCode != null) {
      setState(() {
        _hasPin = true;
      });
    }
  }

  showMessage(String text, [isError = false]) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        style: TextStyle(
          color: isError ? Colors.white : BrandColor.dark,
        ),
      ),
      backgroundColor: isError ? BrandColor.red : BrandColor.green,
    ));
  }

  Future<void> makePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setString('pin', pin);
      goHome();
    } catch (e) {
      showMessage('Something went wrong: $e', true);
    }

    // if (value != null) {
    //   showMessage('PIN code created successfully');
    // } else {
    //   showMessage('Something went wrong...', true);
    // }
  }

  void goHome() {
    Navigator.pushNamedAndRemoveUntil(context, HomeScreen.id, (route) => false);
  }

  void checkCorrectPIN(String pin) {}

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _hasPin ? 'Type,\nPIN Now.' : 'Make,\nPIN Now.',
          style: const TextStyle(
            fontSize: 36.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 18.0),
        const Text(
          'To decrypt account records, you must enter your PIN correctly!',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 80.0),
        TextField(
          controller: _controller,
          style: const TextStyle(color: Colors.white),
          obscureText: visibility,
          decoration: InputDecoration(
            labelStyle: const TextStyle(color: Colors.white70),
            floatingLabelStyle: const TextStyle(color: Colors.white70),
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white70),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white70),
            ),
            labelText: 'PIN',
            prefixIcon: const Icon(
              Icons.password,
              color: Colors.white70,
            ),
            suffixIcon: IconButton(
              onPressed: (() => setState(() {
                    visibility = !visibility;
                  })),
              icon: Icon(
                visibility ? Icons.visibility : Icons.visibility_off,
                color: Colors.white70,
              ),
            ),
          ),
        ),
        const SizedBox(height: 18.0),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _hasPin
                    ? checkCorrectPIN(_controller.text.trim())
                    : makePin(_controller.text.trim()),
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
                          end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(12.0)),
                  child: Container(
                    // width: 300,
                    height: 50.0,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        _hasPin ? 'Next' : 'Make PIN',
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

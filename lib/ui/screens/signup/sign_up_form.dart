import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../style/brand_color.dart';
import '../../../util/show_message_helper.dart';
import '../login/login_screens.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _passwordConfirmController;
  bool _visibility = true;
  bool _visibilityConf = true;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      ShowMessageHelper.showMessage(context: context, text: 'Check Email');
      return;
    } else if (_passwordController.text.isEmpty ||
        _passwordController.text.length < 8) {
      ShowMessageHelper.showMessage(
          context: context,
          text: 'Check password, password must be greater than 8');
      return;
    } else if (_passwordController.text != _passwordConfirmController.text) {
      ShowMessageHelper.showMessage(
          context: context,
          text: 'Check password, password does not match confirmed');
      return;
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    try {
      //if you need sign up
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (credential.user != null) {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const RootScreen()),
            (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ShowMessageHelper.showMessage(
            context: context, text: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        ShowMessageHelper.showMessage(
            context: context, text: 'email-already-in-use');
      }
    } catch (e) {
      ShowMessageHelper.showMessage(context: context, text: 'Error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.15),
        const Text(
          'Hey There,\nWelcome Back.',
          style: TextStyle(
              fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 18.0),
        const Text(
          'Welcome to FManager, please make your profile credentials below to start using the app',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 80.0),
        TextField(
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
        ),
        const SizedBox(height: 8.0),
        TextField(
          controller: _passwordController,
          obscureText: _visibility,
          style: const TextStyle(color: Colors.white),
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
            labelText: 'Password',
            prefixIcon: const Icon(
              Icons.password,
              color: Colors.white70,
            ),
            suffixIcon: IconButton(
              onPressed: () => setState(() {
                _visibility = !_visibility;
              }),
              icon: Icon(
                _visibility ? Icons.visibility_off : Icons.visibility,
                color: Colors.white70,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        TextField(
          controller: _passwordConfirmController,
          obscureText: _visibilityConf,
          style: const TextStyle(color: Colors.white),
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
            labelText: 'Confirm password',
            prefixIcon: const Icon(
              Icons.password,
              color: Colors.white70,
            ),
            suffixIcon: IconButton(
              onPressed: () => setState(() {
                _visibilityConf = !_visibilityConf;
              }),
              icon: Icon(
                _visibility ? Icons.visibility_off : Icons.visibility,
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
                  onPressed: _signUp,
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
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ),
                    ),
                  )),
            )
          ],
        ),
        const SizedBox(height: 18.0),
        GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen())),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: const TextSpan(
                  text: 'Already have an account? ',
                  style: TextStyle(color: Colors.white70, fontSize: 16.0),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Login',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../style/brand_color.dart';
import '../../widget/textfield_email.dart';
import '../forgot_password_screen.dart';
import '../pincode_screen.dart';
import '../signup/sign_up_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _visibility = true;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      if (credential.user != null) {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const PinCodeScreen()),
            (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showMessage('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showMessage('Wrong password provided for that user.');
      }
    }

    // try {
    //   //if you need sign up
    //   final credential =
    //       await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //     email: _emailController.text.trim(),
    //     password: _passwordController.text.trim(),
    //   );

    //   if (credential.user != null) {
    //     if (!mounted) return;
    //     Navigator.pushAndRemoveUntil(
    //         context,
    //         MaterialPageRoute(builder: (_) => const PinCodeScreen()),
    //         (route) => false);
    //   }
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'weak-password') {
    //     print('The password provided is too weak.');
    //     showMessage('The password provided is too weak.');
    //   } else if (e.code == 'email-already-in-use') {
    //     showMessage('email-already-in-use');
    //   }
    // } catch (e) {
    //   print(e);
    //   showMessage('Error $e');
    // }
  }

  showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.15),
        const Text(
          'Hey,\nLogin Now.',
          style: TextStyle(
              fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 18.0),
        const Text(
          'Welcome to FManager, please put your login credentials below to start using the app',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 80.0),
        TextFieldEmail(emailController: _emailController),
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
        const SizedBox(height: 18.0),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                  onPressed: _login,
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
                          'Login',
                          style: TextStyle(fontSize: 18.0, color: Colors.white),
                        ),
                      ),
                    ),
                  )),
            )
          ],
        ),
        const SizedBox(height: 24.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen()));
              },
              child: const Text(
                'Forgot Password',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SignUpScreen())),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: const TextSpan(
                  text: 'Don\'t have an account, yet? ',
                  style: TextStyle(color: Colors.white70, fontSize: 16.0),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Sign Up',
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

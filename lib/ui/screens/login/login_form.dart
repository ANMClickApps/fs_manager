import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fs_manager/style/brand_color.dart';
import 'package:fs_manager/ui/screens/pincode_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool visibility = true;

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

  Future<void> login() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());

      if (credential.user != null) {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: ((context) => const PinCodeScreen())),
            (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No user found for that email.')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Wrong password provided for that user.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hey,\nLogin Now.',
          style: TextStyle(
            fontSize: 36.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
              )),
        ),
        const SizedBox(height: 8.0),
        TextField(
          controller: _passwordController,
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
            labelText: 'Password',
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
              child:
                  // ElevatedButton(
                  //     style: ButtonStyle(
                  //         backgroundColor:
                  //             MaterialStateProperty.all<Color>(BrandColor.red)),
                  //     onPressed: login,
                  //     child: const Padding(
                  //       padding: EdgeInsets.symmetric(vertical: 16.0),
                  //       child: Text('Login'),
                  //     )),
                  ElevatedButton(
                onPressed: login,
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
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 18.0),
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

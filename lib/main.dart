import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fs_manager/ui/screens/home_screen.dart';
import 'package:fs_manager/ui/screens/pincode_screen.dart';
import 'package:fs_manager/ui/screens/account_tab.dart';
import 'ui/screens/login/login_screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FKeys',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: {
        HomeScreen.id: (context) => const HomeScreen(),
        AccountsTab.id: (context) => const AccountsTab(),
        LoginScreen.id: (context) => const LoginScreen(),
        PinCodeScreen.id: (context) => const PinCodeScreen(),
      },
      home: const RootScreen(),
    );
  }
}

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int state = -1;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          state = 0;
        });
      } else {
        setState(() {
          state = 1;
        });
      }
    });
  }

  Widget getBody() {
    if (state == 0) {
      return const LoginScreen();
    } else if (state == 1) {
      return const PinCodeScreen();
    }

    return const Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }
}

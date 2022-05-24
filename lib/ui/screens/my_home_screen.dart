import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:fs_manager/data/account_logo.dart';
import 'package:fs_manager/data/model/records_model.dart';
import 'package:fs_manager/style/brand_color.dart';
import 'package:fs_manager/ui/screens/login/login_screens.dart';

import '../widget/account_widget.dart';
import 'add_account_screen.dart';

class MyHomeScreen extends StatefulWidget {
  static const String id = 'home';
  const MyHomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomeScreen> {
  late TextEditingController _searchController;
  //late StreamSubscription _streamSubscription;
  late DatabaseReference _ref;

  @override
  void initState() {
    _searchController = TextEditingController();
    // _activateLicteners();
    getRef();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.clear();
    super.dispose();
  }

  getRef() {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    _ref = FirebaseDatabase.instance.ref().child('users/$uid');
  }

  String _getImage(String logoValue) {
    for (var account in accountsList) {
      if (account.title == logoValue) {
        return account.accountImage;
      }
    }
    return 'assets/icons/github.svg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FKeys'),
        leading: IconButton(
          icon: const Icon(Icons.dashboard),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginScreen.id, (route) => false);
            },
            icon: const Icon(
              Icons.logout,
              size: 24.0,
            ),
          ),
          const SizedBox(
            width: 18.0,
          )
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [BrandColor.dark, BrandColor.green, BrandColor.dark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: BrandColor.greyLight,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(borderSide: BorderSide.none),
                    labelText: 'Type web site',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Expanded(
              child: FirebaseAnimatedList(
                  query: _ref,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    final json = snapshot.value as Map;
                    RecordModel model = RecordModel.fromMap(json);
                    return InkWell(
                      onTap: (() => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddAccountScreen(model: model)))),
                      child: AccountWidget(
                        iconPath: _getImage(model.logoValue),
                        name: model.name,
                        userName: model.username,
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: BrandColor.green,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddAccountScreen()));
        },
        tooltip: 'Add account',
        child: const Icon(Icons.add),
      ),
    );
  }
}

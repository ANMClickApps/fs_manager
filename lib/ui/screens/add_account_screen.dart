import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fs_manager/data/db_helper.dart';
import 'package:fs_manager/data/model/records_model.dart';
import 'package:fs_manager/style/brand_color.dart';
import '../../data/account_logo.dart';
import '../widget/account_action.dart';
import '../widget/account_textfield.dart';
import '../widget/account_title.dart';
import 'my_home_screen.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({Key? key, this.model}) : super(key: key);
  final RecordModel? model;

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen> {
  late String selectedValue;
  late TextEditingController _nameController;
  late TextEditingController _userNameController;
  late TextEditingController _passwordController;
  late TextEditingController _webSiteController;
  late TextEditingController _tagController;
  List<String> _tags = [];
  late bool _isShowData;

  @override
  void initState() {
    selectedValue = accountsList[0].title;
    _userNameController = TextEditingController();
    _nameController = TextEditingController();
    _webSiteController = TextEditingController();
    _passwordController = TextEditingController();
    _tagController = TextEditingController();
    _isShowData = false;

    getModelData();

    super.initState();
  }

  @override
  void dispose() {
    _userNameController.clear();
    _nameController.clear();
    _webSiteController.clear();
    _passwordController.clear();
    _tagController.clear();
    super.dispose();
  }

  showMessage({required String text, isError = true}) {
    final snackBar = SnackBar(
      backgroundColor: isError ? BrandColor.red : BrandColor.green,
      content: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _saveRecord() {
    String? userUID = FirebaseAuth.instance.currentUser?.uid;
    if (userUID != null) {
      DBHelper.insertRecord(
        uid: userUID,
        logoValue: selectedValue,
        name: _nameController.text.trim(),
        userName: _userNameController.text.trim(),
        password: _passwordController.text.trim(),
        webSite: _webSiteController.text.trim(),
        tags: _tags,
      );
      Future.delayed(
          const Duration(milliseconds: 500),
          (() => Navigator.pushNamedAndRemoveUntil(
              context, MyHomeScreen.id, (route) => false)));
    } else {
      showMessage(text: 'Something wront with User');
    }
  }

  void getModelData() {
    if (widget.model != null) {
      setState(() {
        _nameController.text = widget.model!.name;
        _userNameController.text = widget.model!.username;
        _passwordController.text = widget.model!.password;
        _webSiteController.text = widget.model!.webSite;
        _tags.addAll(widget.model!.tag);
        selectedValue = widget.model!.logoValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const AccountTitle(
                  title: 'Account:',
                  isPadding: true,
                ),
                _buildDropDownButton(),
                const SizedBox(height: 12.0),
                AccountTextField(
                  controller: _nameController,
                  title: 'Name',
                  hintText: 'Alex Filatov',
                ),
                AccountTextField(
                  controller: _userNameController,
                  title: 'Username(Email)',
                  hintText: 'anmclick@gmail.com',
                ),
                AccountPasswordField(
                  controller: _passwordController,
                  title: 'Password',
                ),
                AccountTextField(
                  controller: _webSiteController,
                  title: 'Website',
                  hintText: 'https://google.com',
                ),
                const SizedBox(height: 12.0),
                _buildTagRow(),
                _buildSaveButton(),
                if (_isShowData) _buildCRUDButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildSaveButton() {
    return Row(
      children: [
        Expanded(
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(BrandColor.green)),
                onPressed: () {
                  if (_nameController.text.isEmpty) {
                    showMessage(text: 'Please, check "Name"!');
                    return;
                  } else if (_userNameController.text.isEmpty) {
                    showMessage(text: 'Please, check "Username"!');
                    return;
                  } else if (_passwordController.text.isEmpty) {
                    showMessage(text: 'Please, check "Password"!');
                    return;
                  } else if (_webSiteController.text.isEmpty) {
                    showMessage(text: 'Please, check "Website"!');
                    return;
                  } else if (_tags.isEmpty) {
                    showMessage(text: 'Please, add at least one "Tag"!');
                    return;
                  }
                  _saveRecord();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text('Save'),
                )))
      ],
    );
  }

  Column _buildCRUDButton() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AccountAction(
              title: 'copy Username',
              iconData: Icons.copy,
              onPressed: () {},
            ),
            AccountAction(
              title: 'copy Password',
              iconData: Icons.copy,
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        AccountAction(
          title: 'Delete record',
          iconData: Icons.delete_outline,
          isDelete: true,
          onPressed: () {},
        ),
      ],
    );
  }

  Column _buildTagRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AccountTitle(
          title: 'Tags',
        ),
        SizedBox(
          height: 36.0,
          child: TextField(
            controller: _tagController,
            onChanged: (text) {
              if (text.contains(',')) {
                List data = text.split(',');
                setState(() {
                  _tags.add(data[0]);
                  _tagController.clear();
                });
              }
            },
            decoration: const InputDecoration(
              hintText: 'google, account, gmail ...',
            ),
            style: const TextStyle(color: BrandColor.dark),
          ),
        ),
        SizedBox(
          height: 50.0,
          child: ListView.builder(
              shrinkWrap: false,
              scrollDirection: Axis.horizontal,
              itemCount: _tags.length,
              itemBuilder: ((context, index) => InkWell(
                    onTap: () => setState(() {
                      _tags.removeAt(index);
                    }),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 4.0, 8.0, 4.0),
                      decoration: BoxDecoration(
                        color: BrandColor.greenBlue,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _tags[index],
                          style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ))),
        ),
        const SizedBox(height: 24.0),
      ],
    );
  }

  Row _buildDropDownButton() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
                hint: const Text('Select Account'),
                value: selectedValue,
                itemHeight: 60.0,
                items: accountsList
                    .map((account) => DropdownMenuItem<String>(
                        value: account.title,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  height: 48.0,
                                  width: 48.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        12.0,
                                      ),
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                          offset: Offset(0, 4),
                                          blurRadius: 4.0,
                                          spreadRadius: 0,
                                          color: Colors.black26,
                                        )
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                        SvgPicture.asset(account.accountImage),
                                  )),
                              const SizedBox(width: 12.0),
                              Text(
                                account.title,
                                style: const TextStyle(color: BrandColor.dark),
                              )
                            ],
                          ),
                        )))
                    .toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedValue = newValue;
                    });
                  }
                }),
          ),
        )
      ],
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fs_manager/data/db_helper.dart';
import 'package:fs_manager/data/model/records_model.dart';
import 'package:fs_manager/style/brand_color.dart';
import 'package:fs_manager/ui/screens/home_screen.dart';
import '../../data/account_logo.dart';
import '../widget/account_action.dart';
import '../widget/account_textfield.dart';
import '../widget/account_title.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen(
      {Key? key, this.model, this.id, this.isShowData = false})
      : super(key: key);
  final RecordModel? model;
  final bool isShowData;
  final String? id;

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
  List<String> tags = [];
  late bool _isShowData;

  @override
  void initState() {
    selectedValue = accountsList[0].title;
    _userNameController = TextEditingController();
    _nameController = TextEditingController();
    _webSiteController = TextEditingController();
    _passwordController = TextEditingController();
    _tagController = TextEditingController();
    _isShowData = widget.isShowData;
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
      // Якщо є ID - оновлюємо існуючий запис, якщо немає - створюємо новий
      if (widget.id != null) {
        DBHelper.updateRecord(
          uid: userUID,
          recordId: widget.id!,
          logoValue: selectedValue,
          name: _nameController.text.trim(),
          userName: _userNameController.text.trim(),
          password: _passwordController.text.trim(),
          webSite: _webSiteController.text.trim(),
          tags: tags,
        );
      } else {
        DBHelper.insertRecord(
          uid: userUID,
          logoValue: selectedValue,
          name: _nameController.text.trim(),
          userName: _userNameController.text.trim(),
          password: _passwordController.text.trim(),
          webSite: _webSiteController.text.trim(),
          tags: tags,
        );
      }
      Future.delayed(
          const Duration(milliseconds: 500),
          (() => Navigator.pushNamedAndRemoveUntil(
              context, HomeScreen.id, (route) => false)));
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
        tags.addAll(widget.model!.tag);
        selectedValue = widget.model!.logoValue;
      });
    }
  }

  sayWellDone() {
    showMessage(text: 'Moved to trash', isError: false);
    Future.delayed(
        const Duration(milliseconds: 500),
        (() => Navigator.pushNamedAndRemoveUntil(
            context, HomeScreen.id, (route) => false)));
  }

  void _showMoveToTrashDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Move to Trash?'),
        content: Text(
            'Move "${_nameController.text}" to trash? You can restore it later from Settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: BrandColor.red),
            onPressed: () {
              Navigator.pop(context);
              _moveToTrash();
            },
            child: const Text('Move to Trash',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _moveToTrash() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || widget.id == null) {
      showMessage(text: 'Error: Cannot move to trash');
      return;
    }

    try {
      // Отримуємо дані запису
      final snapshot = await FirebaseDatabase.instance
          .ref()
          .child('users/$uid/${widget.id}')
          .get();

      if (snapshot.exists) {
        // Переносимо в корзину
        await FirebaseDatabase.instance
            .ref()
            .child('trash/$uid')
            .push()
            .set(snapshot.value);

        // Видаляємо з users
        await FirebaseDatabase.instance
            .ref()
            .child('users/$uid/${widget.id}')
            .remove();

        sayWellDone();
      }
    } catch (e) {
      showMessage(text: 'Error moving to trash: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: _isShowData
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: BrandColor.dark),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: Text(
          _isShowData ? 'Account Info' : 'Create Account',
          style: const TextStyle(
            color: BrandColor.dark,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18.0, 24.0, 18.0, 0),
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
                  hintText: 'Alex Smith',
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
                const SizedBox(height: 18.0),
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
                  // Перевірка обов'язкових полів
                  if (_nameController.text.isEmpty) {
                    showMessage(
                        text: '📝 Name is required to identify this account');
                    return;
                  } else if (_userNameController.text.isEmpty) {
                    showMessage(text: '✉️ Username or Email cannot be empty');
                    return;
                  } else if (_passwordController.text.isEmpty) {
                    showMessage(text: '🔒 Password is required for security');
                    return;
                  }

                  // Перевірка необов'язкових полів
                  List<String> emptyFields = [];
                  if (_webSiteController.text.isEmpty) {
                    emptyFields.add('Website');
                  }
                  if (tags.isEmpty) {
                    emptyFields.add('Tags');
                  }

                  // Якщо є порожні необов'язкові поля - показуємо діалог
                  if (emptyFields.isNotEmpty) {
                    _showConfirmationDialog(emptyFields);
                  } else {
                    _saveRecord();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    widget.id != null ? 'Update' : 'Save',
                    style: const TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                )))
      ],
    );
  }

  void _showConfirmationDialog(List<String> emptyFields) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.id != null ? 'Confirm Update' : 'Confirm Save'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('The following optional fields are empty:'),
              const SizedBox(height: 8.0),
              ...emptyFields.map((field) => Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                    child: Text('• $field',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  )),
              const SizedBox(height: 12.0),
              const Text('Do you want to continue without filling them?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: BrandColor.green,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _saveRecord();
              },
              child: Text(
                widget.id != null ? 'Update Anyway' : 'Save Anyway',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Column _buildCRUDButton() {
    return Column(
      children: [
        const SizedBox(height: 18.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AccountAction(
              title: 'copy Username',
              iconData: Icons.copy,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _userNameController.text))
                    .then((_) {
                  showMessage(
                      text: 'Username copied to clipboard', isError: false);
                });
              },
            ),
            AccountAction(
              title: 'copy Password',
              iconData: Icons.copy,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _passwordController.text))
                    .then((_) {
                  showMessage(
                      text: 'Password copied to clipboard', isError: false);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 12.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AccountAction(
              title: 'login+password',
              iconData: Icons.copy,
              onPressed: () {
                Clipboard.setData(ClipboardData(
                        text:
                            'username: ${_userNameController.text}\npassword: ${_passwordController.text}'))
                    .then((_) {
                  showMessage(
                      text: 'Username and Password copied to clipboard',
                      isError: false);
                });
              },
            ),
            AccountAction(
              title: 'Move to Trash',
              iconData: Icons.delete_outline,
              isDelete: true,
              onPressed: () => _showMoveToTrashDialog(),
            ),
          ],
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
                  tags.add(data[0]);
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
              itemCount: tags.length,
              itemBuilder: ((context, index) => InkWell(
                    onTap: () => setState(() {
                      tags.removeAt(index);
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
                          tags[index],
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
                isExpanded: true,
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
                                  margin: const EdgeInsets.only(left: 4.0),
                                  height: 48.0,
                                  width: 48.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      color: account.color.withOpacity(0.1),
                                      border: Border.all(
                                        color: account.color.withOpacity(0.3),
                                        width: 1,
                                      )),
                                  child: Icon(
                                    account.iconData,
                                    color: account.color,
                                    size: 24.0,
                                  )),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Text(
                                  account.title,
                                  style:
                                      const TextStyle(color: BrandColor.dark),
                                  overflow: TextOverflow.ellipsis,
                                ),
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

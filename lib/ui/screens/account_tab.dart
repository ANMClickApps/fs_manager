import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fs_manager/data/account_logo.dart';
import 'package:fs_manager/data/model/records_model.dart';
import 'package:fs_manager/data/my_encryption.dart';
import 'package:fs_manager/style/brand_color.dart';
import '../widget/account_widget.dart';
import 'add_account_screen.dart';

class AccountsTab extends StatefulWidget {
  static const String id = 'accounts';
  const AccountsTab({
    Key? key,
  }) : super(key: key);

  @override
  State<AccountsTab> createState() => _AccountsTabState();
}

class _AccountsTabState extends State<AccountsTab> {
  late TextEditingController _searchController;
  late DatabaseReference _ref;
  late Future<RecordModel> dataFuture;
  List<AccountRec> recordList = [];
  String noDataText = 'No data available.';
  String query = '';
  bool noData = true;
  int countSeacrh = 0;
  @override
  void initState() {
    _searchController = TextEditingController();
    getdataFromFB();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.clear();
    super.dispose();
  }

  getdataFromFB() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    _ref = FirebaseDatabase.instance.ref().child('users/$uid');

    final snapshot = await _ref.get();
    if (snapshot.exists) {
      setState(() {
        noData = false;
      });
      var data = snapshot.children
          .map((e) => AccountRec(
                id: e.key.toString(),
                model: RecordModel.fromMap(e.value as Map),
              ))
          .toList();
      for (var item in data) {
        updateRecordList(item.model, item.id);
      }
    } else {
      setState(() {
        noData = true;
      });
    }
  }

  String _getImage(String logoValue) {
    for (var account in accountsList) {
      if (account.title == logoValue) {
        return account.accountImage;
      }
    }
    return 'assets/icons/github.svg';
  }

  Future<void> updateRecordList(RecordModel model, String id) async {
    String decLogoValue =
        await MyEncriptionDecription.decryptAES(model.logoValue);
    String decName = await MyEncriptionDecription.decryptAES(model.name);
    String decPassword =
        await MyEncriptionDecription.decryptAES(model.password);
    String decUsername =
        await MyEncriptionDecription.decryptAES(model.username);
    String decWebSite = await MyEncriptionDecription.decryptAES(model.webSite);

    Future<List<String>> getList() async {
      List<String> data = [];
      for (var e in model.tag) {
        var res = await MyEncriptionDecription.decryptAES(e);
        data.add(res.toString());
      }
      return data;
    }

    List<String> decTags = await getList();

    setState(() {
      recordList.add(AccountRec(
          id: id,
          model: RecordModel(
              logoValue: decLogoValue,
              name: decName,
              password: decPassword,
              username: decUsername,
              webSite: decWebSite,
              tag: decTags)));
    });
  }

  void searchRecord(String query) {
    List<AccountRec> suggestions = [];
    final input = query.toUpperCase();
    int count = 0;

    for (var record in recordList) {
      count++;

      List<String> tags = [];
      tags = record.model.tag.map((e) {
        return e.toUpperCase();
      }).toList();

      for (var t in tags) {
        if (t.contains(input)) {
          suggestions.add(record);
        }
      }
    }

    setState(() {
      this.query = query;
      recordList = suggestions;
      countSeacrh = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
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
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: searchRecord,
                    onSubmitted: (text) {
                      if (text.isEmpty) {
                        recordList.clear();
                        getdataFromFB();
                      }
                    },
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(borderSide: BorderSide.none),
                      labelText: 'Type tag',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              Expanded(
                  child: noData
                      ? Text(noDataText)
                      : recordList.isEmpty
                          ? const Text(
                              'Loading...',
                              style: TextStyle(color: BrandColor.dark),
                            )
                          : ListView.builder(
                              itemCount: recordList.length,
                              itemBuilder: (context, index) {
                                return MaterialButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddAccountScreen(
                                                    model:
                                                        recordList[index].model,
                                                    isShowData: true,
                                                    id: recordList[index].id,
                                                  )));
                                    },
                                    child: AccountWidget(
                                      iconPath: _getImage(
                                          recordList[index].model.logoValue),
                                      name: recordList[index].model.name,
                                      userName:
                                          recordList[index].model.username,
                                    ));
                              }))
            ],
          ),
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

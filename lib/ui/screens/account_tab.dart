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
  Set<String> selectedRecords = {};
  bool isSelectionMode = false;
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
        await updateRecordList(item.model, item.id);
      }
    } else {
      setState(() {
        noData = true;
      });
    }
  }

  // Функція для очищення всіх записів (тимчасово для міграції)
  Future<void> clearAllRecords() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseDatabase.instance.ref().child('users/$uid').remove();
      setState(() {
        recordList.clear();
        noData = true;
      });
      // print('All records cleared!');
    }
  }

  void toggleSelection(String recordId) {
    setState(() {
      if (selectedRecords.contains(recordId)) {
        selectedRecords.remove(recordId);
        if (selectedRecords.isEmpty) {
          isSelectionMode = false;
        }
      } else {
        selectedRecords.add(recordId);
      }
    });
  }

  void selectAll() {
    setState(() {
      selectedRecords = recordList.map((e) => e.id).toSet();
    });
  }

  void deselectAll() {
    setState(() {
      selectedRecords.clear();
      isSelectionMode = false;
    });
  }

  Future<void> moveSelectedToTrash() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || selectedRecords.isEmpty) return;

    try {
      for (String recordId in selectedRecords) {
        // Отримуємо дані запису
        final snapshot = await FirebaseDatabase.instance
            .ref()
            .child('users/$uid/$recordId')
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
              .child('users/$uid/$recordId')
              .remove();
        }
      }

      // Оновлюємо список
      setState(() {
        recordList.removeWhere((record) => selectedRecords.contains(record.id));
        selectedRecords.clear();
        isSelectionMode = false;
        if (recordList.isEmpty) {
          noData = true;
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Moved to trash'),
            backgroundColor: BrandColor.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: BrandColor.red,
          ),
        );
      }
    }
  }

  void showMoveToTrashDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Move to Trash?'),
        content: Text(
            'Move ${selectedRecords.length} account(s) to trash? You can restore them later from Settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: BrandColor.red),
            onPressed: () {
              Navigator.pop(context);
              moveSelectedToTrash();
            },
            child: const Text('Move to Trash',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  AccountLogo _getAccountLogo(String logoValue) {
    for (var account in accountsList) {
      if (account.title.toLowerCase() == logoValue.toLowerCase()) {
        return account;
      }
    }

    // Default fallback
    return accountsList.firstWhere(
      (account) => account.title == 'Custom',
      orElse: () => accountsList.first,
    );
  }

  Future<void> updateRecordList(RecordModel model, String id) async {
    try {
      String decLogoValue =
          await MyEncriptionDecription.decryptAES(model.logoValue);
      String decName = await MyEncriptionDecription.decryptAES(model.name);
      String decPassword =
          await MyEncriptionDecription.decryptAES(model.password);
      String decUsername =
          await MyEncriptionDecription.decryptAES(model.username);
      String decWebSite =
          await MyEncriptionDecription.decryptAES(model.webSite);

      Future<List<String>> getList() async {
        List<String> data = [];
        for (var e in model.tag) {
          try {
            var res = await MyEncriptionDecription.decryptAES(e);
            if (res.isNotEmpty) {
              data.add(res.toString());
            }
          } catch (e) {
            // print('Error decrypting tag: $e');
            // Пропускаємо пошкоджений тег
          }
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
    } catch (e) {
      // print('Error decrypting record $id: $e');
      // Пропускаємо пошкоджений запис
    }
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
      appBar: isSelectionMode
          ? AppBar(
              backgroundColor: BrandColor.green,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: deselectAll,
              ),
              title: Text(
                '${selectedRecords.length} selected',
                style: const TextStyle(color: Colors.white),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.select_all, color: Colors.white),
                  onPressed: selectAll,
                  tooltip: 'Select All',
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.white),
                  onPressed:
                      selectedRecords.isEmpty ? null : showMoveToTrashDialog,
                  tooltip: 'Move to Trash',
                ),
              ],
            )
          : null,
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
                                final record = recordList[index];
                                final isSelected =
                                    selectedRecords.contains(record.id);
                                return InkWell(
                                  onTap: () {
                                    if (isSelectionMode) {
                                      toggleSelection(record.id);
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddAccountScreen(
                                                    model: record.model,
                                                    isShowData: true,
                                                    id: record.id,
                                                  )));
                                    }
                                  },
                                  onLongPress: () {
                                    setState(() {
                                      isSelectionMode = true;
                                      selectedRecords.add(record.id);
                                    });
                                  },
                                  child: Container(
                                    color: isSelected
                                        ? BrandColor.green.withOpacity(0.1)
                                        : Colors.transparent,
                                    child: Row(
                                      children: [
                                        if (isSelectionMode)
                                          Checkbox(
                                            value: isSelected,
                                            onChanged: (value) =>
                                                toggleSelection(record.id),
                                            activeColor: BrandColor.green,
                                          ),
                                        Expanded(
                                          child: AccountWidget(
                                            accountLogo: _getAccountLogo(
                                                record.model.logoValue),
                                            name: record.model.name,
                                            userName: record.model.username,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
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
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

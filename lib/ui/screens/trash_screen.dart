import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fs_manager/data/account_logo.dart';
import 'package:fs_manager/data/model/records_model.dart';
import 'package:fs_manager/data/my_encryption.dart';
import 'package:fs_manager/style/brand_color.dart';
import '../widget/account_widget.dart';

class TrashScreen extends StatefulWidget {
  const TrashScreen({Key? key}) : super(key: key);

  @override
  State<TrashScreen> createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen> {
  late DatabaseReference _ref;
  List<AccountRec> trashedRecords = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTrashedData();
  }

  Future<void> loadTrashedData() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      _ref = FirebaseDatabase.instance.ref().child('trash/$uid');
      final snapshot = await _ref.get();

      if (snapshot.exists && snapshot.value != null) {
        // Перевіряємо чи це Map (а не String або інший тип)
        if (snapshot.value is Map) {
          var data = snapshot.children
              .map((e) {
                try {
                  if (e.value is Map) {
                    return AccountRec(
                      id: e.key.toString(),
                      model: RecordModel.fromMap(e.value as Map),
                    );
                  }
                  return null;
                } catch (e) {
                  // print('Error parsing record: $e');
                  return null;
                }
              })
              .whereType<AccountRec>()
              .toList();

          for (var item in data) {
            await updateRecordList(item.model, item.id);
          }
        }
      }
    } catch (e) {
      // print('Error loading trashed data: $e');
    }

    setState(() {
      isLoading = false;
    });
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
            // Пропускаємо пошкоджений тег
          }
        }
        return data;
      }

      List<String> decTags = await getList();

      setState(() {
        trashedRecords.add(AccountRec(
            id: id,
            model: RecordModel(
              logoValue: decLogoValue,
              name: decName,
              password: decPassword,
              username: decUsername,
              webSite: decWebSite,
              tag: decTags,
            )));
      });
    } catch (e) {
      // print('Error decrypting trashed record $id: $e');
    }
  }

  AccountLogo _getAccountLogo(String logoValue) {
    for (var account in accountsList) {
      if (account.title.toLowerCase() == logoValue.toLowerCase()) {
        return account;
      }
    }
    return accountsList.firstWhere(
      (account) => account.title == 'Custom',
      orElse: () => accountsList.first,
    );
  }

  Future<void> restoreRecord(String recordId, RecordModel model) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      // Отримуємо зашифровані дані з корзини
      final snapshot = await FirebaseDatabase.instance
          .ref()
          .child('trash/$uid/$recordId')
          .get();

      if (snapshot.exists) {
        // Переносимо назад у users
        await FirebaseDatabase.instance
            .ref()
            .child('users/$uid')
            .push()
            .set(snapshot.value);

        // Видаляємо з корзини
        await FirebaseDatabase.instance
            .ref()
            .child('trash/$uid/$recordId')
            .remove();

        setState(() {
          trashedRecords.removeWhere((item) => item.id == recordId);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Record restored successfully'),
              backgroundColor: BrandColor.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error restoring record: $e'),
            backgroundColor: BrandColor.red,
          ),
        );
      }
    }
  }

  Future<void> permanentlyDeleteRecord(String recordId) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      await FirebaseDatabase.instance
          .ref()
          .child('trash/$uid/$recordId')
          .remove();

      setState(() {
        trashedRecords.removeWhere((item) => item.id == recordId);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Record permanently deleted'),
            backgroundColor: BrandColor.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting record: $e'),
            backgroundColor: BrandColor.red,
          ),
        );
      }
    }
  }

  Future<void> emptyTrash() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      await FirebaseDatabase.instance.ref().child('trash/$uid').remove();
      setState(() {
        trashedRecords.clear();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Trash emptied successfully'),
            backgroundColor: BrandColor.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error emptying trash: $e'),
            backgroundColor: BrandColor.red,
          ),
        );
      }
    }
  }

  void showDeleteDialog(String recordId, String accountName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permanently Delete?'),
        content: Text(
            'Are you sure you want to permanently delete "$accountName"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: BrandColor.red),
            onPressed: () {
              Navigator.pop(context);
              permanentlyDeleteRecord(recordId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void showEmptyTrashDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Empty Trash?'),
        content: const Text(
            'Are you sure you want to permanently delete all items in trash? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: BrandColor.red),
            onPressed: () {
              Navigator.pop(context);
              emptyTrash();
            },
            child: const Text('Empty Trash',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: BrandColor.dark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Trash',
          style: TextStyle(
            color: BrandColor.dark,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (trashedRecords.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever, color: BrandColor.red),
              onPressed: showEmptyTrashDialog,
              tooltip: 'Empty Trash',
            ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : trashedRecords.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete_outline,
                              size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Trash is empty',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: trashedRecords.length,
                      itemBuilder: (context, index) {
                        final record = trashedRecords[index];
                        return Dismissible(
                          key: Key(record.id),
                          background: Container(
                            color: BrandColor.green,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            child: const Icon(Icons.restore,
                                color: Colors.white, size: 32),
                          ),
                          secondaryBackground: Container(
                            color: BrandColor.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(Icons.delete_forever,
                                color: Colors.white, size: 32),
                          ),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              // Restore
                              await restoreRecord(record.id, record.model);
                              return true;
                            } else {
                              // Delete permanently
                              showDeleteDialog(record.id, record.model.name);
                              return false;
                            }
                          },
                          child: AccountWidget(
                            accountLogo:
                                _getAccountLogo(record.model.logoValue),
                            name: record.model.name,
                            userName: record.model.username,
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fs_manager/data/my_encryption.dart';

class DBHelper {
  static void insertRecord({
    required String uid,
    required String logoValue,
    required String name,
    required String userName,
    required String password,
    required String webSite,
    required List<String> tags,
  }) async {
    if (FirebaseAuth.instance.currentUser != null) {
      //int createAt = DateTime.now().millisecondsSinceEpoch;
      DatabaseReference ref = FirebaseDatabase.instance.ref("users/$uid");

      var encryptLogoValue =
          MyEncriptionDecription.encryptAES(logoValue).base64;
      var encryptName = MyEncriptionDecription.encryptAES(name).base64;
      var encryptUserName = MyEncriptionDecription.encryptAES(userName).base64;
      var encryptPassword = MyEncriptionDecription.encryptAES(password).base64;
      var encryptWebSite = MyEncriptionDecription.encryptAES(webSite).base64;
      List<dynamic> encryptTags =
          tags.map((e) => MyEncriptionDecription.encryptAES(e).base64).toList();

      await ref.push().set({
        "logoValue": encryptLogoValue,
        "name": encryptName,
        "username": encryptUserName,
        "password": encryptPassword,
        "web_site": encryptWebSite,
        "tag": encryptTags,
      });
    }
  }
}

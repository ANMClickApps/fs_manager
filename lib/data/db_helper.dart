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
      Future<List> getList() async {
        List data = [];
        for (var e in tags) {
          var res = (await MyEncriptionDecription.encryptAES(e)).base64;
          data.add(res);
        }
        return data;
      }

      var encryptLogoValue =
          (await MyEncriptionDecription.encryptAES(logoValue)).base64;
      var encryptName = (await MyEncriptionDecription.encryptAES(name)).base64;
      var encryptUserName =
          (await MyEncriptionDecription.encryptAES(userName)).base64;
      var encryptPassword =
          (await MyEncriptionDecription.encryptAES(password)).base64;
      var encryptWebSite =
          (await MyEncriptionDecription.encryptAES(webSite)).base64;
      List encryptTags = await getList();

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

  static void updateRecord({
    required String uid,
    required String recordId,
    required String logoValue,
    required String name,
    required String userName,
    required String password,
    required String webSite,
    required List<String> tags,
  }) async {
    if (FirebaseAuth.instance.currentUser != null) {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("users/$uid/$recordId");
      Future<List> getList() async {
        List data = [];
        for (var e in tags) {
          var res = (await MyEncriptionDecription.encryptAES(e)).base64;
          data.add(res);
        }
        return data;
      }

      var encryptLogoValue =
          (await MyEncriptionDecription.encryptAES(logoValue)).base64;
      var encryptName = (await MyEncriptionDecription.encryptAES(name)).base64;
      var encryptUserName =
          (await MyEncriptionDecription.encryptAES(userName)).base64;
      var encryptPassword =
          (await MyEncriptionDecription.encryptAES(password)).base64;
      var encryptWebSite =
          (await MyEncriptionDecription.encryptAES(webSite)).base64;
      List encryptTags = await getList();

      await ref.update({
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

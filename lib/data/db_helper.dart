import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

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

      await ref.push().set({
        "logoValue": logoValue,
        "name": name,
        "username": userName,
        "password": password,
        "web_site": webSite,
        "tag": tags,
      });
    }
  }
}

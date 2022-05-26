import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';

class MyEncriptionDecription {
  static encryptAES(text) async {
    String myKey = await _makeKeyFromPin();

    final key = encrypt.Key.fromUtf8(myKey);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted;
  }

  static decryptAES(String text) async {
    String myKey = await _makeKeyFromPin();
    final key = encrypt.Key.fromUtf8(myKey);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted = encrypter.decrypt64(text, iv: iv);
    return decrypted;
  }

  static Future<String> _makeKeyFromPin() async {
    String key = '';
    final prefs = await SharedPreferences.getInstance();
    final String? pin = prefs.getString('pin');
    if (pin != null) {
      key = pin;
      if (pin.length < 32) {
        int dif = 32 - pin.length;
        key = pin;
        for (int i = 0; i < dif; i++) {
          key += key[i];
        }
      }
    }
    return key;
  }
}

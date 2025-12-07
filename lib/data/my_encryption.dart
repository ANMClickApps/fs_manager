import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';

class MyEncriptionDecription {
  static encryptAES(text) async {
    // Обробка порожніх значень - використовуємо спеціальний маркер
    String textToEncrypt = text?.toString() ?? '';
    if (textToEncrypt.isEmpty) {
      textToEncrypt = '__EMPTY__'; // Спеціальний маркер для порожніх значень
    }

    String myKey = await _makeKeyFromPin();

    final key = encrypt.Key.fromUtf8(myKey);
    final iv = _makeIVFromKey(myKey); // Фіксований IV з ключа
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(textToEncrypt, iv: iv);
    return encrypted;
  }

  static decryptAES(String text) async {
    try {
      // Перевірка на порожній текст
      if (text.isEmpty) {
        return '';
      }

      String myKey = await _makeKeyFromPin();
      final key = encrypt.Key.fromUtf8(myKey);
      final iv = _makeIVFromKey(myKey); // Фіксований IV з ключа
      final encrypter = encrypt.Encrypter(encrypt.AES(key));
      final decrypted = encrypter.decrypt64(text, iv: iv);

      // Перевіряємо чи це маркер порожнього значення
      if (decrypted == '__EMPTY__') {
        return '';
      }

      return decrypted;
    } catch (e) {
      // Якщо помилка дешифрування (corrupted data) - повертаємо порожній рядок
      // print('Decryption error: $e, returning empty string');
      return '';
    }
  }

  static Future<String> _makeKeyFromPin() async {
    String key = '';
    final prefs = await SharedPreferences.getInstance();
    final String? pin = prefs.getString('pin');

    if (pin != null && pin.isNotEmpty) {
      key = pin;
      if (pin.length < 32) {
        int dif = 32 - pin.length;
        key = pin;
        for (int i = 0; i < dif; i++) {
          key += key[i];
        }
      }
    } else {
      // Якщо PIN не встановлений - використовуємо дефолтний ключ
      key = 'default_encryption_key_32chars';
    }

    return key;
  }

  // Генерує фіксований IV з ключа (перші 16 символів ключа)
  static encrypt.IV _makeIVFromKey(String key) {
    // IV має бути 16 байт (128 біт)
    // Використовуємо перші 16 символів ключа як IV
    String ivString = key.substring(0, 16);
    return encrypt.IV.fromUtf8(ivString);
  }
}

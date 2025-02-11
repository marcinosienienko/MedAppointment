// import 'package:encrypt/encrypt.dart' as encrypt;
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class EncryptionService {
//   final _secureStorage = const FlutterSecureStorage();
//   final _encryptionKeyStorageKey = 'encryption_key';
//   final _ivKeyStorageKey = 'iv_key';

//   late encrypt.Encrypter _encrypter;
//   late encrypt.IV _iv;

//   EncryptionService() {
//     _initializeEncryption();
//   }

//   Future<void> _initializeEncryption() async {
//     try {
//       String? encryptionKey =
//           await _secureStorage.read(key: _encryptionKeyStorageKey);
//       String? ivKey = await _secureStorage.read(key: _ivKeyStorageKey);

//       // Generowanie kluczy, jeśli nie istnieją
//       if (encryptionKey == null || ivKey == null) {
//         encryptionKey =
//             encrypt.Key.fromSecureRandom(32).base64; // 256-bitowy klucz
//         ivKey = encrypt.IV.fromLength(16).base64; // 16-bajtowy IV

//         await _secureStorage.write(
//             key: _encryptionKeyStorageKey, value: encryptionKey);
//         await _secureStorage.write(key: _ivKeyStorageKey, value: ivKey);

//         print("🔑 Klucze szyfrowania wygenerowane i zapisane.");
//       }

//       // Inicjalizacja encryptera i IV
//       _encrypter =
//           encrypt.Encrypter(encrypt.AES(encrypt.Key.fromBase64(encryptionKey)));
//       _iv = encrypt.IV.fromBase64(ivKey);

//       print("🔐 Szyfrowanie zainicjalizowane.");
//     } catch (e) {
//       print("⚠️ Błąd podczas inicjalizacji szyfrowania: $e");
//     }
//   }

//   String encryptData(String data) {
//     return _encrypter.encrypt(data, iv: _iv).base64;
//   }

//   String decryptData(String encryptedData) {
//     return _encrypter.decrypt64(encryptedData, iv: _iv);
//   }
// }

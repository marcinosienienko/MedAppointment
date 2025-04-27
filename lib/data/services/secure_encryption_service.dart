import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureEncryptionService {
  final _aesKeyStorageKey = 'aes_key';
  final _ivStorageKey = 'iv_key';
  final _secureStorage = const FlutterSecureStorage();

  Future<String> _generateAESKey() async =>
      encrypt.Key.fromSecureRandom(32).base64;

  Future<String> _generateIV() async => encrypt.IV.fromSecureRandom(16).base64;

  Future<void> saveAESKeyAndIV() async {
    if (await _secureStorage.read(key: _aesKeyStorageKey) == null) {
      await _secureStorage.write(
          key: _aesKeyStorageKey, value: await _generateAESKey());
    }

    if (await _secureStorage.read(key: _ivStorageKey) == null) {
      await _secureStorage.write(
          key: _ivStorageKey, value: await _generateIV());
    }
  }

  Future<encrypt.Key> getAESKey() async {
    final keyBase64 = await _secureStorage.read(key: _aesKeyStorageKey);
    if (keyBase64 == null) {
      throw Exception('Klucz AES nie został jeszcze wygenerowany.');
    }
    return encrypt.Key.fromBase64(keyBase64);
  }

  Future<encrypt.IV> getIV() async {
    final ivBase64 = await _secureStorage.read(key: _ivStorageKey);
    if (ivBase64 == null) {
      throw Exception('IV nie został jeszcze wygenerowany.');
    }
    return encrypt.IV.fromBase64(ivBase64);
  }

  Future<String> encryptData(String data) async {
    final key = await getAESKey();
    final iv = await getIV();
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    return encrypter.encrypt(data, iv: iv).base64;
  }

  Future<String> decryptData(String encryptedData) async {
    final key = await getAESKey();
    final iv = await getIV();
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    return encrypter.decrypt64(encryptedData, iv: iv);
  }
}

// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:firebase_remote_config/firebase_remote_config.dart';

// class RemoteConfigService {
//   final FirebaseRemoteConfig remoteConfig;
//   final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

//   RemoteConfigService(this.remoteConfig);

//   static Future<RemoteConfigService> initialize() async {
//     final remoteConfig = FirebaseRemoteConfig.instance;

//     // Ustaw domyślne wartości
//     await remoteConfig.setDefaults({
//       'ENCRYPTION_KEY': 'default_encryption_key',
//       'IV_KEY': 'default_iv_key',
//     });

//     // Konfiguracja czasu odświeżania
//     await remoteConfig.setConfigSettings(RemoteConfigSettings(
//       fetchTimeout: const Duration(seconds: 60),
//       minimumFetchInterval: const Duration(seconds: 0),
//     ));

//     // Pobranie i aktywacja wartości
//     await remoteConfig.fetchAndActivate();

//     final service = RemoteConfigService(remoteConfig);

//     // Zapisz klucze w Secure Storage
//     await service._saveEncryptionKeysToSecureStorage();

//     return service;
//   }

//   Future<void> _saveEncryptionKeysToSecureStorage() async {
//     String encryptionKey = remoteConfig.getString('ENCRYPTION_KEY');
//     String ivKey = remoteConfig.getString('IV_KEY');

//     if (encryptionKey.isNotEmpty && ivKey.isNotEmpty) {
//       await secureStorage.write(key: 'encryption_key', value: encryptionKey);
//       await secureStorage.write(key: 'iv_key', value: ivKey);
//       print("🔑 Klucze szyfrowania zapisane w Secure Storage.");
//     } else {
//       print("⚠️ Klucze szyfrowania są puste. Nie zapisano.");
//     }
//   }

//   Future<String?> getEncryptionKey() async {
//     return await secureStorage.read(key: 'encryption_key');
//   }

//   Future<String?> getIvKey() async {
//     return await secureStorage.read(key: 'iv_key');
//   }
// }

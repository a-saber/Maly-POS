import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class CustomSecureStorage {
  static late final FlutterSecureStorage _storage;

  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  static IOSOptions _getIosOptions() =>
      const IOSOptions(accessibility: KeychainAccessibility.first_unlock);

  static void init() {
    _storage = FlutterSecureStorage(
      aOptions: _getAndroidOptions(),
      iOptions: _getIosOptions(),
    );
  }

  static Future<String?> read({required String key}) => _storage.read(key: key);
  static Future<Map<String, String>?> readAll() => _storage.readAll();
  static Future<void> delete({required String key}) =>
      _storage.delete(key: key);
  static Future<void> write({required String key, required String value}) =>
      _storage.write(key: key, value: value);

  /*
    String value = await storage.read(key: key);

    // Read all values
    Map<String, String> allValues = await storage.readAll();

    // Delete value
    await storage.delete(key: key);

    // Delete all
    await storage.deleteAll();

    // Write value
    await storage.write(key: key, value: value);
  */
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'jwt_token';
  static const _userIdKey = 'user_id';
  static const _userRolKey = 'user_rol';
  static const _userNombreKey = 'user_nombre';

  static Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  static Future<String?> getToken() => _storage.read(key: _tokenKey);

  static Future<void> saveUserData({
    required int id,
    required String rol,
    required String nombre,
  }) async {
    await _storage.write(key: _userIdKey, value: id.toString());
    await _storage.write(key: _userRolKey, value: rol);
    await _storage.write(key: _userNombreKey, value: nombre);
  }

  static Future<String?> getRol() => _storage.read(key: _userRolKey);
  static Future<String?> getNombre() => _storage.read(key: _userNombreKey);

  static Future<void> clearAll() => _storage.deleteAll();
}

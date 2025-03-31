import 'dart:convert';

import 'package:core/src/models.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthTokenRepository {
  AuthTokenRepository({required FlutterSecureStorage secureStorage})
      : _secureStorage = secureStorage;

  final FlutterSecureStorage _secureStorage;
  static const _tokenStorageKey = 'auth_token_data';

  Future<void> saveToken(AuthToken token) async {
    final tokenJson = jsonEncode(token.toJson());
    await _secureStorage.write(key: _tokenStorageKey, value: tokenJson);
  }

  Future<AuthToken?> getToken() async {
    try {
      final tokenJson = await _secureStorage.read(key: _tokenStorageKey);
      if (tokenJson == null) {
        return null;
      }
      final tokenMap = jsonDecode(tokenJson) as Map<String, dynamic>;
      return AuthToken.fromJson(tokenMap);
    } catch (e) {
      await clearToken();
      return null;
    }
  }

  Future<void> clearToken() async {
    await _secureStorage.delete(key: _tokenStorageKey);
  }
}

import 'dart:convert';
import 'dart:developer';

import 'package:core/src/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserStorageService {
  static const _userStorageKey = 'current_user_data';
  static const _userTypeKey = 'user_type';

  Future<void> saveUser(BaseUser user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = user.toJson();

      if (user is BusinessClient) {
        userJson[_userTypeKey] = 'business';
      } else if (user is User) {
        userJson[_userTypeKey] = 'user';
      } else {
        throw Exception('Unknown user type: ${user.runtimeType}');
      }

      final userString = jsonEncode(userJson);
      await prefs.setString(_userStorageKey, userString);
      log('UserStorageService: Saved ${user.runtimeType} (${user.id}) locally.');
    } catch (e, stackTrace) {
      log(
        'UserStorageService: Error saving user locally: $e',
        stackTrace: stackTrace,
        error: e,
      );
      rethrow;
    }
  }

  Future<BaseUser?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString(_userStorageKey);

      if (userString == null) {
        log('UserStorageService: No user data found locally.');
        return null;
      }

      final userJson = jsonDecode(userString) as Map<String, dynamic>;
      final userType = userJson[_userTypeKey] as String?;

      BaseUser? user;
      if (userType == 'business') {
        user = BusinessClient.fromJson(userJson);
      } else if (userType == 'user') {
        user = User.fromJson(userJson);
      } else {
        log(
          'UserStorageService: Unknown or missing user type in stored data. Clearing.',
          level: 900,
        );
        await clearUser();
        return null;
      }

      log('UserStorageService: Retrieved ${user.runtimeType} (${user.id}) from local storage.');
      return user;
    } catch (e, stackTrace) {
      log(
        'UserStorageService: Error getting user locally: $e',
        stackTrace: stackTrace,
        error: e,
      );
      await clearUser();
      return null;
    }
  }

  Future<void> clearUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userStorageKey);
      log('UserStorageService: Cleared local user data.');
    } catch (e, stackTrace) {
      log(
        'UserStorageService: Error clearing user locally: $e',
        stackTrace: stackTrace,
        error: e,
      );
      rethrow;
    }
  }
}

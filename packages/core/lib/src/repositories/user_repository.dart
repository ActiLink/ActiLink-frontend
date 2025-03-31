import 'dart:convert';

import 'package:core/src/models.dart';
import 'package:core/src/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  UserRepository({required ApiService apiService}) : _apiService = apiService;

  final ApiService _apiService;
  static const _userStorageKey = 'user_data';

  Future<void> saveUserLocally(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_userStorageKey, userJson);
  }

  Future<User?> getSavedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userStorageKey);
      if (userJson == null) return null;
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return User.fromJson(userMap);
    } catch (e) {
      await clearUserLocally();
      return null;
    }
  }

  Future<void> clearUserLocally() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userStorageKey);
  }

  Future<User> fetchUserById(String userId) async {
    try {
      final response = await _apiService.getData('/Users/$userId');
      if (response is Map<String, dynamic>) {
        return User.fromJson(response);
      } else {
        throw ApiException(
          'Invalid response format when fetching user $userId',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<User>> fetchAllUsers() async {
    try {
      final response = await _apiService.getData('/Users');
      if (response is List) {
        return response
            .map((userData) => User.fromJson(userData as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException('Invalid response format when fetching all users');
      }
    } catch (e) {
      rethrow;
    }
  }
}

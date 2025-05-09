import 'dart:developer';

import 'package:core/src/models.dart';
import 'package:core/src/services.dart';

class BaseUserRepository {
  BaseUserRepository({required ApiService apiService})
      : _apiService = apiService;

  final ApiService _apiService;

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

  Future<List<BusinessClient>> fetchAllBusinessClients() async {
    try {
      final response = await _apiService.getData('/BusinessClients');
      if (response is List) {
        return response
            .map(
              (clientData) =>
                  BusinessClient.fromJson(clientData as Map<String, dynamic>),
            )
            .toList();
      } else {
        throw ApiException(
          'Invalid response format when fetching all business clients',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<BusinessClient> fetchBusinessClientById(String id) async {
    try {
      final response = await _apiService.getData('/BusinessClients/$id');
      if (response is Map<String, dynamic>) {
        return BusinessClient.fromJson(response);
      } else {
        throw ApiException(
          'Invalid response format when fetching business client $id',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<BaseUser> tryFetchById(String id) async {
    try {
      log('BaseUserRepository: Attempting to fetch user with ID: $id');
      return await fetchUserById(id);
    } on NotFoundException {
      try {
        log('BaseUserRepository: User not found, attempting to fetch business client with ID: $id');
        return await fetchBusinessClientById(id);
      } on NotFoundException {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<User> updateUser(
    String userId,
    String name,
    String email,
    List<Hobby> hobbies,
  ) async {
    try {
      final uniqueHobbies =
          {for (final hobby in hobbies) hobby.name: hobby}.values.toList();

      final response = await _apiService.putData('/Users/$userId', {
        'name': name,
        'email': email,
        'hobbies': uniqueHobbies.map((hobby) => {'name': hobby.name}).toList(),
      });

      if (response is Map<String, dynamic>) {
        return User.fromJson(response);
      } else {
        throw ApiException(
          'Invalid response format during user profile update',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<BusinessClient> updateBusinessClient(
    String clientId,
    String name,
    String email,
    String taxId,
  ) async {
    try {
      final response = await _apiService.putData('/BusinessClients/$clientId', {
        'name': name,
        'email': email,
        'taxId': taxId,
      });

      if (response is Map<String, dynamic>) {
        return BusinessClient.fromJson(response);
      } else {
        throw ApiException(
          'Invalid response format during business client profile update',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}

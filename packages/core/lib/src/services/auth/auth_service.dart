import 'dart:async';
import 'dart:developer';

import 'package:core/src/models.dart';
import 'package:core/src/repositories.dart';
import 'package:core/src/services.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  AuthService({
    required ApiService apiService,
    required AuthTokenRepository tokenRepository,
    required BaseUserRepository baseUserRepository,
  })  : _apiService = apiService,
        _tokenRepository = tokenRepository,
        _baseUserRepository = baseUserRepository;

  final ApiService _apiService;
  final AuthTokenRepository _tokenRepository;
  final BaseUserRepository _baseUserRepository;

  final StreamController<BaseUser?> _userStreamController =
      StreamController<BaseUser?>.broadcast();

  Stream<BaseUser?> get userStream => _userStreamController.stream;

  Future<BaseUser?> _getUserFromToken(String token) async {
    try {
      final decodedToken = JwtDecoder.decode(token);
      final userId = decodedToken['nameid'] as String?;
      final role = decodedToken['role'] as String?;

      if (userId == null || userId.isEmpty || role == null || role.isEmpty) {
        log('Decoded token is missing required fields.');
        return null;
      }

      log('Decoded User ID from token: $userId');
      try {
        if (role == 'User') {
          return await _baseUserRepository.fetchUserById(userId);
        } else if (role == 'BusinessClient') {
          return await _baseUserRepository.fetchBusinessClientById(userId);
        } else {
          log('Unknown role: $role');
          return null;
        }
      } catch (e) {
        log('Error fetching user from API: $e');
        return null;
      }
    } catch (e) {
      log('Error decoding JWT: $e');
      return null;
    }
  }

  Future<BaseUser?> checkInitialAuthStatus() async {
    log('AuthService: Checking initial auth status...');
    final token = await _tokenRepository.getToken();

    if (token == null) {
      log('AuthService: No valid token found locally.');
      await logout();
      return null;
    }

    log('AuthService: Valid token found. Verifying...');
    final user = await _getUserFromToken(token.accessToken);
    if (user == null) {
      log('AuthService: Could not get User from token. Logging out.');
      await logout();
      return null;
    }

    _userStreamController.add(user);
    log('AuthService: Initial auth status check successful. User: ${user.name}');
    return user;
  }

  Future<User> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    log('AuthService: Attempting registration for email: $email');
    try {
      final response = await _apiService.postData('/Users/register', {
        'name': name,
        'email': email,
        'password': password,
      });

      if (response is Map<String, dynamic>) {
        final user = User.fromJson(response);
        log('AuthService: Registration successful for user: ${user.name}');
        return user;
      } else {
        throw ApiException('Invalid response format during registration');
      }
    } catch (e) {
      log('Registration service failed: $e');
      rethrow;
    }
  }

  Future<BusinessClient> registerBusinessClient({
    required String name,
    required String email,
    required String password,
    required String taxId,
  }) async {
    log('AuthService: Attempting registration for email: $email');
    try {
      final response = await _apiService.postData('/BusinessClients/register', {
        'name': name,
        'email': email,
        'password': password,
        'taxId': taxId,
      });

      if (response is Map<String, dynamic>) {
        final businessClient = BusinessClient.fromJson(response);
        log('AuthService: Registration successful for business client: ${businessClient.name}');
        return businessClient;
      } else {
        throw ApiException('Invalid response format during registration');
      }
    } catch (e) {
      log('Registration service failed: $e');
      rethrow;
    }
  }

  Future<BaseUser> _handleLogin({
    required String email,
    required String password,
    required String endpoint,
  }) async {
    log('AuthService: Attempting login for email: $email');
    try {
      final response = await _apiService.postData(endpoint, {
        'email': email,
        'password': password,
      });

      if (response is Map<String, dynamic>) {
        final token = AuthToken.fromJson(response);

        if (token.accessToken.isEmpty) {
          throw ApiException('Login successful but no access token received.');
        }

        await _tokenRepository.saveToken(token);
        log('AuthService: Tokens saved.');

        final user = await _getUserFromToken(token.accessToken);
        if (user == null) {
          throw ApiException(
            'Login successful but failed to extract User from token.',
          );
        }

        log('AuthService: User details fetched and saved: ${user.name}');
        _userStreamController.add(user);
        return user;
      } else {
        throw ApiException('Invalid response format during login');
      }
    } catch (e) {
      log('Login service failed: $e');
      await logout();
      rethrow;
    }
  }

  Future<BaseUser> loginUser({
    required String email,
    required String password,
  }) async {
    return _handleLogin(
      email: email,
      password: password,
      endpoint: '/Users/login',
    );
  }

  Future<BaseUser> loginBusinessClient({
    required String email,
    required String password,
  }) async {
    return _handleLogin(
      email: email,
      password: password,
      endpoint: '/BusinessClients/login',
    );
  }

  Future<void> refreshToken() async {
    final currentToken = await _tokenRepository.getToken();
    if (currentToken == null) {
      log('AuthService: Refresh called but no valid token available.');
      throw UnauthorizedException('No refresh token available.');
    }
    log('AuthService: Attempting token refresh.');

    try {
      final response = await _apiService.postData('/Auth/refresh', {
        'refreshToken': currentToken.refreshToken,
      });

      if (response is Map<String, dynamic>) {
        final newToken = AuthToken.fromJson(response);
        if (newToken.accessToken.isEmpty) {
          throw ApiException(
            'Token refresh successful but no new access token received.',
          );
        }
        await _tokenRepository.saveToken(newToken);
        log('AuthService: Token refreshed and saved successfully.');
      } else {
        throw ApiException('Invalid response format during token refresh');
      }
    } catch (e) {
      log('AuthService: Token refresh failed: $e.');
      await logout();
      log('AuthService: User logged out after failed token refresh.');
      rethrow;
    }
  }

  Future<void> logout() async {
    log('AuthService: Logging out.');
    await _tokenRepository.clearToken();
    _userStreamController.add(null);
  }

  void dispose() {
    _userStreamController.close();
  }

  Future<User> updateUserProfile(
    String userId,
    String name,
    String email,
    List<Hobby> hobbies,
  ) async {
    try {
      return await _baseUserRepository.updateUser(userId, name, email, hobbies);
    } catch (e) {
      rethrow;
    }
  }

  Future<BusinessClient> updateBusinessClientProfile(
    String clientId,
    String name,
    String email,
    String taxId,
  ) async {
    try {
      return await _baseUserRepository.updateBusinessClient(
        clientId,
        name,
        email,
        taxId,
      );
    } catch (e) {
      rethrow;
    }
  }
}

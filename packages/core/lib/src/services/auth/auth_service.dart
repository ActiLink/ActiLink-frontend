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
    required UserRepository userRepository,
  })  : _apiService = apiService,
        _tokenRepository = tokenRepository,
        _userRepository = userRepository;

  final ApiService _apiService;
  final AuthTokenRepository _tokenRepository;
  final UserRepository _userRepository;

  final StreamController<User?> _userStreamController =
      StreamController<User?>.broadcast();

  Stream<User?> get userStream => _userStreamController.stream;

  User? _getUserFromToken(String token) {
    try {
      final decodedToken = JwtDecoder.decode(token);
      final userId = decodedToken['nameid'] as String?;
      final userName = decodedToken['unique_name'] as String?;
      final userEmail = decodedToken['email'] as String?;
      if (userId == null ||
          userId.isEmpty ||
          userName == null ||
          userName.isEmpty ||
          userEmail == null ||
          userEmail.isEmpty) {
        log('Decoded token is missing required fields.');
        return null;
      }
      log('Decoded User from token: $userId');
      return User(id: userId, name: userName, email: userEmail);
    } catch (e) {
      log('Error decoding JWT: $e');
      return null;
    }
  }

  Future<User?> checkInitialAuthStatus() async {
    log('AuthService: Checking initial auth status...');
    final token = await _tokenRepository.getToken();

    if (token == null) {
      log('AuthService: No valid token found locally.');
      await logout();
      return null;
    }

    log('AuthService: Valid token found. Verifying...');
    final user = _getUserFromToken(token.accessToken);
    if (user == null) {
      log('AuthService: Could not get User from token. Logging out.');
      await logout();
      return null;
    }

    await _userRepository.saveUserLocally(user);
    _userStreamController.add(user);
    log('AuthService: Initial auth status check successful. User: ${user.name}');
    return user;
  }

  Future<User> register({
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

  Future<User> login({
    required String email,
    required String password,
  }) async {
    log('AuthService: Attempting login for email: $email');
    try {
      final response = await _apiService.postData('/Users/login', {
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

        final user = _getUserFromToken(token.accessToken);
        if (user == null) {
          throw ApiException(
            'Login successful but failed to extract User from token.',
          );
        }

        await _userRepository.saveUserLocally(user);

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

  Future<User> registerAndLogin({
    required String name,
    required String email,
    required String password,
  }) async {
    log('AuthService: Attempting registerAndLogin for email: $email');

    try {
      log('AuthService: Calling registration endpoint...');
      final regResponse = await _apiService.postData('/Users/register', {
        'name': name,
        'email': email,
        'password': password,
      });

      if (regResponse is Map<String, dynamic>) {
        final createdUser = User.fromJson(regResponse);
        log('AuthService: Registration successful for ${createdUser.name}. Now attempting login...');
      } else {
        log('AuthService: Registration endpoint returned unexpected success format: $regResponse');
        throw ApiException(
          'Registration successful but response format was unexpected.',
        );
      }
    } catch (e) {
      log('AuthService: Registration failed during registerAndLogin: $e');
      rethrow;
    }

    log('AuthService: Calling login endpoint after successful registration...');
    try {
      final loggedInUser = await login(email: email, password: password);
      log('AuthService: registerAndLogin completed successfully.');
      return loggedInUser;
    } catch (e) {
      log('AuthService: Login failed after successful registration: $e');
      rethrow;
    }
  }

  Future<void> refreshToken() async {
    final currentToken = await _tokenRepository.getToken();
    if (currentToken == null) {
      log('AuthService: Refresh called but no valid token available.');
      throw UnauthorizedException('No refresh token available.');
    }
    log('AuthService: Attempting token refresh.');

    try {
      final response = await _apiService.postData('/Users/refresh', {
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
      rethrow;
    }
  }

  Future<void> logout() async {
    log('AuthService: Logging out.');
    await _tokenRepository.clearToken();
    await _userRepository.clearUserLocally();
    _userStreamController.add(null);
  }

  void dispose() {
    _userStreamController.close();
  }
}

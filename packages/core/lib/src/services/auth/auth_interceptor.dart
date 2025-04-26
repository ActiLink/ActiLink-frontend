import 'dart:developer';

import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:synchronized/synchronized.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required AuthTokenRepository tokenRepository,
    required AuthService authService,
  })  : _tokenRepository = tokenRepository,
        _authService = authService;

  final AuthTokenRepository _tokenRepository;
  final AuthService _authService;
  final Lock _refreshLock = Lock();
  bool _isRefreshing = false;

  final List<String> _publicPaths = [
    '/Users/login',
    '/Users/register',
    '/Users/token',
  ];

  Future<void> _refreshToken(String baseUrl) async {
    final refreshToken = (await _tokenRepository.getToken())?.refreshToken;
    if (refreshToken != null) {
      try {
        final response = await Dio().post<Map<String, dynamic>>(
          '$baseUrl/Users/token',
          data: {'refreshToken': refreshToken},
        );
        if (response.statusCode == 200) {
          final newToken = AuthToken.fromJson(response.data!);
          await _tokenRepository.saveToken(newToken);
          log('Interceptor: Token refreshed successfully.');
        } else {
          log('Interceptor: Failed to refresh token. Status code: ${response.statusCode}');
          await _authService.logout();
        }
      } catch (e) {
        log('Interceptor: Error refreshing token: $e');
        await _authService.logout();
      }
    }
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isPublic = _publicPaths.any((path) => options.path.endsWith(path));
    if (!isPublic) {
      final token = await _tokenRepository.getToken();

      if (token != null) {
        if (token.isExpired && !_isRefreshing) {
          log('Interceptor: Token expired for ${options.path}. Refreshing...');
          _isRefreshing = true;

          try {
            await _refreshLock.synchronized(() async {
              final currentToken = await _tokenRepository.getToken();
              if (currentToken != null && currentToken.isExpired) {
                await _refreshToken(options.baseUrl);
              }
            });

            final newToken = await _tokenRepository.getToken();
            if (newToken != null) {
              options.headers['Authorization'] =
                  'Bearer ${newToken.accessToken}';
              log('Interceptor: Using fresh token for ${options.path}');
            } else {
              log('Interceptor: Failed to refresh token. Request might fail with 401.');
            }
          } catch (e) {
            log('Interceptor: Error refreshing token: $e');
          } finally {
            _isRefreshing = false;
          }
        } else {
          options.headers['Authorization'] = 'Bearer ${token.accessToken}';
          log('Interceptor: Added auth token for ${options.path}');
        }
      } else {
        log('Interceptor: No valid token found for ${options.path}. Request might fail with 401.');
      }
    } else {
      log('Interceptor: Public path ${options.path}, no token added.');
    }
    return handler.next(options);
  }
}

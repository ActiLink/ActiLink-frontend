import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
part 'package:core/src/services/api/api_exceptions.dart';

class ApiService {
  ApiService({required String baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }

  late final Dio _dio;

  void addInterceptor(Interceptor interceptor) {
    if (!_dio.interceptors.contains(interceptor)) {
      _dio.interceptors.add(interceptor);
    }
  }

  Future<dynamic> getData(String endpoint) async {
    try {
      final response = await _dio.get<dynamic>(endpoint);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e, 'GET', endpoint);
    } catch (e) {
      log('Unexpected Error GET $endpoint: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<dynamic> postData(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post<dynamic>(endpoint, data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e, 'POST', endpoint);
    } catch (e) {
      log('Unexpected Error POST $endpoint: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<dynamic> putData(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put<dynamic>(endpoint, data: data);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e, 'PUT', endpoint);
    } catch (e) {
      log('Unexpected Error PUT $endpoint: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<void> deleteData(String endpoint) async {
    try {
      await _dio.delete<dynamic>(endpoint);
    } on DioException catch (e) {
      if (e.response?.statusCode == HttpStatus.noContent) {
        return;
      }
      throw _handleDioError(e, 'DELETE', endpoint);
    } catch (e) {
      log('Unexpected Error DELETE $endpoint: $e');
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Exception _handleDioError(DioException e, String method, String endpoint) {
    log('Dio $method $endpoint: ${e.message}\nResponse: ${e.response?.data}');
    final response = e.response;

    if (response != null) {
      final statusCode = response.statusCode;
      final responseData = response.data;
      var errorMessage = 'An unknown server error occurred.';

      if (responseData is Map<String, dynamic>) {
        errorMessage = responseData['message'] as String? ??
            responseData['error'] as String? ??
            'Server error without specific message.';
      } else if (responseData is String && responseData.isNotEmpty) {
        errorMessage = responseData;
      }

      if (statusCode == 401) {
        return UnauthorizedException('Unauthorized: $errorMessage');
      } else if (statusCode == 400) {
        return BadRequestException('Bad Request: $errorMessage');
      } else if (statusCode == 404) {
        return NotFoundException('Not Found: $errorMessage');
      } else {
        return ApiException(
          'API Error ($statusCode) on $method $endpoint: $errorMessage',
        );
      }
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.cancel) {
      return NetworkException('Network timeout or request cancelled.');
    } else {
      return NetworkException('Network error: Failed to connect.');
    }
  }
}

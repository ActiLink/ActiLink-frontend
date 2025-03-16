import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:5289',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<dynamic> getData(String endpoint) async {
    try {
      final response = await _dio.get<List<dynamic>>(endpoint);
      return response.data;
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<dynamic> postData(String endpoint, List<dynamic> data) async {
    try {
      final response = await _dio.post<List<dynamic>>(endpoint, data: data);
      return response.data;
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }
}

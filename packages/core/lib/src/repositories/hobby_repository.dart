import 'package:core/core.dart';

class HobbyRepository {
  HobbyRepository({required ApiService apiService}) : _apiService = apiService;

  final ApiService _apiService;

  Future<List<Hobby>> getAllHobbies() async {
    try {
      final response = await _apiService.getData('/Hobbies');
      if (response is List) {
        return response
            .map((data) => Hobby.fromJson(data as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException('Invalid response format when fetching hobbies.');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Hobby> getHobbyById(String id) async {
    try {
      final response = await _apiService.getData('/Hobbies/$id');
      if (response is Map<String, dynamic>) {
        return Hobby.fromJson(response);
      } else {
        throw ApiException('Invalid response format for hobby $id.');
      }
    } catch (e) {
      rethrow;
    }
  }
}

import 'package:core/core.dart';

class BusinessClientRepository {
  BusinessClientRepository({required ApiService apiService}) : _apiService = apiService;

  final ApiService _apiService;

  Future<List<BusinessClient>> fetchAll() async {
    try {
      final response = await _apiService.getData('/BusinessClients');
      if (response is List) {
        return response
            .map((clientData) => BusinessClient.fromJson(clientData as Map<String, dynamic>))
            .toList();
      } else {
        throw ApiException('Invalid response format when fetching all business clients');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<BusinessClient> fetchById(String id) async {
    try {
      final response = await _apiService.getData('/BusinessClients/$id');
      if (response is Map<String, dynamic>) {
        return BusinessClient.fromJson(response);
      } else {
        throw ApiException('Invalid response format when fetching business client $id');
      }
    } catch (e) {
      rethrow;
    }
  }
}

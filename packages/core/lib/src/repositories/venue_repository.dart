import 'dart:developer';
import 'package:core/core.dart';

class VenueRepository {
  const VenueRepository({
    required ApiService apiService,
  }) : _apiService = apiService;

  final ApiService _apiService;

  Future<List<Venue>> getAllVenues() async {
    try {
      final response = await _apiService.getData('/venues');
      if (response is List) {
        return response
            .map(
              (venueData) => Venue.fromJson(venueData as Map<String, dynamic>),
            )
            .toList();
      } else {
        log('getAllVenues: Unexpected response format: $response');
        throw ApiException('Invalid response format when fetching venues.');
      }
    } catch (e) {
      log('getAllVenues Error: $e');
      rethrow;
    }
  }

  Future<List<Venue>> getVenues({
    required int page,
    required int pageSize,
  }) async {
    try {
      final endpoint = '/venues?page=$page&pageSize=$pageSize';
      log('Fetching venues: $endpoint');
      final response = await _apiService.getData(endpoint);

      if (response is List) {
        return response
            .map(
              (venueData) => Venue.fromJson(venueData as Map<String, dynamic>),
            )
            .toList();
      } else {
        log('getVenues: Unexpected response format: $response');
        throw ApiException(
          'Invalid response format when fetching paginated venues.',
        );
      }
    } catch (e) {
      log('getVenues Error: $e');
      rethrow;
    }
  }

  Future<Venue> getVenueById(String id) async {
    final response = await _apiService.getData('/venues/$id');
    return Venue.fromJson(response as Map<String, dynamic>);
  }

  Future<Venue> createVenue(Venue venue) async {
    final response = await _apiService.postData(
      '/venues',
      venue.toNewVenueDto().toJson(),
    );
    return Venue.fromJson(response as Map<String, dynamic>);
  }

  Future<Venue> updateVenue(String venueId, Venue venue) async {
    final response = await _apiService.putData(
      '/venues/$venueId',
      venue.toUpdateVenueDto().toJson(),
    );
    return Venue.fromJson(response as Map<String, dynamic>);
  }

  Future<void> deleteVenue(String id) async {
    try {
      log('Deleting venue $id');
      await _apiService.deleteData('/Venues/$id');
    } catch (e) {
      log('deleteVenue Error for ID $id: $e');
      rethrow;
    }
  }
}

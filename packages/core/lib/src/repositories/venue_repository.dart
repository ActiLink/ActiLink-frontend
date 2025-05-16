import 'package:core/core.dart';

class VenueRepository {
  const VenueRepository({
    required ApiService apiService,
  }) : _apiService = apiService;

  final ApiService _apiService;

  Future<List<Venue>> getAllVenues() async {
    final response = await _apiService.getData('/venues');
    final venuesJson = response as List;
    return venuesJson
        .map((json) => Venue.fromJson(json as Map<String, dynamic>))
        .toList();
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

  Future<void> deleteVenue(String venueId) async {
    await _apiService.deleteData('/venues/$venueId');
  }
}

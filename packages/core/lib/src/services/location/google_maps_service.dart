import 'dart:developer';

import 'package:core/src/models/location.dart';
import 'package:flutter_google_maps_webservices/geocoding.dart' as gmaps;

class GoogleMapsService {
  GoogleMapsService({required String apiKey}) : _apiKey = apiKey {
    if (_apiKey.isEmpty) {
      log('GoogleMapsService Error: API Key is empty!', level: 1000);
      throw ArgumentError(
        'Google Maps API Key is required but was not provided.',
      );
    }
    _geocoding = gmaps.GoogleMapsGeocoding(apiKey: _apiKey);
  }
  final String _apiKey;
  late final gmaps.GoogleMapsGeocoding _geocoding;

  Future<String?> reverseGeocode(Location location) async {
    if (_apiKey.isEmpty) {
      log('Reverse Geocode skipped: API Key missing.');
      return 'Coordinates: ${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}';
    }
    try {
      final response = await _geocoding.searchByLocation(
        gmaps.Location(lat: location.latitude, lng: location.longitude),
      );

      if (response.isOkay && response.results.isNotEmpty) {
        return response.results.first.formattedAddress;
      } else {
        log('Reverse Geocode Failed: ${response.status} - ${response.errorMessage}');
        return 'Address not found';
      }
    } catch (e) {
      log('Reverse Geocode Error: $e');
      return 'Error finding address';
    }
  }

  Future<Location?> forwardGeocode(String address) async {
    if (_apiKey.isEmpty) {
      log('Forward Geocode skipped: API Key missing.');
      return null;
    }
    if (address.trim().isEmpty) {
      log('Forward Geocode skipped: Address is empty.');
      return null;
    }
    try {
      final response = await _geocoding.searchByAddress(address);

      if (response.isOkay && response.results.isNotEmpty) {
        final geometry = response.results.first.geometry;
        return Location(
          latitude: geometry.location.lat,
          longitude: geometry.location.lng,
        );
      } else {
        log('Forward Geocode Failed: ${response.status} - ${response.errorMessage}');
        return null;
      }
    } catch (e) {
      log('Forward Geocode Error: $e');
      return null;
    }
  }
}

// import 'dart:developer';
import 'package:core/core.dart';

class GeoLocationCacheService {
  factory GeoLocationCacheService() => _instance;
  GeoLocationCacheService._internal();
  static final GeoLocationCacheService _instance =
      GeoLocationCacheService._internal();

  final Map<String, String> _addressCache = {};
  final Map<String, Location> _locationCache = {};

  String? getCachedAddress(Location location) {
    final key = _createCacheKey(location);
    final cachedAddress = _addressCache[key];
    // if (cachedAddress != null) {
    //   log('Cache hit for location: $key, address: $cachedAddress');
    // }
    return cachedAddress;
  }

  Location? getCachedLocation(String address) {
    final cachedLocation = _locationCache[address];
    // if (cachedLocation != null) {
    //   log('Cache hit for address: $address, location: $cachedLocation');
    // }
    return cachedLocation;
  }

  void cacheLocation(String address, Location location) {
    // log('Caching location for address: $address');
    _locationCache[address] = location;
  }

  void cacheAddress(Location location, String address) {
    final key = _createCacheKey(location);
    // log('Caching address for location: $key');
    _addressCache[key] = address;
  }

  void clearCache() {
    // log('Clearing location cache. Entries cleared: ${_addressCache.length}');
    _addressCache.clear();
  }

  /// Creates a cache key from coordinates with reduced precision to handle small variations
  String _createCacheKey(Location location) {
    final lat = location.latitude.toStringAsFixed(4);
    final lng = location.longitude.toStringAsFixed(4);
    return '$lat,$lng';
  }
}

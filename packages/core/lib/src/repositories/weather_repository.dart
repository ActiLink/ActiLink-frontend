import 'package:core/src/networks/api_service.dart';

class WeatherRepository {
  final ApiService _apiService = ApiService();

  Future<List<dynamic>> fetchWeatherForecast() async {
    final data = await _apiService.getData('/weatherforecast');
    if (data is List) {
      return data; // Only return if it's a List
    } else {
      throw Exception('Expected a list of weather forecast data');
    }
  }
}

import 'package:core/core.dart';
import 'package:flutter/material.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherRepository _apiRepository = WeatherRepository();
  List<dynamic> _weatherData = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    try {
      final data = await _apiRepository.fetchWeatherForecast();
      setState(() {
        _weatherData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load weather data: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Forecast'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : ListView.builder(
                  itemCount: _weatherData.length,
                  itemBuilder: (context, index) {
                    final weather = _weatherData[index];
                    return ListTile(
                      title: Text('Date: ${weather['date']}'),
                      subtitle: Text(
                        'Temperature: ${weather['temperatureC']}°C - ${weather['summary']}',
                      ),
                    );
                  },
                ),
    );
  }
}

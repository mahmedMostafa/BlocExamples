import 'dart:convert';

import 'package:bloc_examples/apps/weather/models/weather.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class WeatherApiClient {
  static const baseUrl = 'https://www.metaweather.com';
  final http.Client httpClient;

  WeatherApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);

  Future<int> getLocationId(String city) async {
    final locationUrl = '$baseUrl/api/location/search/?query=$city';
    final locationResponse = await http.get(locationUrl);
    if (locationResponse.statusCode != 200) {
      throw Exception('error getting locationId for city');
    }
    final json = jsonDecode(locationResponse.body) as List;
    return (json.first)['woeid'];
  }

  Future<Weather> fetchWeather(int locationId) async {
    final weatherUrl = '$baseUrl/api/location/$locationId';
    final weatherResponse = await http.get(weatherUrl);
    if (weatherResponse.statusCode != 200) {
      throw Exception("'error getting weather for location'");
    }
    final json = jsonDecode(weatherResponse.body);
    return Weather.fromJson(json);
  }
}

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mp5/models/weather_model.dart';

class WeatherAPI {
  static const String apiKey = "9a61757ea88f62502c44e67845f3f877";

  static Future<LocationData> getLocationData(String city) async {
    final response = await http.get(Uri.parse(
        'http://api.openweathermap.org/geo/1.0/direct?q=$city&limit=5&appid=$apiKey'));

    if (response.statusCode == 200) {
      return LocationData.fromJson(json.decode(response.body)[0]);
    } else {
      throw Exception('Failed to load location data');
    }
  }

  static Future<WeatherInfo?> getWeatherData(
      double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/3.0/onecall?lat=$latitude&lon=$longitude&units=metric&exclude=alerts&appid=$apiKey'));

    if (response.statusCode == 200) {
      return WeatherInfo?.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}

class LocationData {
  final double latitude;
  final double longitude;

  LocationData({required this.latitude, required this.longitude});

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      latitude: json['lat'].toDouble(),
      longitude: json['lon'].toDouble(),
    );
  }
}

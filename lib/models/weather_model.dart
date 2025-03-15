class WeatherInfo {
  final double latitude;
  final double longitude;

  final double temperature;
  final String weatherDescription;
  final String weatherIcon;

  WeatherInfo({
    this.latitude = 41.8781,
    this.longitude = -87.6298,
    this.temperature = 0.0,
    this.weatherDescription = 'Unknown',
    this.weatherIcon = '',
  });

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    final currentWeather = json['current'];
    return WeatherInfo(
      latitude: json['lat'].toDouble(),
      longitude: json['lon'].toDouble(),
      temperature: currentWeather['temp'].toDouble(),
      weatherDescription: currentWeather['weather'][0]['description'],
      weatherIcon: currentWeather['weather'][0]['icon'],
    );
  }
}

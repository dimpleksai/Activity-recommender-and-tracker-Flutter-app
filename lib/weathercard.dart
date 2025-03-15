import 'package:flutter/material.dart';
import 'package:mp5/models/weather_model.dart';

class WeatherCard extends StatelessWidget {
  final WeatherInfo weatherData;

  const WeatherCard({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Weather',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${weatherData.temperature}°C',
                  style: const TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  weatherData.weatherDescription,
                  style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
                (weatherData.weatherIcon != null &&
                        weatherData.weatherIcon.isNotEmpty)
                    ? Image.network(
                        'https://openweathermap.org/img/w/${weatherData.weatherIcon}.png',
                        width: 50.0,
                        height: 50.0,
                      )
                    : Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey,
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

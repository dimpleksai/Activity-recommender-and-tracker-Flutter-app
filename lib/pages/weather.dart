import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mp5/activitycard.dart';
import 'package:mp5/weathercard.dart';
import 'package:mp5/models/activity.dart';
import 'package:mp5/models/weather_model.dart';
import 'package:mp5/pages/activityscreen.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  late String cityName;
  WeatherInfo? weatherData;
  ActivityModel? activityData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    cityName = 'Chicago';
    isLoading = true;
    fetchWeatherData(cityName);
  }

  Future<void> fetchWeatherData(String city) async {
    final geoApiUrl =
        'http://api.openweathermap.org/geo/1.0/direct?q=$city&limit=5&appid=9a61757ea88f62502c44e67845f3f877';
    final geoResponse = await http.get(Uri.parse(geoApiUrl));
    final geoData = jsonDecode(geoResponse.body);
    print(geoResponse);
    if (geoData.isNotEmpty) {
      final latitude = geoData[0]['lat'];
      final longitude = geoData[0]['lon'];
      city = geoData[0]['name'];
      final weatherApiUrl =
          'https://api.openweathermap.org/data/3.0/onecall?lat=$latitude&lon=$longitude&units=metric&exclude=alerts&appid=9a61757ea88f62502c44e67845f3f877';
      final weatherResponse = await http.get(Uri.parse(weatherApiUrl));
      final weather = jsonDecode(weatherResponse.body);
      print(weatherResponse);
      final geoTimezoneApiUrl =
          'https://api.geotimezone.com/public/timezone?latitude=$latitude&longitude=$longitude';
      final geoTimezoneResponse = await http.get(Uri.parse(geoTimezoneApiUrl));
      final geoTimezone = jsonDecode(geoTimezoneResponse.body);
      print(geoTimezoneResponse);
      final currentHour =
          DateTime.parse(geoTimezone['current_local_datetime']).hour;

      final isDayTime = currentHour >= 5 && currentHour < 18;
      final temperature = weather['current']['temp'].toDouble();

      final isSunny = temperature >= 3 &&
          !weather['current']['weather'][0]['main']
              .toString()
              .toLowerCase()
              .contains('rain') &&
          !weather['current']['weather'][0]['main']
              .toString()
              .toLowerCase()
              .contains('snow');

      weatherData = WeatherInfo.fromJson(weather);
      activityData = ActivityModel.fromRecommendations(isSunny, isDayTime);
      isLoading = false;
      setState(() {
        cityName = city;
      });
    }
  }

  Future<void> _showLocationInputDialog(BuildContext context) async {
    TextEditingController controller = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter City Name'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'City Name'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  cityName = controller.text;
                  fetchWeatherData(cityName);
                });
                Navigator.pop(context);
                _refresh();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _refresh() async {
    setState(() {
      isLoading = true;
    });
    await fetchWeatherData(cityName);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Activity App'),
          leading: IconButton(
            icon: Icon(Icons.location_on),
            onPressed: () {
              _showLocationInputDialog(context);
            },
          ),
          actions: [
            Tooltip(
              message: 'Refresh',
              child: IconButton(
                onPressed: () {
                  _refresh();
                },
                icon: Icon(Icons.refresh),
              ),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16.0),
              Text('Loading...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Activity App'),
            Text(
              cityName,
              style: TextStyle(fontSize: 14.0),
            ),
          ],
        ),
        leading: Tooltip(
          message: 'Change Location',
          child: IconButton(
            icon: Icon(Icons.location_on),
            onPressed: () {
              _showLocationInputDialog(context);
            },
          ),
        ),
        actions: [
          Tooltip(
            message: 'Refresh',
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                onPressed: () {
                  _refresh();
                },
                icon: Icon(Icons.refresh),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            WeatherCard(
              weatherData: weatherData ?? WeatherInfo(),
            ),
            ActivityCard(
              activityData: activityData ??
                  ActivityModel(
                    activity: 'My Activity',
                    details: 'Details about my activity',
                    activityName: 'My Activity Name',
                  ),
            ),
          ],
        ),
      ),
      floatingActionButton: Tooltip(
        message: 'Go to Activity Time Tracker',
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActivityScreen(
                  activityName: activityData?.activityName ?? '',
                ),
              ),
            );
          },
          child: Icon(Icons.volunteer_activism),
        ),
      ),
    );
  }
}

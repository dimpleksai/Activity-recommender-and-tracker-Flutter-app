import 'package:flutter_test/flutter_test.dart';
import 'package:mp5/models/activity.dart';
import 'package:mp5/models/weather_model.dart';

void main() {
  //Unit Test #1 : this testcase tests creation of activity model

  test('activityModel creation', () {
    final activity = ActivityModel(
      activity: 'Outdoor',
      details: 'Test Details of the activity',
      activityName: 'Jogging',
    );

    expect(activity.activity, 'Outdoor');
    expect(activity.details, 'Test Details of the activity');
    expect(activity.activityName, 'Jogging');
  });

//Unit Test #2 tests scenario when it is sunny, or cloudy(not rainy,snowy)  and it is daytime
  test('ActivityModel.fromRecommendations should return valid activity', () {
    final activityModel = ActivityModel.fromRecommendations(true, true);
    expect(activityModel.activity, 'outdoor');
    expect(activityModel.details,
        "Embrace the outdoors with activities like walking, jogging, cycling, gardening, and picnicking.");
    final outdoorActivities = [
      'walking',
      'Jogging',
      'Cycling',
      'Gardening',
      'Picnicking'
    ];
    expect(outdoorActivities.contains(activityModel.activityName), isTrue);
  });

  //Unit Test #3 tests scenario when it is nighttime,
  test('ActivityModel.fromRecommendations should return valid activity', () {
    final activityModel = ActivityModel.fromRecommendations(false, false);
    expect(activityModel.activity, 'nighttime');
    expect(activityModel.details,
        "Wind down your day with relaxing nighttime activities like reading, watching a movie, playing board games, listening to a podcast, and playing video games.");
    final outdoorActivities = [
      'read',
      'movie',
      'boardgame',
      'podcast',
      'videogame'
    ];
    expect(outdoorActivities.contains(activityModel.activityName), isTrue);
  });

  //Unit Test #4 : tests tests creation of weatherInfo model
  test('WeatherInfo creation', () {
    final weather = WeatherInfo(
      temperature: 25.0,
      latitude: 41.8781,
      longitude: -87.6298,
      weatherDescription: 'Sunny',
      weatherIcon: '',
    );

    expect(weather.temperature, 25.0);
    expect(weather.latitude, 41.8781);
    expect(weather.longitude, -87.6298);
    expect(weather.weatherDescription, 'Sunny');
    expect(weather.weatherIcon, '');
  });

//Unit Test #5 : this will test parsing json data by WeatherInfo.fromJson
  test('parse JSON data', () {
    final json = {
      'lat': 40.7128,
      'lon': -74.0060,
      'current': {
        'temp': 22.0,
        'weather': [
          {'description': 'Clear sky', 'icon': '01d'}
        ],
      },
    };
    final weatherInfo = WeatherInfo.fromJson(json);
    expect(weatherInfo.latitude, 40.7128);
    expect(weatherInfo.longitude, -74.0060);
    expect(weatherInfo.temperature, 22.0);
    expect(weatherInfo.weatherDescription, 'Clear sky');
    expect(weatherInfo.weatherIcon, '01d');
  });
}

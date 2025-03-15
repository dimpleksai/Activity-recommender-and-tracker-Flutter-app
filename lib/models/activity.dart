import 'dart:math';

class ActivityModel {
  final String activity;
  final String details;
  final String activityName;

  ActivityModel({
    required this.activity,
    required this.details,
    required this.activityName,
  });

  factory ActivityModel.fromRecommendations(bool isSunny, bool isDayTime) {
    String category;
    if (isSunny && isDayTime) {
      category = 'outdoor';
    } else if (!isSunny && isDayTime) {
      category = 'indoor';
    } else {
      category = 'nighttime';
    }

    return ActivityModel(
      activity: _getRandomActivity(category),
      details: _getDetailsForCategory(category),
      activityName: _getRandomActivityName(category),
    );
  }

  static String _getRandomActivityName(String category) {
    List<String> outdoorActivities = [
      'walking',
      'Jogging',
      'Cycling',
      'Gardening',
      'Picnicking'
    ];
    List<String> indoorActivities = [
      'meditation',
      'painting',
      'baking',
      'craftDIY',
      'journaling'
    ];
    List<String> nighttimeActivities = [
      'read',
      'movie',
      'boardgame',
      'podcast',
      'videogame'
    ];

    Map<String, String> previousActivityMap = {
      'outdoor': '',
      'indoor': '',
      'nighttime': '',
    };

    String getRandomActivity(List<String> activities, String category) {
      String randomActivity;
      do {
        randomActivity = activities[Random().nextInt(activities.length)];
      } while (randomActivity == previousActivityMap[category]);

      previousActivityMap[category] = randomActivity;

      return randomActivity;
    }

    switch (category) {
      case 'outdoor':
        return getRandomActivity(outdoorActivities, category);
      case 'indoor':
        return getRandomActivity(indoorActivities, category);
      case 'nighttime':
        return getRandomActivity(nighttimeActivities, category);
      default:
        return '';
    }
  }

  static String _getDetailsForCategory(String category) {
    switch (category) {
      case 'outdoor':
        return "Embrace the outdoors with activities like walking, jogging, cycling, gardening, and picnicking.";
      case 'indoor':
        return "Stay cozy indoors and try engaging activities such as meditation, painting, baking, craft DIY, and journaling.";
      case 'nighttime':
        return "Wind down your day with relaxing nighttime activities like reading, watching a movie, playing board games, listening to a podcast, and playing video games.";
      default:
        return 'Details for $category';
    }
  }

  static String _getRandomActivity(String category) {
    return category;
  }
}

import 'package:flutter/material.dart';
import 'package:mp5/dbhelper.dart';
import 'package:intl/intl.dart';

class ActivityListScreen extends StatefulWidget {
  @override
  State<ActivityListScreen> createState() => _ActivityListScreenState();
}

class _ActivityListScreenState extends State<ActivityListScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  Set<int> selectedActivityIds = Set<int>();
  void _deleteSelectedActivities() async {
    if (selectedActivityIds.isEmpty) {
      return;
    }

    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Activities'),
          content: Text('Are you sure you want to delete selected activities?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      for (int id in selectedActivityIds) {
        await dbHelper.deleteActivity(id);
      }

      setState(() {
        selectedActivityIds.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Past Activities'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: selectedActivityIds.isNotEmpty
                ? () => _deleteSelectedActivities()
                : null,
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHelper.getAllActivities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No past activities recorded.'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final activity = snapshot.data![index];
              final activityName = activity['activityName'];

              return Container(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.9),
                      blurRadius: 8.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                  image: DecorationImage(
                    image: AssetImage(_getBackgroundImage(activityName)),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    leading: Checkbox(
                      value: selectedActivityIds.contains(activity['id']),
                      onChanged: (value) {
                        setState(() {
                          if (value != null) {
                            value
                                ? selectedActivityIds.add(activity['id'])
                                : selectedActivityIds.remove(activity['id']);
                          }
                        });
                      },
                    ),
                    title: Text(
                      'Activity: $activityName',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 8.0,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                    subtitle: Text(
                      'Duration: ${_formatDuration(activity['durationInSeconds'])}\nTimestamp: ${_getFormattedTimestamp(activity['timestamp'])}',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 8.0,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _getFormattedTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    return DateFormat.yMMMMd().add_jm().format(dateTime);
  }

  String _getBackgroundImage(String activityName) {
    final trimmedActivityName = activityName.trim().toLowerCase();

    switch (trimmedActivityName) {
      case 'walking':
        return 'assets/walking.jpg';
      case 'jogging':
        return 'assets/jog.jpg';
      case 'cycling':
        return 'assets/cycling.jpg';
      case 'gardening':
        return 'assets/gardening.jpg';
      case 'picnicking':
        return 'assets/picnicking.jpg';
      case 'meditation':
        return 'assets/meditation.jpg';
      case 'painting':
        return 'assets/painting.jpg';
      case 'baking':
        return 'assets/baking.jpg';
      case 'craftdiy':
        return 'assets/craft_diy.jpg';
      case 'journaling':
        return 'assets/journaling.jpg';
      case 'read':
        return 'assets/reading.jpg';
      case 'movie':
        return 'assets/movie.jpg';
      case 'boardgame':
        return 'assets/boardgame.jpg';
      case 'podcast':
        return 'assets/podcast.jpg';
      case 'videogame':
        return 'assets/videogame.jpg';
      case 'sleep':
        return 'assets/sleep.jpg';
      default:
        return 'assets/def.jpg';
    }
  }
}

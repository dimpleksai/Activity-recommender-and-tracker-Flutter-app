import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mp5/pages/activitylist.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:mp5/dbhelper.dart';

class ActivityScreen extends StatefulWidget {
  final String activityName;

  const ActivityScreen({Key? key, required this.activityName})
      : super(key: key);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  late Timer _timer;
  int _seconds = 0;
  bool _isTimerRunning = false;
  final DatabaseHelper dbHelper = DatabaseHelper.instance;
  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }

  void _initializeTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_isTimerRunning) {
        setState(() {
          _seconds++;
        });
      }
    });
  }

  String _formatTime() {
    int minutes = _seconds ~/ 60;
    int seconds = _seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void _recordActivity(BuildContext context) async {
    final Map<String, dynamic> activity = {
      'activityName': widget.activityName,
      'durationInSeconds': _seconds,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };

    final id = await dbHelper.insertActivity(activity);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Activity recorded successfully.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity: ${widget.activityName}'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_getBackgroundImage()),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatTime(),
              style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isTimerRunning = true;
                    });
                  },
                  child: Text('Start'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isTimerRunning = false;
                    });
                  },
                  child: Text('Pause'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isTimerRunning = false;
                      _recordActivity(context);
                      _seconds = 0;
                    });
                  },
                  child: Text('Stop'),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActivityListScreen(),
                  ),
                );
              },
              child: Text('View Past Activities'),
            ),
          ],
        ),
      ),
    );
  }

  String _getBackgroundImage() {
    switch (widget.activityName.toLowerCase()) {
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

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

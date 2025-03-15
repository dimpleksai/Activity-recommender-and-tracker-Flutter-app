import 'package:flutter/material.dart';
import 'package:mp5/models/activity.dart';

class ActivityCard extends StatelessWidget {
  final ActivityModel activityData;

  const ActivityCard({super.key, required this.activityData});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
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
                    'Recommended Activity',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '${activityData.activity[0].toUpperCase()}${activityData.activity.substring(1).toLowerCase()} : ${activityData.activityName[0].toUpperCase()}${activityData.activityName.substring(1).toLowerCase()}',
                    style: const TextStyle(
                        fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    activityData.details,
                    style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

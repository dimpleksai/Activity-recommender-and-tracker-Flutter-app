// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mp5/activitycard.dart';
import 'package:mp5/pages/activityscreen.dart';
import 'package:mp5/models/activity.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

void main() {
  //Widget test #1 : test the weather card widget
  testWidgets('weather Card displays current weather',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Card(
          child: Column(
            children: [
              Text('Current Weather'),
              Text('0.0°C'),
              Text('Unknown'),
            ],
          ),
        ),
      ),
    );

    final cardFinder = find.byType(Card);
    final temperatureFinder = find.text('0.0°C');
    final weatherDescriptionFinder = find.text('Unknown');
    final imageFinder = find.byType(Image);

    expect(cardFinder, findsOneWidget);
    expect(temperatureFinder, findsOneWidget);
    expect(weatherDescriptionFinder, findsOneWidget);
  });

  //Widget tset #2 : tests activity card widget

  testWidgets('activityCard displays activity data',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ActivityCard(
            activityData: ActivityModel(
              activity: 'outdoor',
              details: 'Test details',
              activityName: 'Jogging',
            ),
          ),
        ),
      ),
    );

    expect(find.text('Recommended Activity'), findsOneWidget);
    expect(find.text('Outdoor : Jogging'), findsOneWidget);
    expect(find.text('Test details'), findsOneWidget);
  });

  //widget test #3 : tests the that activity screen can be navigated and correct activity is passed
  testWidgets('floating action button navigates to activityScreen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Container(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                tester.element(find.byType(Scaffold)),
                MaterialPageRoute(
                    builder: (context) =>
                        ActivityScreen(activityName: 'Jogging')),
              );
            },
          ),
        ),
      ),
    );

    // tap on the button to go to activity screen
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.byType(ActivityScreen), findsOneWidget);
    expect(find.text('Activity: Jogging'), findsOneWidget);
  });
// widget test #4 : test start button
  testWidgets('ActivityScreen starts timer when Start button is pressed',
      (WidgetTester tester) async {
    const activityName = 'reading';

    await tester.pumpWidget(
      const MaterialApp(
        home: Directionality(
          textDirection: TextDirection.ltr,
          child: ActivityScreen(activityName: 'reading'),
        ),
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text('00:00'), findsOneWidget);
    await tester.tap(find.text('Start'));

    // waiting for the timer to become "00:01"
    await tester.pumpAndSettle(const Duration(milliseconds: 600));

    expect(find.text('00:01'), findsOneWidget);
  });

  // widget test #5 : test pause button
  testWidgets('ActivityScreen pauses timer when Pause button is pressed',
      (WidgetTester tester) async {
    const activityName = 'reading';
    await tester.pumpWidget(
      const MaterialApp(
        home: Directionality(
          textDirection: TextDirection.ltr,
          child: ActivityScreen(activityName: 'reading'),
        ),
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 1));
    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle(const Duration(milliseconds: 600));
    await tester.tap(find.text('Pause'));

    expect(find.text('00:01'), findsOneWidget);
  });
}

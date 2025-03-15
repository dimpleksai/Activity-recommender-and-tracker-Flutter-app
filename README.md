# Activity App

## 1. Overview

This is an activity recommending and tracking app. The app recommends users an activity to do based the weather example: if sunny,cloudy outdoor activities,if day but rainy or snowy, then indoor activities, if night, then indoor night time activities. 

## 2. Features

It has 3 separate screens

WeatherApp: This serves as the main page.(default, home)
ActivityListScreen: Displays past activities recorded.
ActivityScreen: Allows users to track activity time.

WeatherApp: It is a Stateful Widget managing the state of weather and activity data.
_WeatherAppState: Backed by a custom model class (WeatherInfo and ActivityModel) for weather and activity data.

ActivityListScreen: The recorded activities are stored locally using SQLite through DatabaseHelper in dbhelper.dart. This provides local persistence across launches.

Includes Unit tests and Integration tests

### 2.1 Implementation details

screen 1 : Home

- Weather data displayed based on location , location can be changed
- activity recomended based on the weather and time at the location chosen
- navigate to the activity tackier screen
- has a refresh button
- displayed roatating loader when loading data

screen 2 : Activity Tracker

- displays recomeneded activity related image 
- timer 
- start, pause, stop buttons
- when stop clicked activity details and duration and date timestamp gets recorded
- click view past activities to view all 

screen 3 : List of activities

- List of all past activities (latest at top)
- tiles have related image, and overlay to make activity details more visible
- delete icon
- checkboxes beside each activity to select which one to delete

### 2.2 External packages

- dependencies I have added to my  pubspec.yaml file, such a  http for making API calls and cached_network_image for loading images from URLs.
- assets: many images
- path_provider: ^2.1.1
  sqflite: ^2.3.0
  http: ^1.1.2
  collection: ^1.17.2
  shared_preferences: ^2.2.2
  sqflite_common_ffi: ^2.3.1
  timezone: ^0.9.2
  intl: ^0.19.0
  mock_web_server: ^5.0.0-nullsafety.1
  .
  .
  .
  
 ## 3. Screenshots
 

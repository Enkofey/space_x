import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:spacex_project/core/model/notification.dart';
import 'package:workmanager/workmanager.dart';

import 'app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(

    // The top level function, aka callbackDispatcher
      callbackDispatcher,
      // If enabled it will post a notification whenever
      // the task is running. Handy for debugging tasks
      isInDebugMode: false
  );
  runApp(App());
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {

    // initialise the plugin of flutterlocalnotifications.
    FlutterLocalNotificationsPlugin flip = new FlutterLocalNotificationsPlugin();

    // app_icon needs to be a added as a drawable
    // resource to the Android head project.
    var android = new AndroidInitializationSettings('app_icon');
    var IOS = new IOSInitializationSettings();

    // initialise settings for both Android and iOS device.
    var settings = new InitializationSettings(android: android, iOS: IOS);
    flip.initialize(settings);
    showOngoingNotification(flip, title: "N'oubliez pas le lancement.", body: 'La fusée décolle dans une heure.');
    return Future.value(true);
  });
}
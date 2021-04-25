import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:spacex_project/core/model/notification.dart';
import 'package:spacex_project/ui/home.dart';



class LocalNotification extends StatefulWidget{
  @override
  _LocalNotificationState createState() => _LocalNotificationState();
}

class _LocalNotificationState extends State<LocalNotification>{

  final notification = FlutterLocalNotificationsPlugin();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: ListView(
      children: [
        RaisedButton(
          onPressed: () => showOngoingNotification(notification, title: "title", body : "body"),
          child: Text("Notification"),

        )
      ],
    ),
  );

  @override
  void initState() {
    super.initState();
    final settingsAndroid = AndroidInitializationSettings('app_icon');

    final settingsIos = IOSInitializationSettings(
      onDidReceiveLocalNotification : (id, title, body, payload) =>
          onSelectNotification(payload));

    final settingsMacOs = MacOSInitializationSettings();

    notification.initialize(
      InitializationSettings(android : settingsAndroid, iOS : settingsIos, macOS : settingsMacOs),
      onSelectNotification: onSelectNotification);
  }
  Future onSelectNotification(String payload) async => await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => HomePage()),
  );
}
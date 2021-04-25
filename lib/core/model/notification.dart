import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

NotificationDetails get _ongoing{
  final androidChannelSpecifics = AndroidNotificationDetails(
  "your channel id",
  "your channel name",
  "your channel description",
    importance: Importance.max,
    priority: Priority.high,
    ongoing : true,
    autoCancel: true,
  );
  final IOSChannelSpecifics = IOSNotificationDetails();
  return NotificationDetails(android: androidChannelSpecifics, iOS: IOSChannelSpecifics);
}


Future showOngoingNotification(
    FlutterLocalNotificationsPlugin notification, {
      @required String title,
      @required String body,
      @required NotificationDetails type,
      int id = 0,
    }) => _showNotification(notification, id : id, title : title, body : body, type : _ongoing);

Future _showNotification(
  FlutterLocalNotificationsPlugin notification, {
    @required String title,
    @required String body,
    @required NotificationDetails type,
    int id = 0,
  }) => notification.show(id, title, body, type);
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsManager {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> showNotificationHot() async {
    // Set the notification's details
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Show the notification
    await flutterLocalNotificationsPlugin.show(
      0,
      'Room Temperature Alert',
      'The temperature in your room is too hot. Please take action to cool down the room ASAP to avoid discomfort or health risks.',
      platformChannelSpecifics,
    );
  }

  Future<void> showNotificationEco() async {
    // Set the notification's details
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Show the notification
    await flutterLocalNotificationsPlugin.show(
      0,
      'Comfort Alert',
      'This room is maintained at an ideal temperature and humidity level for your comfort.',
      platformChannelSpecifics,
    );
  }

  Future<void> showNotificationDanger() async {
    // Set the notification's details
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Show the notification
    await flutterLocalNotificationsPlugin.show(
      0,
      'Fire Alert',
      'Fire Warning! Evacuate now and contact the fire department ASAP.',
      platformChannelSpecifics,
    );
  }

  Future<void> showNotificationSmoke() async {
    // Set the notification's details
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Show the notification
    await flutterLocalNotificationsPlugin.show(
      0,
      'Smoke Contamination Alert',
      'Smoke contamination in room. Evacuate and find a safe location until source is resolved.',
      platformChannelSpecifics,
    );
  }

  Future<void> showNotificationGas() async {
    // Set the notification's details
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // Show the notification
    await flutterLocalNotificationsPlugin.show(
      0,
      'Gas Contamination Alert',
      'Gas leak detected in room. Evacuate immediately and find a safe location until leak is resolved.',
      platformChannelSpecifics,
    );
  }
}

import 'dart:convert';

import 'package:carabaobillingapps/constant/data_constant.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../main.dart';

class PusherService {
  late PusherChannelsFlutter pusher;
  static final PusherService _instance = PusherService._internal();

  factory PusherService() {
    return _instance;
  }

  PusherService._internal();

  Future<void> initPusher() async {
    pusher = PusherChannelsFlutter.getInstance();
    await pusher.init(
      apiKey: ConstantData.pusher_apiKey,
      cluster: "ap1",
    );
    await _subscribeToChannel();
    await pusher.connect();
  }

  Future<void> _subscribeToChannel() async {
    await pusher.subscribe(
      channelName: "orders",
      onEvent: (event) async {
        try {
          final eventData = json.decode(event.data);
          final message = eventData['message'];
          final link = eventData['link'];
          final is_multiple = eventData['isMultiple'];
          final multiple_channel = eventData['multipleChannel'];
          final ip = eventData['ip'];
          final secret = eventData['secret'];
          final status = eventData['status'];

          if (is_multiple == 1) {
            List<dynamic> multipleChannelList = jsonDecode(multiple_channel);
            multipleChannelList.forEach((e) {
              var link = ip + e + status + "?key=" + secret;
              offLamp(link);
            });
          } else {
            print("background masuk");
            await _handleEvent(link, message);
          }
        } catch (e) {
          print("Error handling event: $e");
        }
      },
    );
  }

  Future<void> _handleEvent(String link, String message) async {
    offLamp(link);
    await _showNotification("Open - Billing", message);
  }

  Future<void> _showNotification(String title, String body) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'countdown_channel',
      'Countdown Channel',
      importance: Importance.high,
      playSound: false,
      enableVibration: false,
      enableLights: false,
      ongoing: true, // Set to true to create a persistent notification
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID (should be unique for each notification)
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}

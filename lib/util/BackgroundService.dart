import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../service/models/order/ResponseListOrdersModels.dart';
import 'DatabaseHelper.dart';

void backgroundTask(popup) async {

  await checkForNewData(popup ?? true);

}

Future<void> checkForNewData(popup) async {
  final dbHelper = DatabaseHelper();
  List<NewestOrder> orders = await dbHelper.getOrders();
  if (orders.isNotEmpty) {
    String ordersMessage = "";
    // for (var order in orders) {
    //   DateTime endTime = DateTime.parse(order.newestOrderEndTime!);
    //   if (DateTime.now().isAfter(endTime)) {
    //     ordersMessage += "${order.name} - OFF\n";
    //     // await stopBilling(order!.id!, order!.ip, order!.secret, order!.code);
    //     await dbHelper.deleteOrderById(order!.id!);
    //     backgroundTask(true);
    //     cancelNotification(0);
    //   } else {
    //     ordersMessage += "${order.name} - ON\n";
    //   }
    // }

    // if (popup ?? true) {
    //   await _showNotification(
    //     "Open - Billing",
    //     ordersMessage,
    //   );
    // }
  }
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

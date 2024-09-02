import 'dart:async';

import 'package:carabaobillingapps/helper/shared_preference.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../constant/data_constant.dart';
import '../service/repository/RoomsRepository.dart';

void hideKeyboard(context) {
  FocusScope.of(context).requestFocus(FocusNode());
}

void popScreen(BuildContext context, [dynamic data]) {
  Navigator.pop(context, data);
}

enum RouteTransition { slide, dualSlide, fade, material, cupertino }

Future pushScreenAndWait(BuildContext context, Widget buildScreen) async {
  await Navigator.push(
      context, CupertinoPageRoute(builder: (context) => buildScreen));
  return;
}

Future pushScreenAndWaitReplace(
    BuildContext context, Widget buildScreen) async {
  await Navigator.pushReplacement(
      context, CupertinoPageRoute(builder: (context) => buildScreen));
  return;
}

Future<Map<String, String>> tokenHeader(bool contentType) async {
  var token = await getStringValuesSF(ConstantData.token);
  var headers = {'Authorization': 'Bearer $token'};
  if (contentType) {
    headers = {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token'
    };
  }

  return headers;
}

void switchLamp(
    {required String ip,
    required String key,
    required String code,
    required bool status}) async {
  await RoomsRepoRepositoryImpl()
      .openRooms(ip + code + (status ? "on" : "off") + "?key=" + key);
}

String formatDuration(Duration duration) {
  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);
  int seconds = duration.inSeconds.remainder(60);

  String hoursString = hours > 0 ? '$hours Jam' : '';
  String minutesString = minutes > 0 ? ' $minutes Menit' : '';
  String secondsString = seconds > 0 ? ' $seconds Detik' : '';

  return hoursString + minutesString + secondsString;
}

String _cleanAndCapitalize(String input) {
  String cleanedType =
      input.replaceAll(RegExp(r'[^\w\s]'), ' '); // Replace symbols with spaces
  cleanedType =
      cleanedType.toLowerCase().capitalize(); // Capitalize the first letter
  return cleanedType;
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

String formatDateTimeWeb(DateTime? dateTime) {
  if (dateTime == null) {
    return 'Invalid date';
  }

  // Define a custom date format
  final DateFormat formatter = DateFormat('d MMMM yyyy - HH:mm', 'id_ID');

  // Format the DateTime object
  return formatter.format(dateTime);
}

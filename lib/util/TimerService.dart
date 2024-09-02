import 'dart:async';

import 'BackgroundService.dart';

class TimerService {
  static final TimerService _instance = TimerService._internal();
  int _seconds = 0;
  Timer? _timer;

  TimerService._internal();

  static TimerService get instance => _instance;

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _seconds++;
      backgroundTask(false);
    });
  }

  int get seconds => _seconds;



  void stopTimer() {
    _timer?.cancel();
  }
}

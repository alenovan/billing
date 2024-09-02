import 'dart:async';

import 'package:carabaobillingapps/constant/color_constant.dart';
import 'package:carabaobillingapps/constant/image_constant.dart';
import 'package:carabaobillingapps/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/data_constant.dart';
import '../helper/shared_preference.dart';
import 'menu/HistoryScreen.dart';
import 'menu/HomeScreen.dart';
import 'menu/SettingScreen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _currentIndex = 0;
  PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inapp();
  }

  void inapp() async {
    await RegisterBackground(context);
    var timer = await getStringValuesSF(ConstantData.is_timer);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: ColorConstant.bg,
          bottomNavigationBar: Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8.0,
                  spreadRadius: 2.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              height: 56.0,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      _navigateToPage(0);
                    },
                    child: Image.asset(
                      _currentIndex == 0
                          ? ImageConstant.home_selected
                          : ImageConstant.home,
                      width: 45.w,
                      height: 45.w,
                    ),
                  ),
                  VerticalDivider(
                    color: ColorConstant.dividermenu,
                    thickness: 1.0,
                    width: 20.0,
                  ),
                  InkWell(
                    onTap: () {
                      _navigateToPage(1);
                    },
                    child: Image.asset(
                      _currentIndex == 1
                          ? ImageConstant.history
                          : ImageConstant.history_selected,
                      width: 45.w,
                      height: 45.w,
                    ),
                  ),
                  VerticalDivider(
                    color: ColorConstant.dividermenu,
                    thickness: 1.0,
                    width: 20.0,
                  ),
                  InkWell(
                    onTap: () {
                      _navigateToPage(2);
                    },
                    child: Image.asset(
                      _currentIndex == 2
                          ? ImageConstant.setting_selected
                          : ImageConstant.setting,
                      width: 45.w,
                      height: 45.w,
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: [HomeScreen(), HistoryScreen(), SettingScreen()],
          ),
        ),
        onWillPop: () async {
          return false;
        });
  }

  void _navigateToPage(int index) async {
    _pageController.jumpToPage(index);
  }
}

class CountdownTimer {
  final String key;
  final DateTime endTime;
  final Function(Duration) onTick;
  final Function() onCountdownFinish;
  final Function() onStart;
  late Timer _timer;

  CountdownTimer({
    required this.key,
    required this.endTime,
    required this.onTick,
    required this.onCountdownFinish,
    required this.onStart,
  });

  void start() {
    final Duration countdownDuration = endTime.difference(DateTime.now());
    onStart();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final Duration remainingTime = endTime.difference(DateTime.now());
      if (remainingTime.inSeconds == 0) {
        _timer.cancel();
        onCountdownFinish();
      } else {
        onTick(remainingTime);
      }
    });
  }

  void cancel() {
    _timer.cancel();
  }
}

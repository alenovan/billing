import 'dart:convert';

import 'package:carabaobillingapps/constant/data_constant.dart';
import 'package:carabaobillingapps/main.dart';
import 'package:carabaobillingapps/service/bloc/order/order_bloc.dart';
import 'package:carabaobillingapps/service/models/order/ResponseListOrdersModels.dart';
import 'package:carabaobillingapps/service/repository/OrderRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../component/menu_list_card.dart';
import '../../component/shimmerx.dart';
import '../../constant/color_constant.dart';
import '../../constant/image_constant.dart';
import '../../helper/BottomSheetFeedback.dart';
import '../../service/bloc/configs/configs_bloc.dart';
import '../../service/bloc/meja/meja_bloc.dart';
import '../../service/repository/ConfigRepository.dart';
import '../../service/repository/RoomsRepository.dart';
import '../../util/BackgroundService.dart';
import '../BottomNavigationScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  OrderBloc? _OrderBloc;
  final _ConfigsBloc = ConfigsBloc(repository: ConfigRepoRepositoryImpl());
  late List<NewestOrder>? NewestOrders = [];
  late bool loading = true;
  final _MejaBloc = MejaBloc(repository: RoomsRepoRepositoryImpl());
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  AppLifecycleState _appLifecycleState = AppLifecycleState.resumed;
  List<Map<String, dynamic>> _orders = [];
  late CountdownTimer _countdownTimer;
  final int _updateIntervalSeconds = 1;
  var firstOpen = true;

  @override
  void initState() {
    // TODO: implement initState
    _OrderBloc = OrderBloc(repository: OrderRepoRepositoryImpl(context));
    _MejaBloc?.add(GetMeja());
    super.initState();
    _OrderBloc?.add(GetOrder());
    // _OrderBloc.add(GetOrderBg());
    WidgetsBinding.instance?.addObserver(this);
    cancelNotification(0);
    checkForNewData(true);
    Registerbackgroun(context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _appLifecycleState = state;
    });

    switch (state) {
      case AppLifecycleState.resumed:
        backgroundTask(true);
        break;
      case AppLifecycleState.inactive:
        backgroundTask(true);
        break;
      case AppLifecycleState.paused:
        backgroundTask(true);
        break;
      case AppLifecycleState.detached:
        backgroundTask(true);
        break;
      case AppLifecycleState.hidden:
        backgroundTask(true);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    // _countdownTimer.cancel();
    _OrderBloc?.close();
    checkForNewData(true);
    super.dispose();
  }

  Widget _consumerApi() {
    return Column(
      children: [
        BlocConsumer<OrderBloc, OrderState>(
          listener: (c, s) {
            // if (s is OrdersListBgLoadedState) {
            //   setState(() {
            //     saveData(s.result!.data!);
            //   });
            //
            // }
            if (s is OrdersLoadingState) {
            } else if (s is OrdersListLoadedState) {
              List<NewestOrder> filteredOrders = s.result.data!.where((order) {
                return order.type == 'OPEN-BILLING' &&
                    order.statusOrder == 'START';
              }).toList();
              setState(() {
                NewestOrders = s.result.data;
                loading = false;
              });
            } else if (s is OrdersErrorState) {
              BottomSheetFeedback.showError(context, "Mohon Maaf", s.message);
            }
          },
          builder: (c, s) {
            return Container();
          },
        ),
        BlocConsumer<MejaBloc, MejaState>(
          listener: (c, s) async {
            if (s is MejaLoadedState) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('result_meja', jsonEncode(s.result.toJson()));
            }
          },
          builder: (c, s) {
            return Container();
          },
        ),
      ],
    );
  }

  Future<void> _refreshList() async {
    _OrderBloc?.add(GetOrder());
    _OrderBloc?.add(GetOrderBg());
    setState(() {
      loading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bg, // Mengatur warna latar belakang
      appBar: AppBar(
        backgroundColor: ColorConstant.primary,
        title: Text(
          "Home",
          style: GoogleFonts.openSans(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh), // Refresh icon
            color: Colors.white,
            onPressed: () {
              _refreshList();
            },
          ),
        ],
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<OrderBloc>(
            create: (BuildContext context) => _OrderBloc!,
          ),
          BlocProvider<ConfigsBloc>(
            create: (BuildContext context) => _ConfigsBloc,
          ),
          BlocProvider<MejaBloc>(
            create: (BuildContext context) => _MejaBloc,
          ),
        ],
        child: RefreshIndicator(
          onRefresh: _refreshList,
          child: ListView(
            children: [
              _consumerApi(),
              // GestureDetector(
              //   onTap: _refreshList,
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: ColorConstant.primary,
              //       borderRadius: BorderRadius.circular(30),
              //       boxShadow: [
              //         BoxShadow(
              //           color: Colors.black.withOpacity(0.1),
              //           blurRadius: 8.0,
              //           spreadRadius: 1.0,
              //           offset: Offset(0, 4),
              //         ),
              //       ],
              //     ),
              //     height: 50.w,
              //     margin: EdgeInsets.symmetric(horizontal: 10.w),
              //     alignment: Alignment.center,
              //     child: Text(
              //       "Refresh",
              //       style: GoogleFonts.plusJakartaSans(
              //           fontSize: 16.sp, color: ColorConstant.white),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 10.h),
              loading
                  ? ListView.builder(
                      itemCount: 10,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        return Container(
                          margin: EdgeInsets.all(8.w),
                          height: 80.w,
                          child: Shimmerx(),
                        );
                      },
                    )
                  : ListView.builder(
                      itemCount: NewestOrders?.length ?? 0,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        var data = NewestOrders![i];
                        ConstantData.ip_default = data.ip!;
                        ConstantData.key_config = data.secret!;
                        return Container(
                          child: MenuListCard(
                            status: data.statusRooms == 0 ? false : true,
                            name: data.name!,
                            id_order: data.id.toString(),
                            code: data.code!,
                            start: data.newestOrderStartTime!,
                            end: data.newestOrderEndTime!,
                            id_meja: data.roomId.toString(),
                            type: data.type.toString(),
                            ip: data.ip!,
                            keys: data.secret!,
                            onUpdate: () {
                              _OrderBloc?.add(GetOrder());
                            },
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

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
    return Container(
      child: MultiBlocProvider(
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
                  Container(
                    child: Column(
                      children: [
                        Image.asset(
                          ImageConstant.logo,
                          width: 150.w,
                        ),
                        Text(
                          "Billiards Lamp Controls",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 15.sp, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.w,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(""),
                        GestureDetector(
                          onTap: () {
                            _refreshList();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: ColorConstant.primary,
                                ),
                                color: ColorConstant.primary,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            height: 30.w,
                            margin: EdgeInsets.only(right: 10.w),
                            padding: EdgeInsets.only(left: 20.w, right: 20.w),
                            child: Center(
                              child: Text(
                                "Refresh",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.sp,
                                    color: ColorConstant.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.w,
                  ),
                  if (loading)
                    ListView.builder(
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
                    ),
                  if (!loading)
                    ListView.builder(
                      itemCount: NewestOrders?.length ?? 0,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        var data = NewestOrders![i];
                        ConstantData.ip_default = data.ip!;
                        ConstantData.key_config = data.secret!;
                        return MenuListCard(
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
                        );
                      },
                    )
                ],
              ))),
    );
  }
}

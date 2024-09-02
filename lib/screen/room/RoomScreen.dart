import 'package:carabaobillingapps/helper/global_helper.dart';
import 'package:carabaobillingapps/screen/room/OpenTableScreen.dart';
import 'package:carabaobillingapps/service/repository/OrderRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../component/loading_dialog.dart';
import '../../constant/color_constant.dart';
import '../../helper/BottomSheetFeedback.dart';
import '../../helper/navigation_utils.dart';
import '../../service/bloc/order/order_bloc.dart';
import '../../service/models/order/ResponseListOrdersModels.dart';
import '../BottomNavigationScreen.dart';
import 'BillingScreen.dart';

class RoomScreen extends StatefulWidget {
  final String? meja_id;

  const RoomScreen({super.key, this.meja_id});

  @override
  State<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
  int _currentIndex = 0;
  PageController _pageController = PageController(initialPage: 0);
  OrderBloc? _OrderBloc;
  late NewestOrder? dataGet = null;
  var loading = true;

  @override
  void initState() {
    _OrderBloc = OrderBloc(repository: OrderRepoRepositoryImpl(context));

    // TODO: implement initState
    super.initState();
    _OrderBloc?.add(getDetailOrders(id: widget.meja_id.toString()));
  }

  Widget _consumerApi() {
    return Column(
      children: [
        BlocConsumer<OrderBloc, OrderState>(
          listener: (c, s) {
            if (s is OrdersLoadingState) {
              LoadingDialog.show(c, "Mohon tunggu");
            } else if (s is OrdersDetailLoadedState) {
              setState(() {
                popScreen(context);
                dataGet = s.result.data![0];
                loading = false;

                if (dataGet?.type == "OPEN-BILLING" &&
                    dataGet?.statusOrder == "START") {
                  _currentIndex = 1;
                } else {
                  _currentIndex = 0;
                }
              });
            } else if (s is OrdersErrorState) {
              BottomSheetFeedback.showError(context, "Mohon Maaf", s.message);
            }
          },
          builder: (c, s) {
            return Container();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrderBloc>(
          create: (BuildContext context) => _OrderBloc!,
        ),
      ],
      child: WillPopScope(
        onWillPop: ()async{
          NavigationUtils.navigateTo(
              context, const BottomNavigationScreen(), false);
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              title: loading
                  ? CircularProgressIndicator()
                  : Text(dataGet?.name ?? ""),
            ),
            body: Stack(
              children: [
                _consumerApi(),
                loading
                    ? CircularProgressIndicator()
                    : Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(20.w),
                      height: 50.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (dataGet?.type == "OPEN-TABLE" ||
                              dataGet?.type.toString() == "null" ||
                              dataGet?.statusOrder == "STOP")
                            Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    _navigateToPage(0);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: _currentIndex == 0
                                              ? ColorConstant.primary
                                              : ColorConstant.subtext,
                                        ),
                                        color: _currentIndex == 0
                                            ? ColorConstant.primary
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    height: 50.w,
                                    width: 100.w,
                                    padding: EdgeInsets.only(
                                        left: 20.w, right: 20.w),
                                    child: Center(
                                      child: Text(
                                        "Open Table",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.plusJakartaSans(
                                            fontSize: 11.sp,
                                            color: _currentIndex == 0
                                                ? ColorConstant.white
                                                : ColorConstant.subtext),
                                      ),
                                    ),
                                  ),
                                )),
                          SizedBox(
                            width: 10.w,
                          ),
                          if (dataGet?.type == "OPEN-BILLING" ||
                              dataGet?.type.toString() == "null" ||
                              dataGet?.statusOrder == "STOP")
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _navigateToPage(1);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: _currentIndex == 1
                                            ? ColorConstant.primary
                                            : ColorConstant.subtext,
                                      ),
                                      color: _currentIndex == 1
                                          ? ColorConstant.primary
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                  height: 50.w,
                                  padding: EdgeInsets.only(
                                      left: 20.w, right: 20.w),
                                  child: Center(
                                    child: Text(
                                      "Open Billing",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11.sp,
                                          color: _currentIndex == 1
                                              ? ColorConstant.white
                                              : ColorConstant.subtext),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        children: [
                          if (dataGet?.type == "OPEN-TABLE" ||
                              dataGet?.type.toString() == "null" ||
                              dataGet?.statusOrder == "STOP")
                            OpenTableScreen(
                              isMuiltiple: dataGet?.isMultipleChannel ?? 0,
                              id_order: dataGet?.id.toString(),
                              id_meja: dataGet!.roomId.toString(),
                              code: dataGet?.code ?? "",
                              status: dataGet?.statusOrder == "START"
                                  ? true
                                  : false,
                              ip: dataGet?.ip ?? "",
                              keys: dataGet?.secret ?? "",
                              multipleChannel:
                              dataGet?.multipleChannel ?? "",
                            ),
                          if (dataGet?.type == "OPEN-BILLING" ||
                              dataGet?.type.toString() == "null" ||
                              dataGet?.statusOrder == "STOP")
                            BillingScreen(
                              isMuiltiple: dataGet?.isMultipleChannel ?? 0,
                              multipleChannel:
                              dataGet?.multipleChannel ?? "",
                              id_order: dataGet?.id.toString(),
                              id_meja: dataGet!.roomId.toString(),
                              code: dataGet?.code ?? "",
                              status: dataGet?.statusOrder == "START"
                                  ? true
                                  : false,
                              ip: dataGet?.ip ?? "",
                              keys: dataGet?.secret ?? "",
                            ),
                        ],
                      ),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      padding: EdgeInsets.all(16.0),
                      color: ColorConstant.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Test Lampu",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            "Tombol ini digunakan untuk menguji lampu. Itu tidak akan dicatat dalam transaksi. Gunakan jika lampu tidak menyala atau mati",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10.sp,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10.w,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  LoadingDialog.show(context, "Mohon tunggu");
                                  switchLamp(
                                      ip: dataGet?.ip ?? "",
                                      key: dataGet?.secret ?? "",
                                      code: dataGet?.code ?? "",
                                      status: true);
                                  await Future.delayed(Duration(seconds: 2));
                                  switchLamp(
                                      ip: dataGet?.ip ?? "",
                                      key: dataGet?.secret ?? "",
                                      code: dataGet?.code ?? "",
                                      status: false);
                                  await Future.delayed(Duration(seconds: 1));
                                  popScreen(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorConstant.alarm,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  "TEST",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              // ElevatedButton(
                              //   onPressed: () async{
                              //     LoadingDialog.show(context, "Mohon tunggu");
                              //     switchLamp(
                              //       ip: dataGet?.ip ?? "",
                              //       key: dataGet?.secret ?? "",
                              //       code: dataGet?.code ?? "",
                              //       status: false,
                              //     );
                              //     await Future.delayed(Duration(seconds: 2));
                              //     popScreen(context);
                              //   },
                              //   style: ElevatedButton.styleFrom(
                              //     backgroundColor: ColorConstant.off,
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(20),
                              //     ),
                              //   ),
                              //   child: Text(
                              //     "OFF",
                              //     style: GoogleFonts.plusJakartaSans(
                              //       fontSize: 10.sp,
                              //       color: Colors.white,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      )),
                ),
              ],
            )),
      ),
    );
  }

  void _navigateToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

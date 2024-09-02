import 'dart:async';

import 'package:carabaobillingapps/constant/color_constant.dart';
import 'package:carabaobillingapps/screen/room/RoomScreen.dart';
import 'package:carabaobillingapps/service/models/order/RequestStopOrdersModels.dart';
import 'package:carabaobillingapps/service/repository/OrderRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constant/data_constant.dart';
import '../constant/image_constant.dart';
import '../helper/BottomSheetFeedback.dart';
import '../helper/global_helper.dart';
import '../helper/shared_preference.dart';
import '../service/bloc/order/order_bloc.dart';

class MenuListCard extends StatefulWidget {
  late bool status;
  final String name;
  final String id_meja;
  final String? id_order;
  final String code;
  final String end;
  final String start;
  final String type;
  final String ip;
  final String keys;
  final Function() onUpdate;

  MenuListCard(
      {super.key,
      required this.status,
      required this.name,
      required this.end,
      required this.code,
      required this.id_meja,
      required this.type,
      required this.start,
      this.id_order,
      required this.ip,
      required this.keys,
      required this.onUpdate});

  @override
  State<MenuListCard> createState() => _MenuListCardState();
}

class _MenuListCardState extends State<MenuListCard> {
  Duration _remainingTime = Duration(seconds: 0);
  late DateTime? _startTime;
  late Timer _timer;
  OrderBloc? _OrderBloc;
  var statusLocal = false;

  Widget _consumerApi() {
    return Column(
      children: [
        BlocConsumer<OrderBloc, OrderState>(
          listener: (c, s) async {
            if (s is OrdersStopOpenBillingLoadedState) {
              switchLamp(
                  ip: s.result.data!.panel!.ip!,
                  key: s.result.data!.panel!.secret!,
                  code: s.result.data!.code!,
                  status: false);
              setState(() {
                widget.status = false;
                statusLocal = false;
              });
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
  void dispose() {
    // TODO: implement dispose
    _OrderBloc?.close();
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _OrderBloc = OrderBloc(repository: OrderRepoRepositoryImpl(context));
    statusLocal = widget.status;
    if (widget.end != "No orders") {
      setState(() {
        DateTime endTime = DateTime.parse(widget.end);
        Duration difference = endTime.difference(DateTime.parse(widget.start));
        _remainingTime = Duration(seconds: difference.inSeconds);
      });
    }
    if (widget.type == "OPEN-BILLING" &&
        widget.end != "No orders" &&
        widget.status) {
      // Calculate the remaining time for OPEN-BILLING
      DateTime endTime = DateTime.parse(widget.end);
      Duration difference = endTime.difference(DateTime.now());
      _remainingTime = Duration(seconds: difference.inSeconds);

      // Start a timer to update the countdown every second
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_remainingTime!.inSeconds > 0) {
          setState(() {
            _remainingTime = _remainingTime! - Duration(seconds: 1);
          });
        } else {
          widget.onUpdate();
          // Countdown has reached zero, you may want to handle this case
          timer.cancel();
          _OrderBloc?.add(ActStopOrderOpenAutoBilling(
              payload: RequestStopOrdersModels(
                  orderId: int.parse(widget.id_order.toString()))));
        }
      });
    } else if (widget.type == "OPEN-TABLE" && widget.status) {
      // For OPEN-TABLE, use count-up behavior
      _startTime = DateTime.parse(widget.start);
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          _remainingTime = DateTime.now().difference(_startTime!);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<OrderBloc>(
            create: (BuildContext context) => _OrderBloc!,
          ),
        ],
        child: InkWell(
          onTap: () async {
            var timer = await getStringValuesSF(ConstantData.is_timer);
            if (timer == "1") {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RoomScreen(
                          meja_id: widget.id_meja,
                        )),
              );
            } else {
              BottomSheetFeedback.showError(context, "Mohon Maaf",
                  "Akun anda tidak di izinkan untuk menjalankan biliing");
            }
          },
          child: Container(
            child: Column(
              children: [
                _consumerApi(),
                Container(
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorConstant.white,
                    ),
                    padding: EdgeInsets.all(10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.name ?? "",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14.sp,
                                      color: ColorConstant.titletext,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                if (widget.type == "OPEN-BILLING" &&
                                    !widget.status)
                                  Text(
                                    " OPEN-BILLING Waktu Sudah Habis",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10.sp,
                                      color: ColorConstant.subtext,
                                    ),
                                  ),
                                if (widget.type == "OPEN-BILLING" &&
                                    widget.end != "No orders" &&
                                    widget.status &&
                                    _remainingTime != null)
                                  Text(
                                    _remainingTime != null && widget.status
                                        ? formatDuration(_remainingTime!) +
                                            " Lagi Habis"
                                        : "N/A",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10.sp,
                                      color: ColorConstant.subtext,
                                    ),
                                  ),
                                if (widget.type == "OPEN-TABLE" &&
                                    widget.status &&
                                    _startTime != null &&
                                    _remainingTime != null)
                                  Text(
                                    _remainingTime != null
                                        ? (widget.type == "OPEN-TABLE"
                                                ? "Open Table"
                                                : "") +
                                            " - " +
                                            formatDuration(_remainingTime!)
                                        : "N/A",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10.sp,
                                      color: ColorConstant.subtext,
                                    ),
                                  ),
                                if (!widget.status &&
                                    widget.type == "OPEN-TABLE")
                                  Text(
                                    widget.end == "No orders"
                                        ? "Available"
                                        : formatDuration(_remainingTime),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10.sp,
                                      color: ColorConstant.subtext,
                                    ),
                                  ),
                              ],
                            )
                          ],
                        ),
                        if (!statusLocal)
                          Container(
                            width: 55.w,
                            decoration: BoxDecoration(
                                color: ColorConstant.success,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            height: 30.w,
                            child: Center(
                              child: Text(
                                "Ready",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.sp, color: Colors.white),
                              ),
                            ),
                          ),
                        if (statusLocal)
                          Container(
                            width: 75.w,
                            decoration: BoxDecoration(
                                color: ColorConstant.error,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            height: 30.w,
                            child: Center(
                              child: Text(
                                "Digunakan",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.sp, color: Colors.white),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                Divider()
              ],
            ),
          ),
        ));
  }
}

import 'package:carabaobillingapps/screen/menu/DetailHistory.dart';
import 'package:carabaobillingapps/service/bloc/order/order_bloc.dart';
import 'package:carabaobillingapps/service/models/order/RequestOrderSearch.dart';
import 'package:carabaobillingapps/service/repository/OrderRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../constant/color_constant.dart';
import '../../constant/image_constant.dart';
import '../../helper/BottomSheetFeedback.dart';
import '../../helper/global_helper.dart';
import '../../service/bloc/configs/configs_bloc.dart';
import '../../service/models/configs/ResponseClientInformation.dart';
import '../../service/models/order/ResponseOrderHistoryModels.dart';
import '../../service/repository/ConfigRepository.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  OrderBloc? _OrderBloc;
  late dynamic order = [];
  late TextEditingController searchController = TextEditingController();

  final _ConfigsBloc = ConfigsBloc(repository: ConfigRepoRepositoryImpl());
  DetailInformation? detailInformation;

  @override
  void initState() {
    // TODO: implement initState
    _OrderBloc = OrderBloc(repository: OrderRepoRepositoryImpl(context));
    super.initState();
    _ConfigsBloc.add(GetConfig());
    _OrderBloc?.add(ActOrderHistory(
        payload: RequestOrderSearch(search: "", page: 1, pageSize: 1000)));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _OrderBloc?.close();
    _ConfigsBloc?.close();
    super.dispose();
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'void':
        return Colors.transparent; // No fill color
      case 'no-order':
        return Colors.transparent;
      case 'Done':
        return Colors.transparent;
      default:
        return ColorConstant.success; // Default to success color
    }
  }

  Color _getBorderColor(String? status) {
    if (status == 'void') {
      return Colors.red;
    }
    if (status == 'no-order') {
      return Colors.orange;
    }
    if (status == 'Done') {
      return Colors.green;
    }
    return Colors.transparent; // No border for other statuses
  }

  String _getTextStatusData(String? status) {
    if (status == 'void') {
      return "Void";
    }
    if (status == 'no-order') {
      return "No Order";
    }
    if (status == 'Done') {
      return "Done";
    }
    return ""; // No border for other statuses
  }

  Color _getTextColor(String? status) {
    if (status == 'void') {
      return Colors.red;
    }
    if (status == 'Done') {
      return Colors.green;
    }
    if (status == 'no-order') {
      return Colors.orange;
    }
    return Colors.white; // Default text color
  }

  Widget _consumerApi() {
    return Column(
      children: [
        BlocConsumer<OrderBloc, OrderState>(
          listener: (c, s) {
            if (s is OrdersLoadingState) {
            } else if (s is OrdersHistoryLoadedState) {
              setState(() {
                order = s.result.data!.matchedOrders!;
              });
            } else if (s is OrdersErrorState) {
              popScreen(c);
              BottomSheetFeedback.showError(context, "Mohon Maaf", s.message);
            }
          },
          builder: (c, s) {
            return Container();
          },
        ),
        BlocConsumer<ConfigsBloc, ConfigsState>(
          listener: (c, s) {
            if (s is ConfigsLoadingState) {
            } else if (s is ConfigsListLoadedState) {
              setState(() {
                detailInformation = s.result.data!.first!;
              });
            } else if (s is ConfigsErrorState) {}
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
    return WillPopScope(
        child: Scaffold(
          backgroundColor: ColorConstant.bg,
          appBar: AppBar(
            backgroundColor: ColorConstant.primary,
            title: Text(
              "Riwayat",
              style: GoogleFonts.openSans(color: Colors.white),
            ),
            automaticallyImplyLeading: false,
          ),
          body: MultiBlocProvider(
              providers: [
                BlocProvider<OrderBloc>(
                  create: (BuildContext context) => _OrderBloc!,
                ),
                BlocProvider<ConfigsBloc>(
                  create: (BuildContext context) => _ConfigsBloc!,
                ),
              ],
              child: Container(
                child: Column(
                  children: [
                    _consumerApi(),
                    SizedBox(height: 10.w,),
                    Expanded(
                      child: ListView.builder(
                        itemCount: order?.length ?? 0,
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          var data = order[i] as MatchedOrder;
                          DateTime endTime =
                              DateTime.parse(data.endTime.toString());
                          Duration difference = endTime.difference(
                              DateTime.parse(data.startTime.toString()));
                          var _remainingTime =
                              Duration(seconds: difference.inSeconds);
                          return GestureDetector(
                            onTap: () {
                              print(data.id.toString());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailHistory(
                                          id_order: data.id.toString(),
                                        )),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.w),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${(detailInformation?.clientId.toString() ?? "") + data.id.toString()}",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 12.sp,
                                                    color: ColorConstant.titletext,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                              SizedBox(
                                                height: 1.w,
                                              ),
                                              Text(
                                                "Cust : ${data.ordersName}",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 10.sp),
                                              ),
                                              SizedBox(
                                                height: 1.w,
                                              ),
                                              Text(
                                                "${data.name}",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                    color: ColorConstant.subtext,
                                                    fontSize: 10.sp),
                                              ),
                                              SizedBox(
                                                height: 1.w,
                                              ),
                                              Text(
                                                "${DateFormat('MMMM d, y', 'de_DE').format(data.startTime!)}",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                    color: ColorConstant.subtext,
                                                    fontSize: 10.sp),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      if (data.statusData != null)
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "${formatDuration(Duration(seconds: DateTime.parse(data!.endTime.toString()).difference(DateTime.parse(data!.startTime.toString())).inSeconds))}",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                  color: ColorConstant.primary,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 11.sp),
                                            ),
                                            SizedBox(
                                              height: 5.w,
                                            ),
                                            Text(
                                              "${data.type}",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                  color: ColorConstant.subtext,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10.sp),
                                            ),
                                            SizedBox(
                                              height: 5.w,
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 5.w, right: 5.w),
                                              width: 70.w,
                                              decoration: BoxDecoration(
                                                color: _getStatusColor(
                                                    data.statusData),
                                                border: Border.all(
                                                  color: _getBorderColor(
                                                      data.statusData),
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                              height: 25.w,
                                              child: Center(
                                                child: Text(
                                                  _getTextStatusData(
                                                      data.statusData) ??
                                                      "",
                                                  textAlign: TextAlign.center,
                                                  style:
                                                  GoogleFonts.plusJakartaSans(
                                                    fontSize: 10.sp,
                                                    color: _getTextColor(
                                                        data.statusData),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                    ],
                                  ),
                                  Divider()
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )),
        ),
        onWillPop: () async {
          return false;
        });
  }
}

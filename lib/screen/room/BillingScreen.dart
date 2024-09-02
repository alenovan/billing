import 'dart:convert';

import 'package:boxicons/boxicons.dart';
import 'package:carabaobillingapps/constant/data_constant.dart';
import 'package:carabaobillingapps/service/bloc/order/order_bloc.dart';
import 'package:carabaobillingapps/service/models/order/RequestChangeTable.dart';
import 'package:carabaobillingapps/service/models/order/RequestOrdersModels.dart';
import 'package:carabaobillingapps/service/models/order/RequestStopOrdersModels.dart';
import 'package:carabaobillingapps/service/repository/OrderRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../component/loading_dialog.dart';
import '../../constant/color_constant.dart';
import '../../helper/BottomSheetFeedback.dart';
import '../../helper/global_helper.dart';
import '../../helper/navigation_utils.dart';
import '../../service/bloc/meja/meja_bloc.dart';
import '../../service/models/rooms/ResponseRoomsModels.dart';
import '../../service/repository/RoomsRepository.dart';
import '../BottomNavigationScreen.dart';

class BillingScreen extends StatefulWidget {
  final String id_meja;
  final String code;
  final bool status;
  final String? id_order;
  final String ip;
  final String keys;
  final int isMuiltiple;
  final String multipleChannel;

  const BillingScreen({
    super.key,
    required this.id_meja,
    required this.code,
    required this.status,
    this.id_order,
    required this.ip,
    required this.keys,
    required this.isMuiltiple,
    required this.multipleChannel,
  });

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  late String selected_time = "Pilih Durasi";
  late int selected_time_number = 0; // Initialize with a default value
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  OrderBloc? _OrderBloc;
  final _MejaBloc = MejaBloc(repository: RoomsRepoRepositoryImpl());
  late List<Room>? data_meja = [];
  bool loadingMeja = true;

  @override
  void initState() {
    super.initState();
    _OrderBloc = OrderBloc(repository: OrderRepoRepositoryImpl(context));
    _MejaBloc.add(GetMeja());
  }

  @override
  void dispose() {
    _OrderBloc?.close();
    _MejaBloc?.close();
    super.dispose();
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 400.h,
          child: ListView.builder(
            itemCount: 12, // Assuming 12 hours
            itemBuilder: (BuildContext context, int index) {
              final int hours = index + 1;
              return ListTile(
                title: Text('$hours Hours'),
                onTap: () {
                  setState(() {
                    selected_time = '$hours Hours';
                    selected_time_number = hours;
                  });
                  Navigator.pop(context); // Close the bottom sheet
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _consumerApi() {
    return Column(
      children: [
        BlocConsumer<OrderBloc, OrderState>(
          listener: (c, s) async {
            if (s is OrdersLoadingState) {
              LoadingDialog.show(c, "Mohon tunggu");
            } else if (s is OrdersLoadedOpenBillingState) {
              popScreen(context);
              BottomSheetFeedback.showSuccess(
                  context, "Selamat", s.result.message!);
              NavigationUtils.navigateTo(
                  context, const BottomNavigationScreen(), false);
            } else if (s is OrdersStopLoadedState) {
              popScreen(context);
              BottomSheetFeedback.showSuccess(
                  context, "Selamat", s.result.message!);
              Future.delayed(Duration(seconds: 1), () {
                NavigationUtils.navigateTo(
                    context, const BottomNavigationScreen(), false);
              });
            } else if (s is OrdersErrorState) {
              popScreen(c);
              BottomSheetFeedback.showError(context, "Mohon Maaf", s.message);
            }
          },
          builder: (c, s) {
            return Container(); // Placeholder for loading state
          },
        ),
        BlocConsumer<MejaBloc, MejaState>(
          listener: (c, s) {
            if (s is MejaLoadedState) {
              setState(() {
                loadingMeja = false;
                data_meja = s.result!.data!
                    .where((room) =>
                        (room.status == 0 && room.isMultipleChannel == 0))
                    .toList();
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<OrderBloc>(
            create: (BuildContext context) => _OrderBloc!,
          ),
          BlocProvider<MejaBloc>(
            create: (BuildContext context) => _MejaBloc!,
          ),
        ],
        child: SingleChildScrollView(
          child: Column(
            children: [
              _consumerApi(),
              SizedBox(height: 20.w),
              // Display selected hours

              if (widget.status)
                GestureDetector(
                  onTap: () {
                    _OrderBloc?.add(ActStopOrderOpenBilling(
                      payload: RequestStopOrdersModels(
                        orderId: int.parse(widget.id_order.toString()),
                      ),
                    ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorConstant.off),
                      color: ColorConstant.off,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 50.w,
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
                    child: Center(
                      child: Text(
                        "OFF",
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: ColorConstant.white,
                        ),
                      ),
                    ),
                  ),
                ),

              if (!widget.status)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(hintText: 'Nama Pemesan'),
                      ),
                      SizedBox(height: 8.0),
                      TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(hintText: 'Nomor Whatsapp'),
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 10.w),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: GestureDetector(
                          onTap: () {
                            _showBottomSheet(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorConstant.white,
                              border: Border.all(color: ColorConstant.primary),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            height: 50.w,
                            margin: EdgeInsets.symmetric(vertical: 10.w),
                            child: Center(
                              child: Text(
                                selected_time,
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                  color: ColorConstant.titletext,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              if (!widget.status)
                GestureDetector(
                  onTap: () {
                    if(selected_time_number >0){
                      String enteredName = _nameController.text;
                      String enteredPhone = _phoneController.text;
                      _OrderBloc?.add(ActOrderOpenBilling(
                        payload: RequestOrdersModels(
                          idRooms: widget.id_meja,
                          name: enteredName,
                          phone: enteredPhone,
                          version: ConstantData.version_apps,
                          duration: selected_time_number.toString(),
                        ),
                      ));
                    }else{
                      BottomSheetFeedback.showError(context, "Mohon Maaf", "Pilih Durasi Terlebih dahulu");
                    }

                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorConstant.on),
                      color: ColorConstant.on,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 50.w,
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Center(
                      child: Text(
                        "Simpan",
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: ColorConstant.white,
                        ),
                      ),
                    ),
                  ),
                ),
              // if (widget.status)
              //   loadingMeja
              //       ? CircularProgressIndicator()
              //       : GestureDetector(
              //           onTap: () {},
              //           child: Container(
              //             decoration: BoxDecoration(
              //               border: Border.all(color: ColorConstant.primary),
              //               color: ColorConstant.primary,
              //               borderRadius: BorderRadius.circular(5),
              //             ),
              //             height: 50.w,
              //             margin: EdgeInsets.symmetric(
              //                 horizontal: 20.w, vertical: 10.w),
              //             child: Center(
              //               child: Text(
              //                 "Change Table",
              //                 style: GoogleFonts.plusJakartaSans(
              //                   fontWeight: FontWeight.bold,
              //                   fontSize: 16.sp,
              //                   color: ColorConstant.white,
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
            ],
          ),
        ),
      ),
    );
  }
}

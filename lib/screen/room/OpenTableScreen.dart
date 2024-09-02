import 'dart:convert';

import 'package:carabaobillingapps/service/models/order/RequestStopOrdersModels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../component/loading_dialog.dart';
import '../../constant/color_constant.dart';
import '../../constant/data_constant.dart';
import '../../helper/BottomSheetFeedback.dart';
import '../../helper/global_helper.dart';
import '../../helper/navigation_utils.dart';
import '../../service/bloc/meja/meja_bloc.dart';
import '../../service/bloc/order/order_bloc.dart';
import '../../service/models/order/RequestChangeTable.dart';
import '../../service/models/order/RequestOrdersModels.dart';
import '../../service/models/rooms/ResponseRoomsModels.dart';
import '../../service/repository/OrderRepository.dart';
import '../../service/repository/RoomsRepository.dart';
import '../BottomNavigationScreen.dart';

class OpenTableScreen extends StatefulWidget {
  final String code;
  final String id_meja;
  final bool status;
  final int isMuiltiple;
  final String multipleChannel;
  final String? id_order;
  final String ip;
  final String keys;

  const OpenTableScreen(
      {super.key,
      required this.code,
      required this.id_meja,
      required this.status,
      this.id_order,
      required this.ip,
      required this.keys,
      required this.isMuiltiple,
      required this.multipleChannel});

  @override
  State<OpenTableScreen> createState() => _OpenTableScreenState();
}

class _OpenTableScreenState extends State<OpenTableScreen> {
  OrderBloc? _OrderBloc;

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();
  final _MejaBloc = MejaBloc(repository: RoomsRepoRepositoryImpl());
  late List<Room>? data_meja = [];
  bool loadingMeja = true;

  @override
  void dispose() {
    // TODO: implement dispose
    _OrderBloc?.close();
    _MejaBloc?.close();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    _OrderBloc = OrderBloc(repository: OrderRepoRepositoryImpl(context));
    _MejaBloc.add(GetMeja());
    super.initState();
  }

  void showNameInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Masukkan Detail Pelanggan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(hintText: 'Nama Pemesan'),
              ),
              SizedBox(height: 8.0), // Add some space between the text fields
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(hintText: 'Nomor Whatsapp'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Batalkan'),
            ),
            ElevatedButton(
              onPressed: () {
                String enteredName = _nameController.text;
                String enteredPhone = _phoneController.text;
                _OrderBloc?.add(ActOrderOpenTable(
                    payload: RequestOrdersModels(
                        phone: enteredPhone,
                        version: ConstantData.version_apps,
                        idRooms: widget.id_meja,
                        name: enteredName)));
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showBottomSheetChangeMeja(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 800.h, // Use height unit for responsive height
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: data_meja?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    Room detailMeja = data_meja![index];
                    return ListTile(
                      title: Text(detailMeja.name ?? ""),
                      onTap: () {
                        _OrderBloc?.add(ActChangetableTable(
                            payload: RequestChangeTable(
                                idOrder: int.parse(widget.id_order!),
                                idRooms: detailMeja.id)));
                        // Handle item tap
                      },
                    );
                  },
                ),
              ),
            ],
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
            } else if (s is OrdersLoadedState) {
              popScreen(context);
              BottomSheetFeedback.showSuccess(
                  context, "Selamat", "Selamat Berhasil");
              if (widget.isMuiltiple == 1) {
                List<dynamic> multipleChannelList =
                    jsonDecode(widget.multipleChannel);
                multipleChannelList.forEach((e) {
                  switchLamp(
                    ip: widget.ip,
                    key: widget.keys,
                    code: e,
                    status: true,
                  );
                });
              } else {
                switchLamp(
                    ip: widget.ip,
                    key: widget.keys,
                    code: widget.code,
                    status: true);
              }

              NavigationUtils.navigateTo(
                  context, const BottomNavigationScreen(), false);
            } else if (s is OrdersStopLoadedState) {
              popScreen(context);
              BottomSheetFeedback.showSuccess(
                  context, "Selamat", "Selamat Berhasil");
              if (widget.isMuiltiple == 1) {
                List<dynamic> multipleChannelList =
                    jsonDecode(widget.multipleChannel);
                multipleChannelList.forEach((e) {
                  switchLamp(
                    ip: widget.ip,
                    key: widget.keys,
                    code: e,
                    status: false,
                  );
                });
              } else {
                switchLamp(
                    ip: widget.ip,
                    key: widget.keys,
                    code: widget.code,
                    status: false);
              }
              Future.delayed(Duration(seconds: 1), () {
                NavigationUtils.navigateTo(
                    context, const BottomNavigationScreen(), false);
              });
            } else if (s is OrdersErrorState) {
              popScreen(c);
              BottomSheetFeedback.showError(context, "Mohon Maaf", s.message);
            }
            if (s is OrdersChangeTableLoadingState) {
              LoadingDialog.show(c, "Mohon tunggu");
            } else if (s is OrdersChangeTableLoadedState) {
              popScreen(context);
              BottomSheetFeedback.showSuccess(
                  context, "Selamat", s.result.message!);
              if (ConstantData.lamp_connection) {
                RoomsRepoRepositoryImpl().openRooms(s.result.data!.oldRooms!);
                await Future.delayed(Duration(seconds: 2));
                RoomsRepoRepositoryImpl().openRooms(s.result.data!.newRooms!);
              }
              NavigationUtils.navigateTo(
                  context, const BottomNavigationScreen(), false);
            } else if (s is OrdersChangetableErrorState) {
              popScreen(c);
              BottomSheetFeedback.showError(context, "Mohon Maaf", s.message);
            }
          },
          builder: (c, s) {
            return Container();
          },
        ),
        BlocConsumer<MejaBloc, MejaState>(
          listener: (c, s) {
            if (s is MejaLoadedState) {
              setState(() {
                loadingMeja = false;
                data_meja =
                    s.result!.data!.where((room) => (room.status == 0 &&  room.isMultipleChannel == 0 )).toList();
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
          child: Column(
            children: [
              _consumerApi(),
              SizedBox(
                height: 50.w,
              ),
              if (!widget.status)
                GestureDetector(
                  onTap: () async {
                    showNameInputDialog(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorConstant.on,
                        ),
                        color: ColorConstant.on,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    height: 50.w,
                    margin: EdgeInsets.only(left: 20.w, right: 20.w),
                    padding: EdgeInsets.only(left: 20.w, right: 20.w),
                    child: Center(
                      child: Text(
                        "ON",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 11.sp,
                            color: ColorConstant.white),
                      ),
                    ),
                  ),
                ),
              if (widget.status)
                GestureDetector(
                  onTap: () {
                    _OrderBloc?.add(ActStopOrderOpenTable(
                        payload: RequestStopOrdersModels(
                            orderId: int.parse(widget.id_order.toString()))));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorConstant.off,
                        ),
                        color: ColorConstant.off,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    height: 50.w,
                    margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.w),
                    padding: EdgeInsets.only(left: 20.w, right: 20.w),
                    child: Center(
                      child: Text(
                        "OFF",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 11.sp,
                            color: ColorConstant.white),
                      ),
                    ),
                  ),
                ),
              if (widget.status)
                loadingMeja
                    ? Container(
                        margin: EdgeInsets.only(top: 10.w),
                        child: CircularProgressIndicator(),
                      )
                    : widget.isMuiltiple == 1
                        ? Container()
                        : GestureDetector(
                            onTap: () async {
                              _showBottomSheetChangeMeja(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorConstant.primary,
                                  ),
                                  color: ColorConstant.primary,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              height: 50.w,
                              margin: EdgeInsets.only(
                                  left: 20.w, right: 20.w, top: 10.w),
                              padding: EdgeInsets.only(left: 20.w, right: 20.w),
                              child: Center(
                                child: Text(
                                  "Change Table",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.sp,
                                      color: ColorConstant.white),
                                ),
                              ),
                            ),
                          ),
            ],
          )),
    );
  }
}

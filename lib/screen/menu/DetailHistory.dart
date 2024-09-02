import 'package:carabaobillingapps/service/bloc/order/order_bloc.dart';
import 'package:carabaobillingapps/service/models/order/RequestVoidOrder.dart';
import 'package:carabaobillingapps/service/models/order/ResponseDetailHistory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../component/ItemListHistoryDetail.dart';
import '../../component/loading_dialog.dart';
import '../../constant/color_constant.dart';
import '../../helper/BottomSheetFeedback.dart';
import '../../helper/global_helper.dart';
import '../../service/repository/OrderRepository.dart';

class DetailHistory extends StatefulWidget {
  final String? id_order;

  const DetailHistory({super.key, this.id_order});

  @override
  State<DetailHistory> createState() => _DetailHistoryState();
}

class _DetailHistoryState extends State<DetailHistory> {
  late TextEditingController notes = TextEditingController();
  OrderBloc? _OrderBloc;
  late DetailHistoryItem? dataDetail = null;
  String? _selectedStatus = 'Done';

  @override
  void initState() {
    _OrderBloc = OrderBloc(repository: OrderRepoRepositoryImpl(context));
    _OrderBloc!.add(getDetailHistory(id: widget.id_order!));
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _OrderBloc?.close();
    super.dispose();
  }

  void showNameInputDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Transaction'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: notes,
                decoration: InputDecoration(hintText: 'Enter Reason'),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Select Status',
                ),
                items: [
                  DropdownMenuItem(value: 'Done', child: Text('Done')),
                  DropdownMenuItem(value: 'void', child: Text('Void')),
                  DropdownMenuItem(value: 'no-order', child: Text('No Order')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
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
                String notess = notes.text;
                Navigator.of(context).pop();
                _OrderBloc!.add(ActVoid(
                    payload: RequestVoidOrder(
                        idOrder: int.parse(widget.id_order!),
                        notes: notess,
                        statusData: _selectedStatus)));
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Widget _consumerApi() {
    return Column(
      children: [
        BlocConsumer<OrderBloc, OrderState>(
          listener: (c, s) async {
            if (s is OrdersDetailHistoryLoadingState) {
              LoadingDialog.show(c, "Mohon tunggu");
            } else if (s is OrdersDetailHistoryLoadedState) {
              popScreen(context);
              setState(() {
                dataDetail = s.result!.data![0]!;
              });
            } else if (s is OrdersDetailHistoryErrorState) {
              popScreen(c);
              BottomSheetFeedback.showError(context, "Mohon Maaf", s.message);
            }

            if (s is OrdersVoidLoadingState) {
              LoadingDialog.show(c, "Mohon tunggu");
            } else if (s is OrdersVoidLoadedState) {
              popScreen(context);
              BottomSheetFeedback.showSuccess(
                  context, "Selamat", s.result.message!);
              _OrderBloc!.add(getDetailHistory(id: widget.id_order!));
            } else if (s is OrdersVoidErrorState) {
              popScreen(c);
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
    return Scaffold(
      backgroundColor: ColorConstant.bg,
      appBar: AppBar(
        title: Text('Detail History'),
      ),
      body: MultiBlocProvider(
          providers: [
            BlocProvider<OrderBloc>(
              create: (BuildContext context) => _OrderBloc!,
            ),
          ],
          child: Container(
            child: Stack(
              children: [
                _consumerApi(),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: 20.w, right: 20.w, bottom: 10.w, top: 20.w),
                      decoration: BoxDecoration(
                        color: ColorConstant.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 2.0,
                            spreadRadius: 1.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(15.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ItemListHistoryDetail(
                            title: 'Table No.',
                            value: dataDetail?.namaMeja ?? "",
                          ),
                          SizedBox(
                            height: 10.w,
                          ),
                          ItemListHistoryDetail(
                            title: 'Cust. Name',
                            value: dataDetail?.name ?? "",
                          ),
                          SizedBox(
                            height: 10.w,
                          ),
                          ItemListHistoryDetail(
                            title: 'Phone Number',
                            value: dataDetail?.phone ?? "",
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(left: 20.w, right: 20.w, top: 10.w),
                      decoration: BoxDecoration(
                        color: ColorConstant.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 2.0,
                            spreadRadius: 1.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(15.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ItemListHistoryDetail(
                            title: 'Order Type',
                            value: dataDetail?.type ?? "",
                          ),
                          SizedBox(
                            height: 10.w,
                          ),
                          ItemListHistoryDetail(
                            title: 'Status',
                            value: dataDetail?.statusData ?? "",
                          ),
                          SizedBox(
                            height: 10.w,
                          ),
                          if (dataDetail != null)
                            ItemListHistoryDetail(
                              title: 'Start',
                              value: formatDateTimeWeb(DateTime.parse(
                                      dataDetail!.startTime.toString())) ??
                                  "",
                            ),
                          SizedBox(
                            height: 10.w,
                          ),
                          if (dataDetail != null)
                            ItemListHistoryDetail(
                              title: 'End',
                              value: formatDateTimeWeb(DateTime.parse(
                                      dataDetail!.endTime.toString())) ??
                                  "",
                            ),
                          SizedBox(
                            height: 10.w,
                          ),
                          if (dataDetail != null)
                            ItemListHistoryDetail(
                              title: 'Duration',
                              value: formatDuration(Duration(
                                  seconds: DateTime.parse(
                                          dataDetail!.endTime.toString())
                                      .difference(DateTime.parse(
                                          dataDetail!.startTime.toString()))
                                      .inSeconds)!),
                            ),
                          SizedBox(
                            height: 10.w,
                          ),
                          ItemListHistoryDetail(
                            title: 'Cashier',
                            value: dataDetail?.cashierName.toString() ?? "",
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showNameInputDialog(context);
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
                        margin: EdgeInsets.all(20.w),
                        padding: EdgeInsets.only(left: 20.w, right: 20.w),
                        child: Center(
                          child: Text(
                            "Update",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.sp, color: ColorConstant.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}

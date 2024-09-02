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
import '../../helper/shared_preference.dart';
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
    super.initState();
    _OrderBloc = OrderBloc(repository: OrderRepoRepositoryImpl(context));
    _OrderBloc!.add(getDetailHistory(id: widget.id_order!));
  }

  @override
  void dispose() {
    _OrderBloc?.close();
    super.dispose();
  }

  void showUpdateBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Update Transaction', style: GoogleFonts.plusJakartaSans(fontSize: 18.sp)),
              SizedBox(height: 16.w),
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
                  DropdownMenuItem(value: 'Void', child: Text('Void')),
                  DropdownMenuItem(value: 'No Order', child: Text('No Order')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    child: Text('Cancel', style: TextStyle(color: ColorConstant.primary)),
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
                    child: Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _consumerApi() {
    return BlocConsumer<OrderBloc, OrderState>(
      listener: (c, s) async {
        if (s is OrdersDetailHistoryLoadingState) {
          LoadingDialog.show(c, "Please wait...");
        } else if (s is OrdersDetailHistoryLoadedState) {
          popScreen(context);
          setState(() {
            dataDetail = s.result!.data![0]!;
          });
        } else if (s is OrdersDetailHistoryErrorState) {
          popScreen(c);
          BottomSheetFeedback.showError(context, "Sorry", s.message);
        }

        if (s is OrdersVoidLoadingState) {
          LoadingDialog.show(c, "Please wait...");
        } else if (s is OrdersVoidLoadedState) {
          popScreen(context);
          BottomSheetFeedback.showSuccess(
              context, "Success", s.result.message!);
          _OrderBloc!.add(getDetailHistory(id: widget.id_order!));
        } else if (s is OrdersVoidErrorState) {
          popScreen(c);
          BottomSheetFeedback.showError(context, "Sorry", s.message);
        }
      },
      builder: (c, s) {
        return Container(); // This will hold the loading indicator if needed
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bg,
      appBar: AppBar(
        backgroundColor: ColorConstant.primary,
        title: Text('Detail History',
            style: GoogleFonts.openSans(color: Colors.white)),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<OrderBloc>(
            create: (BuildContext context) => _OrderBloc!,
          ),
        ],
        child: Container(
          margin: EdgeInsets.all(16.w),
          child: Stack(
            children: [
              _consumerApi(),
              Column(
                children: [
                  // Table section for customer details
                  if (dataDetail != null)
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 10.w),
                        padding: EdgeInsets.all(15.w),
                        color: ColorConstant.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Create table-like structure
                            ItemListHistoryDetail(
                              title: 'Table No.',
                              value: dataDetail?.namaMeja ?? "",
                            ),
                            Divider(),
                            ItemListHistoryDetail(
                              title: 'Customer Name',
                              value: dataDetail?.name ?? "",
                            ),
                            Divider(),
                            ItemListHistoryDetail(
                              title: 'Phone Number',
                              value: dataDetail?.phone ?? "",
                            ),
                            Divider(),
                            ItemListHistoryDetail(
                              title: 'Order Type',
                              value: dataDetail?.type ?? "",
                            ),
                            Divider(),
                            ItemListHistoryDetail(
                              title: 'Status',
                              value: dataDetail?.statusData ?? "",
                            ),
                            Divider(),
                            ItemListHistoryDetail(
                              title: 'Start',
                              value: formatDateTimeWeb(DateTime.parse(
                                  dataDetail!.startTime.toString())) ??
                                  "",
                            ),
                            Divider(),
                            ItemListHistoryDetail(
                              title: 'End',
                              value: formatDateTimeWeb(DateTime.parse(
                                  dataDetail!.endTime.toString())) ??
                                  "",
                            ),
                            Divider(),
                            ItemListHistoryDetail(
                              title: 'Duration',
                              value: formatDuration(Duration(
                                  seconds: DateTime
                                      .parse(
                                      dataDetail!.endTime.toString())
                                      .difference(DateTime.parse(
                                      dataDetail!.startTime.toString()))
                                      .inSeconds)!),
                            ),
                            Divider(),
                            ItemListHistoryDetail(
                              title: 'Cashier',
                              value: dataDetail?.cashierName.toString() ?? "",
                            ),
                          ],
                        ),
                      ),
                    ),
                  GestureDetector(
                    onTap: () {
                      showUpdateBottomSheet(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorConstant.primary),
                        color: ColorConstant.primary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      height: 50.w,
                      margin: EdgeInsets.all(20.w),
                      child: Center(
                        child: Text(
                          "Update",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 16.sp, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

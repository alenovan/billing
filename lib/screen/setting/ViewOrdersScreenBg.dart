import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constant/color_constant.dart';
import '../../service/models/order/ResponseListOrdersModels.dart';
import '../../util/DatabaseHelper.dart';

class ViewOrdersScreenBG extends StatefulWidget {
  @override
  _ViewOrdersScreenState createState() => _ViewOrdersScreenState();
}

class _ViewOrdersScreenState extends State<ViewOrdersScreenBG> {
  late Future<List<NewestOrder>> futureOrders;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    futureOrders = DatabaseHelper().getOrders();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      setState(() {
        futureOrders = DatabaseHelper().getOrders();
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Background Tasks'),
      ),
      body: Container(
        margin: EdgeInsets.all(20.w),
        child: FutureBuilder<List<NewestOrder>>(
          future: futureOrders,
          builder: (context, snapshot) {
             if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No orders found.'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  NewestOrder order = snapshot.data![index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 10.w),
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
                    child: ListTile(
                      title: Text('${order.name}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Room ID: ${order.roomId}'),
                          Text('Status Order: ${order.statusOrder}'),
                          Text('Type: ${order.type}'),
                          Text('Order Start Time: ${order.newestOrderStartTime}'),
                          Text('Order End Time: ${order.newestOrderEndTime}'),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class Shimmerx extends StatefulWidget {
  const Shimmerx({Key? key}) : super(key: key);

  @override
  State<Shimmerx> createState() => _ShimmerxState();
}

class _ShimmerxState extends State<Shimmerx> {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      enabled: true,
      child: Container(
        padding: EdgeInsets.all(2.h),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 20,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

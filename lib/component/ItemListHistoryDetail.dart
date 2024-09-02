import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant/color_constant.dart';

class ItemListHistoryDetail extends StatelessWidget {
  final String title;
  final String value;

  const ItemListHistoryDetail(
      {super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: ColorConstant.primary,
            )),
        Text(value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.sp,
              color: ColorConstant.primary,
            ))
      ],
    );
  }
}

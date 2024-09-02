import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant/color_constant.dart';


class ItemListHistory extends StatelessWidget {
  final String title;
  final String value;
  const ItemListHistory({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Expanded(
            flex: 1,
            child: Text(title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorConstant.primary,
                ))),
        Expanded(
            flex: 2,
            child: Row(
              children: [
                Text(":",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.sp,
                      color: ColorConstant.primary,
                    )),
                SizedBox(
                  width: 10.w,
                ),
                Text(value,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.sp,
                      color: ColorConstant.primary,
                    )),
              ],
            )),
      ],
    );
  }
}

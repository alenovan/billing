import 'package:carabaobillingapps/helper/global_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomSheetFeedback {
  const BottomSheetFeedback();

  static Future showError(
      BuildContext context, String title, String description) async {
    double _screenWidth = MediaQuery.of(context).size.width;
    hideKeyboard(context);
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        context: context,
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 45),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: _screenWidth * (15 / 100),
                  height: 7,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(7.5 / 2),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 10.h,
                ),
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 80.h,
                ),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600),
                ),
                Container(
                    margin: EdgeInsets.only(top: 2.h, bottom: 2.h),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 15.sp, fontWeight: FontWeight.w300),
                    ))
              ],
            ),
          );
        });
    return;
  }

  static Future showSuccess(
      BuildContext context, String title, String description) async {
    double _screenWidth = MediaQuery.of(context).size.width;
    hideKeyboard(context);
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        context: context,
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 45),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: _screenWidth * (15 / 100),
                  height: 7,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(7.5 / 2),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 10.h,
                ),
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 80.h,
                ),
                SizedBox(
                  height: 3.h,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600),
                ),
                Container(
                    margin: EdgeInsets.only(top: 2.h, bottom: 2.h),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 17.sp, fontWeight: FontWeight.w300),
                    ))
              ],
            ),
          );
        });
    return;
  }

  static Future showInfo(
      BuildContext context, String title, String description) async {
    double _screenWidth = MediaQuery.of(context).size.width;
    hideKeyboard(context);
    await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        context: context,
        builder: (BuildContext bc) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 45),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: _screenWidth * (15 / 100),
                  height: 7,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(7.5 / 2),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 2.h,
                ),
                Icon(
                  Icons.info_outline,
                  color: Colors.orange,
                  size: 60.h,
                ),
                SizedBox(
                  height: 1.h,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600),
                ),
                Container(
                    margin: EdgeInsets.only(top: 1.h),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(fontSize: 13.sp),
                    ))
              ],
            ),
          );
        });
    return;
  }

}

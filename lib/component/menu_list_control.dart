import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant/color_constant.dart';
import '../helper/global_helper.dart';
import 'loading_dialog.dart';

class MenuListControl extends StatefulWidget {
  final String name;
  final String code;
  final String ip;
  final String keys;
  final int isMultiple;
  final String multipleChannel;

  const MenuListControl({
    super.key,
    required this.name,
    required this.code,
    required this.ip,
    required this.keys,
    required this.isMultiple,
    required this.multipleChannel,
  });

  @override
  State<MenuListControl> createState() => _MenuListControlState();
}

class _MenuListControlState extends State<MenuListControl> {
  Future<void> _switchLamp(bool status) async {
    if (widget.isMultiple == 1) {
      List<dynamic> multipleChannelList = jsonDecode(widget.multipleChannel);
      for (var channel in multipleChannelList) {
        switchLamp(
          ip: widget.ip,
          key: widget.keys,
          code: channel,
          status: status,
        );
      }
    } else {
      switchLamp(
        ip: widget.ip,
        key: widget.keys,
        code: widget.code,
        status: status,
      );
    }
  }

  Future<void> _handleTap(String action) async {
    LoadingDialog.show(context, "Mohon tunggu");

    if (action == 'ON') {
      await _switchLamp(true);
    } else if (action == 'OFF') {
      await _switchLamp(false);
    } else if (action == 'RESET') {
      await _switchLamp(true);
      await Future.delayed(Duration(seconds: 2));
      await _switchLamp(false);
    }

    await Future.delayed(Duration(seconds: 1));
    popScreen(context);
  }

  Widget _buildActionButton(String label, Color color, String action) {
    return GestureDetector(
      onTap: () => _handleTap(action),
      child: Container(
        width: 55.w,
        height: 30.w,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.sp,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: ColorConstant.white,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.sp,
                  color: ColorConstant.titletext,
                ),
              ),
              Row(
                children: [
                  _buildActionButton("Hidup", ColorConstant.on, 'ON'),
                  SizedBox(width: 5.w),
                  _buildActionButton("Mati", ColorConstant.off, 'OFF'),
                  SizedBox(width: 5.w),
                  _buildActionButton("RESET", ColorConstant.primary, 'RESET'),
                ],
              ),
            ],
          ),
          Divider()
        ],
      ),
    );
  }
}

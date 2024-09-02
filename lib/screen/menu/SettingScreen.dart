import 'dart:io';

import 'package:boxicons/boxicons.dart';
import 'package:carabaobillingapps/constant/data_constant.dart';
import 'package:carabaobillingapps/screen/LoginScreen.dart';
import 'package:carabaobillingapps/screen/setting/ClientInformation.dart';
import 'package:carabaobillingapps/screen/setting/PanelSetting.dart';
import 'package:carabaobillingapps/service/bloc/configs/configs_bloc.dart';
import 'package:carabaobillingapps/service/repository/ConfigRepository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../component/loading_dialog.dart';
import '../../constant/color_constant.dart';
import '../../constant/image_constant.dart';
import '../../helper/BottomSheetFeedback.dart';
import '../../helper/global_helper.dart';
import '../../main.dart';
import '../setting/ListSetting.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final _ConfigsBloc = ConfigsBloc(repository: ConfigRepoRepositoryImpl());
  late TextEditingController ipdController = TextEditingController();



  Widget _consumerApi() {
    return Column(
      children: [
        BlocConsumer<ConfigsBloc, ConfigsState>(
          listener: (c, s) {
            if (s is ConfigsLoadingState) {
              LoadingDialog.show(c, "Mohon tunggu");
            } else if (s is ConfigsLoadedState) {
              popScreen(context);
              BottomSheetFeedback.showSuccess(
                  context, "Selamat", s.result.message.toString());
            } else if (s is ConfigsErrorState) {
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
  void initState() {
    // TODO: implement initState
    super.initState();
    // _ConfigsBloc.add(GetConfig());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MultiBlocProvider(
            providers: [
          BlocProvider<ConfigsBloc>(
            create: (BuildContext context) => _ConfigsBloc,
          ),
        ],
            child: ListView(
              children: [
                _consumerApi(),
                Container(
                  child: Column(
                    children: [
                      Image.asset(
                        ImageConstant.logo,
                        width: 150.w,
                      ),
                      Text(
                        "Billiards Lamp Controls",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 15.sp, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                if (ConstantData.lamp_connection)
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  ListSetting()),
                        );
                      },
                      child: Container(
                          margin: EdgeInsets.only(
                              left: 20.w, right: 20.w, top: 10.w),
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
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Table List Control",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.sp,
                                      color: ColorConstant.titletext),
                                ),
                                Icon(
                                  Boxicons.bx_chevron_right,
                                  color: ColorConstant.subtext,
                                )
                              ],
                            ),
                          ))),
                if (ConstantData.lamp_connection)
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PanelSetting()),
                        );
                      },
                      child: Container(
                          margin: EdgeInsets.only(
                              left: 20.w, right: 20.w, top: 10.w),
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
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Panel Setting",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11.sp,
                                      color: ColorConstant.titletext),
                                ),
                                Icon(
                                  Boxicons.bx_chevron_right,
                                  color: ColorConstant.subtext,
                                )
                              ],
                            ),
                          ))),
                InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ClientInformation()),
                      );
                    },
                    child: Container(
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
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Client Information",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11.sp,
                                    color: ColorConstant.titletext),
                              ),
                              Icon(
                                Boxicons.bx_chevron_right,
                                color: ColorConstant.subtext,
                              )
                            ],
                          ),
                        ))),
                InkWell(
                    onTap: () async {
                      if (Platform.isAndroid) {
                        fetchTimer?.cancel();
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: Container(
                        margin: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: ColorConstant.off,
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
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Logout",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11.sp,
                                    color: ColorConstant.white),
                              ),
                            ],
                          ),
                        ))),
              ],
            )));
  }
}

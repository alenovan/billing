import 'dart:convert';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _consumerApi() {
    return Column(
      children: [
        BlocConsumer<ConfigsBloc, ConfigsState>(
          listener: (c, s) {
            if (s is ConfigsLoadingState) {
              LoadingDialog.show(c, "Mohon tunggu");
            } else if (s is ConfigsLoadedState) {
              popScreen(context);
              BottomSheetFeedback.showSuccess(context, "Selamat", s.result.message.toString());
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.primary,
        title: Text(
          "Settings",
          style: GoogleFonts.openSans(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<ConfigsBloc>(
            create: (BuildContext context) => _ConfigsBloc,
          ),
        ],
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 20.w),
          children: [
            _consumerApi(),
            if (ConstantData.lamp_connection)
              _buildSettingItem(
                title: "Table List Control",
                icon: Boxicons.bx_chevron_right,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ListSetting()));
                },
              ),
            if (ConstantData.lamp_connection)
              _buildSettingItem(
                title: "Panel Setting",
                icon: Boxicons.bx_chevron_right,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PanelSetting()));
                },
              ),
            _buildSettingItem(
              title: "Client Information",
              icon: Boxicons.bx_chevron_right,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ClientInformation()));
              },
            ),
            _buildLogoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({required String title, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: ColorConstant.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2.0,
              spreadRadius: 1.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14.sp,
                color: ColorConstant.titletext,
              ),
            ),
            Icon(icon, color: ColorConstant.subtext),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return InkWell(
      onTap: () async {
        // Implement logout logic here
        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      },
      child: Container(
        margin: EdgeInsets.all(20.w),
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: ColorConstant.off,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2.0,
              spreadRadius: 1.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "Logout",
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
              color: ColorConstant.white,
            ),
          ),
        ),
      ),
    );
  }
}

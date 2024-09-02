import 'package:carabaobillingapps/screen/BottomNavigationScreen.dart';
import 'package:carabaobillingapps/service/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../component/loading_dialog.dart';
import '../constant/color_constant.dart';
import '../constant/image_constant.dart';
import '../helper/BottomSheetFeedback.dart';
import '../helper/global_helper.dart';
import '../helper/navigation_utils.dart';
import '../service/models/auth/RequestLoginModels.dart';
import '../service/repository/LoginRepository.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _AuthBloc = AuthBloc(repository: LoginRepoRepositoryImpl());
  late TextEditingController usernameController = TextEditingController();
  late TextEditingController passwordController = TextEditingController();
  var token_firebase = "";

  Widget _consumerApi() {
    return Column(
      children: [
        BlocConsumer<AuthBloc, AuthState>(
          listener: (c, s) {
            if (s is AuthLoadingState) {
              LoadingDialog.show(c, "Mohon tunggu");
            } else if (s is AuthLoadedState) {
              popScreen(context);
              BottomSheetFeedback.showSuccess(
                  context, "Selamat", "Login berhasil");
              NavigationUtils.navigateTo(
                  context, const BottomNavigationScreen(), false);
            } else if (s is AuthErrorState) {
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
    _checkNotificationPermission();


  }

  Future<void> _checkNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;
    if (!status.isGranted) {
      // If notification permission is not granted, request permission
      status = await Permission.notification.request();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorConstant.bg,
      body: MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (BuildContext context) => _AuthBloc,
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
              SizedBox(
                height: 15.w,
              ),
              Container(
                margin: EdgeInsets.all(20.w),
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
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: ColorConstant.borderinput,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.w, horizontal: 16.w),
                      ),
                      controller: usernameController,
                      // Add controller and other TextFormField properties as needed
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: ColorConstant.borderinput,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 12.w, horizontal: 16.w),
                      ),
                      controller: passwordController,
                      // Add controller and other TextFormField properties as needed
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        _AuthBloc
                          ..add(ActLogin(
                              payload: RequestLoginModels(
                                  username: usernameController.text,
                                  password: passwordController.text)));
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
                        padding: EdgeInsets.only(left: 20.w, right: 20.w),
                        child: Center(
                          child: Text(
                            "Simpan",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.sp, color: ColorConstant.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}

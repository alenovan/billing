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
      resizeToAvoidBottomInset: true,
      body: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (BuildContext context) => _AuthBloc,
          ),
        ],
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Color(0xFF00a848)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _consumerApi(),
                  Image.asset(
                    ImageConstant.logo,
                    width: 200.w,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "ControlHUB",
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 24.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 40.h),
                  Container(
                    decoration: BoxDecoration(
                      color: ColorConstant.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person, color: Color(0xFF00a848)), // Ikon untuk username
                            hintText: 'Username', // Menggunakan hint text
                            hintStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: ColorConstant.borderinput,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 16.w),
                          ),
                          controller: usernameController,
                        ),
                        SizedBox(height: 15), // Memperbesar jarak antar field
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock, color: Color(0xFF00a848)), // Ikon untuk password
                            hintText: 'Password', // Menggunakan hint text
                            hintStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: ColorConstant.borderinput,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 16.w),
                          ),
                          controller: passwordController,
                        ),
                        SizedBox(height: 20), // Memperbesar jarak sebelum tombol
                        GestureDetector(
                          onTap: () {
                            _AuthBloc.add(ActLogin(
                                payload: RequestLoginModels(
                                    username: usernameController.text,
                                    password: passwordController.text)));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF00a848), // Warna tombol
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                            ),
                            height: 50.w,
                            alignment: Alignment.center,
                            child: Text(
                              "Simpan",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16.sp, color: ColorConstant.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:carabaobillingapps/service/models/rooms/RequestPanelModels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../component/loading_dialog.dart';
import '../../constant/color_constant.dart';
import '../../constant/data_constant.dart';
import '../../helper/BottomSheetFeedback.dart';
import '../../helper/global_helper.dart';
import '../../service/bloc/meja/meja_bloc.dart';
import '../../service/repository/RoomsRepository.dart';

class PanelSetting extends StatefulWidget {
  const PanelSetting({super.key});

  @override
  State<PanelSetting> createState() => _PanelSettingState();
}

class _PanelSettingState extends State<PanelSetting> {
  final _MejaBloc = MejaBloc(repository: RoomsRepoRepositoryImpl());
  late dynamic meja = [];
  late TextEditingController ipdController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _MejaBloc.add(GetPanel());
  }

  Widget _consumerApi() {
    return Column(
      children: [
        BlocConsumer<MejaBloc, MejaState>(
          listener: (c, s) {
            if (s is MejaLoadingState) {
              LoadingDialog.show(context, "Mohon tunggu");
            } else if (s is PanelLoadedState) {
              popScreen(context);
              setState(() {
                ipdController.text = s.result.data!.ip! ?? "";
                ConstantData.ip_default = ipdController.text;
                meja = s.result.data!;
              });
            } else if (s is PanelUpdateLoadedState) {
              popScreen(context);
              BottomSheetFeedback.showSuccess(context, "Selamat", s.result.message ?? "");
            } else if (s is MejaErrorState) {
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
      backgroundColor: ColorConstant.bg,
      appBar: AppBar(
        title: Text('IP Setting'),
      ),
      body: MultiBlocProvider(
          providers: [
            BlocProvider<MejaBloc>(
              create: (BuildContext context) => _MejaBloc,
            ),
          ],
          child: Container(
            child: Stack(
              children: [
                _consumerApi(),
                Column(
                  children: [
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
                              labelText: 'Enter IP Address',
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
                              contentPadding:
                              EdgeInsets.symmetric(vertical: 12.w, horizontal: 16.w),
                            ),
                            controller: ipdController,
                            // Add controller and other TextFormField properties as needed
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _MejaBloc.add(updatePanel(payload: RequestPanelModels(
                          ip: ipdController.text,
                          panelId: 1
                        ), id: "1"));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorConstant.primary,
                            ),
                            color: ColorConstant.primary,
                            borderRadius: BorderRadius.all(Radius.circular(50))),
                        height: 50.w,
                        margin: EdgeInsets.all(20.w),
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
                )
              ],
            ),
          )),
    );
  }
}

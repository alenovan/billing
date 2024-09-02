import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../component/loading_dialog.dart';
import '../../constant/color_constant.dart';
import '../../constant/data_constant.dart';
import '../../helper/BottomSheetFeedback.dart';
import '../../helper/global_helper.dart';
import '../../service/bloc/configs/configs_bloc.dart';
import '../../service/models/configs/ResponseClientInformation.dart';
import '../../service/repository/ConfigRepository.dart';

class ClientInformation extends StatefulWidget {
  const ClientInformation({super.key});

  @override
  State<ClientInformation> createState() => _ClientInformationState();
}

class _ClientInformationState extends State<ClientInformation> {
  final _ConfigsBloc = ConfigsBloc(repository: ConfigRepoRepositoryImpl());
  DetailInformation? detailInformation;

  Widget _consumerApi() {
    return Column(
      children: [
        BlocConsumer<ConfigsBloc, ConfigsState>(
          listener: (c, s) {
            if (s is ConfigsLoadingState) {
              LoadingDialog.show(c, "Mohon tunggu");
            } else if (s is ConfigsListLoadedState) {
              popScreen(context);
              setState(() {
                detailInformation = s.result.data!.first!;
              });
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
    _ConfigsBloc.add(GetConfig());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Client Information'),
        ),
        body: MultiBlocProvider(
            providers: [
              BlocProvider<ConfigsBloc>(
                create: (BuildContext context) => _ConfigsBloc,
              ),
            ],
            child: Wrap(
              children: [
                _consumerApi(),
                Container(
                    margin:
                        EdgeInsets.only(left: 20.w, right: 20.w, bottom: 10.w,top: 20.w),
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
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Client Name",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstant.primary,
                                  )),
                              Text(detailInformation?.clientName ?? "",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.bold
                                  )),
                            ],
                          ),
                          SizedBox(height: 10.w,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Client Id",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstant.primary,
                                  )),
                              Text(detailInformation?.clientId.toString() ?? "",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                          SizedBox(height: 10.w,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Apk Version",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstant.primary,
                                  )),
                              Text(ConstantData.version_apps,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ))
              ],
            )));
  }
}

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
  late final ConfigsBloc _configsBloc;
  DetailInformation? detailInformation;

  @override
  void initState() {
    super.initState();
    _configsBloc = ConfigsBloc(repository: ConfigRepoRepositoryImpl());
    _configsBloc.add(GetConfig());
  }

  @override
  void dispose() {
    _configsBloc.close();
    super.dispose();
  }

  Widget _buildClientInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: ColorConstant.primary,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientInfoCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
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
      padding: EdgeInsets.all(15.w),
      child: Column(
        children: [
          _buildClientInfoRow("Client Name", detailInformation?.clientName ?? ""),
          _buildClientInfoRow("Client Id", detailInformation?.clientId.toString() ?? ""),
          _buildClientInfoRow("Apk Version", ConstantData.version_apps),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConstant.primary,
        title: Text(
          "Client Information",
          style: GoogleFonts.openSans(color: Colors.white),
        ),
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<ConfigsBloc>(
            create: (_) => _configsBloc,
          ),
        ],
        child: BlocConsumer<ConfigsBloc, ConfigsState>(
          listener: (context, state) {
            if (state is ConfigsLoadingState) {
              LoadingDialog.show(context, "Mohon tunggu");
            } else if (state is ConfigsListLoadedState) {
              popScreen(context);
              setState(() {
                detailInformation = state.result.data?.first;
              });
            } else if (state is ConfigsErrorState) {
              popScreen(context);
              BottomSheetFeedback.showError(context, "Mohon Maaf", state.message);
            }
          },
          builder: (context, state) {
            return ListView(
              children: [
                _buildClientInfoCard(),
              ],
            );
          },
        ),
      ),
    );
  }
}

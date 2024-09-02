import 'dart:convert';

import 'package:carabaobillingapps/constant/data_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../component/menu_list_control.dart';
import '../../constant/color_constant.dart';
import '../../service/bloc/meja/meja_bloc.dart';
import '../../service/models/rooms/ResponseRoomsModels.dart';
import '../../service/repository/RoomsRepository.dart';

class ListSetting extends StatefulWidget {
  const ListSetting({super.key});

  @override
  State<ListSetting> createState() => _ListSettingState();
}

class _ListSettingState extends State<ListSetting> {
  final _MejaBloc = MejaBloc(repository: RoomsRepoRepositoryImpl());
  late TextEditingController searchController = TextEditingController();
  ResponseRoomsModels? data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    searchController.text = ConstantData.ip_default;
  }

  fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('result_meja');
    if (jsonString != null) {
      setState(() {
        data = ResponseRoomsModels.fromJson(json.decode(jsonString));
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.bg,
      appBar: AppBar(
        title: Text('List Table'),
      ),
      body: MultiBlocProvider(
          providers: [
            BlocProvider<MejaBloc>(
              create: (BuildContext context) => _MejaBloc,
            ),
          ],
          child: Container(
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.all(20.w),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Ip',
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
                          EdgeInsets.symmetric(vertical: 2.w, horizontal: 16.w),
                    ),
                    controller: searchController,
                    onChanged: (e) {
                      setState(() {
                        ConstantData.ip_default = e;
                        searchController.text = e;
                      });
                    },
                    // Add controller and other TextFormField properties as needed
                  ),
                ),
                ListView.builder(
                  itemCount: data!.data!.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return MenuListControl(
                      name: data!.data![index].name!,
                      code: data!.data![index].code!,
                      ip: searchController.text,
                      keys: ConstantData.key_config,
                      isMuiltiple: data!.data![index].isMultipleChannel,
                      multipleChannel: data!.data![index].multipleChannel ?? "",
                    );
                  },
                )
              ],
            ),
          )),
    );
  }
}

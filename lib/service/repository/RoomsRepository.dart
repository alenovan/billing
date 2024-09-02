import 'dart:convert';

import 'package:carabaobillingapps/constant/data_constant.dart';
import 'package:carabaobillingapps/service/models/rooms/RequestPanelModels.dart';
import 'package:carabaobillingapps/service/models/rooms/ResponseRoomsModels.dart';
import 'package:http/http.dart' as http;

import '../../constant/url_constant.dart';
import '../../helper/global_helper.dart';
import '../models/rooms/ResponsePanelModels.dart';
import '../models/rooms/ResponseUpdatePanelModels.dart';

abstract class RoomsRepo {
  Future<ResponseRoomsModels> getRooms();

  Future<dynamic> openRooms(String link);

  Future<ResponsePanelModels> getPanel();

  Future<ResponseUpdatePanelModels> updatePanel(
      RequestPanelModels payload, String id);
}

class RoomsRepoRepositoryImpl implements RoomsRepo {
  @override
  Future<ResponseRoomsModels> getRooms() async {
    // TODO: implement getRooms
    var response = await http.get(Uri.parse(UrlConstant.rooms),
        headers: await tokenHeader(true));
    if (response.statusCode == 200) {
      ResponseRoomsModels responses =
          responseRoomsModelsFromJson(response.body);
      return responses;
    } else if (response.statusCode == 522 ||
        response.statusCode == 502 ||
        response.statusCode == 504 ||
        response.statusCode == 500) {
      throw ("Silahkan Ulangi Kembali");
    } else {
      var responses = jsonDecode(response.body);
      throw ("${responses["message"]}");
    }
  }

  @override
  Future openRooms(String link) async {
    // TODO: implement openRooms
    if (ConstantData.lamp_connection) {
      var response =
          await http.post(Uri.parse(link), headers: await tokenHeader(true));
    }

    return "Success";
  }

  @override
  Future<ResponsePanelModels> getPanel() async {
    // TODO: implement getPanel
    var response = await http.get(Uri.parse(UrlConstant.panels),
        headers: await tokenHeader(true));
    if (response.statusCode == 200) {
      ResponsePanelModels responses =
          responsePanelModelsFromJson(response.body);
      return responses;
    } else if (response.statusCode == 522 ||
        response.statusCode == 502 ||
        response.statusCode == 504 ||
        response.statusCode == 400 ||
        response.statusCode == 500) {
      throw ("Silahkan Ulangi Kembali");
    } else {
      var responses = jsonDecode(response.body);
      throw ("${responses["message"]}");
    }
  }

  @override
  Future<ResponseUpdatePanelModels> updatePanel(
      RequestPanelModels payload, String id) async {
    // TODO: implement updatePanel
    var body = jsonEncode(payload);
    var response = await http.post(Uri.parse(UrlConstant.panelsupdate),
        body: body, headers: await tokenHeader(true));
    if (response.statusCode == 200) {
      ResponseUpdatePanelModels responses =
          responseUpdatePanelModelsFromJson(response.body);
      return responses;
    } else if (response.statusCode == 522 ||
        response.statusCode == 502 ||
        response.statusCode == 504 ||
        response.statusCode == 500) {
      throw ("Silahkan Ulangi Kembali");
    } else {
      var responses = jsonDecode(response.body);
      throw ("${responses["message"]}");
    }
  }
}

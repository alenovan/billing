import 'dart:convert';

import 'package:carabaobillingapps/service/models/order/RequestChangeTable.dart';
import 'package:carabaobillingapps/service/models/order/RequestOrderSearch.dart';
import 'package:carabaobillingapps/service/models/order/RequestOrdersModels.dart';
import 'package:carabaobillingapps/service/models/order/RequestStopOrdersModels.dart';
import 'package:carabaobillingapps/service/models/order/RequestVoidOrder.dart';
import 'package:carabaobillingapps/service/models/order/ResponseChangeTable.dart';
import 'package:carabaobillingapps/service/models/order/ResponseListOrdersModels.dart';
import 'package:carabaobillingapps/service/models/order/ResponseOrderHistoryModels.dart';
import 'package:carabaobillingapps/service/models/order/ResponseOrdersModels.dart';
import 'package:carabaobillingapps/service/models/order/ResponseStopOrdersModels.dart';
import 'package:carabaobillingapps/service/models/order/ResponseVoidOrder.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';

import '../../constant/url_constant.dart';
import '../../helper/global_helper.dart';
import '../models/order/ResponseDetailHistory.dart';
import '../models/order/ResponseOrdersBgModels.dart';
import '../models/order/ResponseOrdersOpenBillingModels.dart';
import 'LoggingInterceptor.dart';

abstract class OrderRepo {
  Future<ResponseListOrdersModels> getOrder();

  Future<ResponseOrdersBgModels> getOrderBg();

  Future<ResponseOrdersOpenBillingModels> order_open_billing(
      RequestOrdersModels payload);

  Future<ResponseStopOrdersModels> stop_order_open_billing(
      RequestStopOrdersModels payload);

  Future<ResponseOrdersModels> order_open_table(RequestOrdersModels payload);

  Future<ResponseStopOrdersModels> stop_order_open_table(
      RequestStopOrdersModels payload);

  Future<ResponseOrderHistoryModels> OrderHistory(RequestOrderSearch payload);

  Future<ResponseChangeTable> changeTable(RequestChangeTable payload);

  Future<ResponseVoidOrder> voidTable(RequestVoidOrder payload);

  Future<ResponseDetailHistory> historyDetail(String id);

  Future<ResponseListOrdersModels> getOrdersDetail(String id);
}

class OrderRepoRepositoryImpl implements OrderRepo {
  final Client _client;

  OrderRepoRepositoryImpl(BuildContext context)
      : _client = InterceptedClient.build(
          interceptors: [LoggingInterceptor(context)],
        );

  @override
  Future<ResponseListOrdersModels> getOrder() async {
    // TODO: implement getOrder
    var response = await _client.get(Uri.parse(UrlConstant.newest_orders),
        headers: await tokenHeader(true));
    if (response.statusCode == 200) {
      ResponseListOrdersModels responses =
          responseListOrdersModelsFromJson(response.body);
      return responses;
    } else if (response.statusCode == 522 ||
        response.statusCode == 502 ||
        response.statusCode == 400 ||
        response.statusCode == 504 ||
        response.statusCode == 500) {
      throw ("Silahkan Ulangi Kembali");
    } else if (response.statusCode == 401) {
      throw ("Silahkan Login Kembali ya");
    } else {
      var responses = jsonDecode(response.body);
      throw ("${responses["message"]}");
    }
  }

  @override
  Future<ResponseOrdersBgModels> getOrderBg() async {
    // TODO: implement getOrder
    var response = await http.get(Uri.parse(UrlConstant.newest_orders_bg),
        headers: await tokenHeader(true));
    if (response.statusCode == 200) {
      ResponseOrdersBgModels responses =
          responseOrdersBgModelsFromJson(response.body);
      return responses;
    } else if (response.statusCode == 522 ||
        response.statusCode == 502 ||
        response.statusCode == 400 ||
        response.statusCode == 504 ||
        response.statusCode == 500) {
      throw ("Silahkan Ulangi Kembali");
    } else {
      var responses = jsonDecode(response.body);
      throw ("${responses["message"]}");
    }
  }

  @override
  Future<ResponseOrdersOpenBillingModels> order_open_billing(
      RequestOrdersModels payload) async {
    // TODO: implement updateOrder
    var body = jsonEncode(payload);
    var response = await http.post(Uri.parse(UrlConstant.order_open_billing),
        body: body, headers: await tokenHeader(true));
    if (response.statusCode == 200) {
      ResponseOrdersOpenBillingModels responses =
          responseOrdersOpenBillingModelsFromJson(response.body);
      return responses;
    } else if (response.statusCode == 522 ||
        response.statusCode == 502 ||
        response.statusCode == 400 ||
        response.statusCode == 504 ||
        response.statusCode == 500) {
      throw ("Silahkan Ulangi Kembali");
    } else {
      var responses = jsonDecode(response.body);
      throw ("${responses["message"]}");
    }
  }

  @override
  Future<ResponseStopOrdersModels> stop_order_open_billing(
      RequestStopOrdersModels payload) async {
    // TODO: implement stop_order
    var body = jsonEncode(payload);
    var response = await http.post(Uri.parse(UrlConstant.order_stop_billing),
        body: body, headers: await tokenHeader(true));
    if (response.statusCode == 200) {
      ResponseStopOrdersModels responses =
          responseStopOrdersModelsFromJson(response.body);
      return responses;
    } else if (response.statusCode == 522 ||
        response.statusCode == 502 ||
        response.statusCode == 400 ||
        response.statusCode == 504 ||
        response.statusCode == 500) {
      throw ("Silahkan Ulangi Kembali");
    } else {
      var responses = jsonDecode(response.body);
      throw ("${responses["message"]}");
    }
  }

  @override
  Future<ResponseOrdersModels> order_open_table(
      RequestOrdersModels payload) async {
    // TODO: implement updateOrder
    var body = jsonEncode(payload);
    var response = await http.post(Uri.parse(UrlConstant.order_open_table),
        body: body, headers: await tokenHeader(true));
    if (response.statusCode == 200) {
      ResponseOrdersModels responses =
          responseOrdersModelsFromJson(response.body);
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
  Future<ResponseStopOrdersModels> stop_order_open_table(
      RequestStopOrdersModels payload) async {
    // TODO: implement stop_order
    var body = jsonEncode(payload);
    var response = await http.post(Uri.parse(UrlConstant.order_stop_table),
        body: body, headers: await tokenHeader(true));
    if (response.statusCode == 200) {
      ResponseStopOrdersModels responses =
          responseStopOrdersModelsFromJson(response.body);
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
  Future<ResponseOrderHistoryModels> OrderHistory(
      RequestOrderSearch payload) async {
    // TODO: implement OrderHistory
    var body = jsonEncode(payload);
    var response = await http.post(Uri.parse(UrlConstant.history_orders),
        body: body, headers: await tokenHeader(true));
    if (response.statusCode == 200) {
      ResponseOrderHistoryModels responses =
          responseOrderHistoryModelsFromJson(response.body);
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
  Future<ResponseChangeTable> changeTable(RequestChangeTable payload) async {
    // TODO: implement changeTable
    var body = jsonEncode(payload);
    var response = await http.post(Uri.parse(UrlConstant.change_table),
        body: body, headers: await tokenHeader(true));
    if (response.statusCode == 200) {
      ResponseChangeTable responses =
          responseChangeTableFromJson(response.body);
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
  Future<ResponseVoidOrder> voidTable(RequestVoidOrder payload) async {
    // TODO: implement voidTable
    var body = jsonEncode(payload);
    var response = await http.post(Uri.parse(UrlConstant.void_table),
        body: body, headers: await tokenHeader(true));
    if (response.statusCode == 200) {
      ResponseVoidOrder responses = responseVoidOrderFromJson(response.body);
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
  Future<ResponseDetailHistory> historyDetail(String id) async {
    // TODO: implement historyDetail
    var response = await http.get(Uri.parse(UrlConstant.detail_history + id),
        headers: await tokenHeader(true));
    if (response.statusCode == 200) {
      ResponseDetailHistory responses =
          responseDetailHistoryFromJson(response.body);
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
  Future<ResponseListOrdersModels> getOrdersDetail(String id) async {
    // TODO: implement getOrdersDetail
    var response = await http.get(
        Uri.parse(UrlConstant.newest_orders + "/" + id),
        headers: await tokenHeader(true));
    if (response.statusCode == 200) {
      ResponseListOrdersModels responses =
          responseListOrdersModelsFromJson(response.body);
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

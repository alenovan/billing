// To parse this JSON data, do
//
//     final responseOrderHistoryModels = responseOrderHistoryModelsFromJson(jsonString);

import 'dart:convert';

ResponseOrderHistoryModels responseOrderHistoryModelsFromJson(String str) =>
    ResponseOrderHistoryModels.fromJson(json.decode(str));

String responseOrderHistoryModelsToJson(ResponseOrderHistoryModels data) =>
    json.encode(data.toJson());

class ResponseOrderHistoryModels {
  bool? status;
  String? message;
  Data? data;

  ResponseOrderHistoryModels({
    this.status,
    this.message,
    this.data,
  });

  factory ResponseOrderHistoryModels.fromJson(Map<String, dynamic> json) =>
      ResponseOrderHistoryModels(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  int? total;
  List<MatchedOrder>? matchedOrders;

  Data({
    this.total,
    this.matchedOrders,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        total: json["total"],
        matchedOrders: json["matchedOrders"] == null
            ? []
            : List<MatchedOrder>.from(
                json["matchedOrders"]!.map((x) => MatchedOrder.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "matchedOrders": matchedOrders == null
            ? []
            : List<dynamic>.from(matchedOrders!.map((x) => x.toJson())),
      };
}

class MatchedOrder {
  String? name;
  String? statusOrder;
  String? type;
  String? ordersName;
  String? statusData;
  int? id;
  DateTime? startTime;
  DateTime? endTime;
  int? durationMinutes;
  String? cashierName;

  MatchedOrder({
    this.name,
    this.statusOrder,
    this.type,
    this.ordersName,
    this.statusData,
    this.id,
    this.startTime,
    this.endTime,
    this.durationMinutes,
    this.cashierName,
  });

  factory MatchedOrder.fromJson(Map<String, dynamic> json) => MatchedOrder(
        name: json["name"],
        statusOrder: json["status_order"],
        type: json["type"],
        ordersName: json["orders_name"],
        statusData: json["status_data"],
        id: json["id"],
        startTime: json["start_time"] == null
            ? null
            : DateTime.parse(json["start_time"]),
        endTime:
            json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
        durationMinutes: json["duration_minutes"],
        cashierName: json["cashier_name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "status_order": statusOrder,
        "type": type,
        "orders_name": ordersName,
        "status_data": statusData,
        "id": id,
        "start_time": startTime?.toIso8601String(),
        "end_time": endTime?.toIso8601String(),
        "duration_minutes": durationMinutes,
        "cashier_name": cashierName,
      };
}

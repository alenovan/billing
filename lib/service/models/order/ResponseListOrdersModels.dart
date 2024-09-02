// To parse this JSON data, do
//
//     final responseListOrdersModels = responseListOrdersModelsFromJson(jsonString);

import 'dart:convert';

ResponseListOrdersModels responseListOrdersModelsFromJson(String str) => ResponseListOrdersModels.fromJson(json.decode(str));

String responseListOrdersModelsToJson(ResponseListOrdersModels data) => json.encode(data.toJson());

class ResponseListOrdersModels {
  bool? status;
  String? message;
  List<NewestOrder>? data;

  ResponseListOrdersModels({
    this.status,
    this.message,
    this.data,
  });

  factory ResponseListOrdersModels.fromJson(Map<String, dynamic> json) => ResponseListOrdersModels(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<NewestOrder>.from(json["data"]!.map((x) => NewestOrder.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class NewestOrder {
  int? roomId;
  String? code;
  String? multipleChannel;
  int? isMultipleChannel;
  String? name;
  int? statusRooms;
  String? statusOrder;
  String? type;
  String? ip;
  String? secret;
  int? id;
  String? newestOrderStartTime;
  String? newestOrderEndTime;

  NewestOrder({
    this.roomId,
    this.code,
    this.multipleChannel,
    this.isMultipleChannel,
    this.name,
    this.statusRooms,
    this.statusOrder,
    this.type,
    this.ip,
    this.secret,
    this.id,
    this.newestOrderStartTime,
    this.newestOrderEndTime,
  });

  factory NewestOrder.fromJson(Map<String, dynamic> json) => NewestOrder(
    roomId: json["room_id"],
    code: json["code"],
    multipleChannel: json["multiple_channel"],
    isMultipleChannel: json["is_multiple_channel"],
    name: json["name"],
    statusRooms: json["status_rooms"],
    statusOrder: json["status_order"],
    type: json["type"],
    ip: json["ip"],
    secret: json["secret"],
    id: json["id"],
    newestOrderStartTime: json["newest_order_start_time"],
    newestOrderEndTime: json["newest_order_end_time"],
  );

  Map<String, dynamic> toJson() => {
    "room_id": roomId,
    "code": code,
    "multiple_channel": multipleChannel,
    "is_multiple_channel": isMultipleChannel,
    "name": name,
    "status_rooms": statusRooms,
    "status_order": statusOrder,
    "type": type,
    "ip": ip,
    "secret": secret,
    "id": id,
    "newest_order_start_time": newestOrderStartTime,
    "newest_order_end_time": newestOrderEndTime,
  };
}

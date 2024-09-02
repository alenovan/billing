// To parse this JSON data, do
//
//     final responseOrdersBgModels = responseOrdersBgModelsFromJson(jsonString);

import 'dart:convert';

import 'package:carabaobillingapps/service/models/order/ResponseListOrdersModels.dart';

ResponseOrdersBgModels responseOrdersBgModelsFromJson(String str) => ResponseOrdersBgModels.fromJson(json.decode(str));

String responseOrdersBgModelsToJson(ResponseOrdersBgModels data) => json.encode(data.toJson());

class ResponseOrdersBgModels {
  bool? status;
  String? message;
  List<NewestOrder>? data;

  ResponseOrdersBgModels({
    this.status,
    this.message,
    this.data,
  });

  factory ResponseOrdersBgModels.fromJson(Map<String, dynamic> json) => ResponseOrdersBgModels(
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

// class NewestOrderBg {
//   int? roomId;
//   String? code;
//   String? name;
//   int? statusRooms;
//   String? statusOrder;
//   String? type;
//   String? ip;
//   String? secret;
//   int? id;
//   DateTime? newestOrderStartTime;
//   DateTime? newestOrderEndTime;
//
//   NewestOrderBg({
//     this.roomId,
//     this.code,
//     this.name,
//     this.statusRooms,
//     this.statusOrder,
//     this.type,
//     this.ip,
//     this.secret,
//     this.id,
//     this.newestOrderStartTime,
//     this.newestOrderEndTime,
//   });
//
//   factory NewestOrderBg.fromJson(Map<String, dynamic> json) => NewestOrderBg(
//     roomId: json["room_id"],
//     code: json["code"],
//     name: json["name"],
//     statusRooms: json["status_rooms"],
//     statusOrder: json["status_order"],
//     type: json["type"],
//     ip: json["ip"],
//     secret: json["secret"],
//     id: json["id"],
//     newestOrderStartTime: json["newest_order_start_time"] == null ? null : DateTime.parse(json["newest_order_start_time"]),
//     newestOrderEndTime: json["newest_order_end_time"] == null ? null : DateTime.parse(json["newest_order_end_time"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "room_id": roomId,
//     "code": code,
//     "name": name,
//     "status_rooms": statusRooms,
//     "status_order": statusOrder,
//     "type": type,
//     "ip": ip,
//     "secret": secret,
//     "id": id,
//     "newest_order_start_time": newestOrderStartTime?.toIso8601String(),
//     "newest_order_end_time": newestOrderEndTime?.toIso8601String(),
//   };
// }

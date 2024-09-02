// To parse this JSON data, do
//
//     final responseOrdersOpenBillingModels = responseOrdersOpenBillingModelsFromJson(jsonString);

import 'dart:convert';

ResponseOrdersOpenBillingModels responseOrdersOpenBillingModelsFromJson(String str) => ResponseOrdersOpenBillingModels.fromJson(json.decode(str));

String responseOrdersOpenBillingModelsToJson(ResponseOrdersOpenBillingModels data) => json.encode(data.toJson());

class ResponseOrdersOpenBillingModels {
  bool? status;
  String? message;
  Data? data;

  ResponseOrdersOpenBillingModels({
    this.status,
    this.message,
    this.data,
  });

  factory ResponseOrdersOpenBillingModels.fromJson(Map<String, dynamic> json) => ResponseOrdersOpenBillingModels(
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
  String? idRooms;
  int? idUsers;
  DateTime? startTime;
  DateTime? endTime;
  String? status;
  String? type;
  String? name;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  Data({
    this.idRooms,
    this.idUsers,
    this.startTime,
    this.endTime,
    this.status,
    this.type,
    this.name,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    idRooms: json["id_rooms"],
    idUsers: json["id_users"],
    startTime: json["start_time"] == null ? null : DateTime.parse(json["start_time"]),
    endTime: json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
    status: json["status"],
    type: json["type"],
    name: json["name"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id_rooms": idRooms,
    "id_users": idUsers,
    "start_time": startTime?.toIso8601String(),
    "end_time": endTime?.toIso8601String(),
    "status": status,
    "type": type,
    "name": name,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
  };
}

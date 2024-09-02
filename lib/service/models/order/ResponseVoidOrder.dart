// To parse this JSON data, do
//
//     final responseVoidOrder = responseVoidOrderFromJson(jsonString);

import 'dart:convert';

ResponseVoidOrder responseVoidOrderFromJson(String str) => ResponseVoidOrder.fromJson(json.decode(str));

String responseVoidOrderToJson(ResponseVoidOrder data) => json.encode(data.toJson());

class ResponseVoidOrder {
  bool? status;
  String? message;
  Data? data;

  ResponseVoidOrder({
    this.status,
    this.message,
    this.data,
  });

  factory ResponseVoidOrder.fromJson(Map<String, dynamic> json) => ResponseVoidOrder(
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
  int? id;
  String? idRooms;
  String? idUsers;
  DateTime? startTime;
  DateTime? endTime;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? status;
  String? type;
  String? name;
  String? statusData;
  String? notes;
  String? phone;

  Data({
    this.id,
    this.idRooms,
    this.idUsers,
    this.startTime,
    this.endTime,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.type,
    this.name,
    this.statusData,
    this.notes,
    this.phone,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    idRooms: json["id_rooms"],
    idUsers: json["id_users"],
    startTime: json["start_time"] == null ? null : DateTime.parse(json["start_time"]),
    endTime: json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    status: json["status"],
    type: json["type"],
    name: json["name"],
    statusData: json["status_data"],
    notes: json["notes"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_rooms": idRooms,
    "id_users": idUsers,
    "start_time": startTime?.toIso8601String(),
    "end_time": endTime?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "status": status,
    "type": type,
    "name": name,
    "status_data": statusData,
    "notes": notes,
    "phone": phone,
  };
}

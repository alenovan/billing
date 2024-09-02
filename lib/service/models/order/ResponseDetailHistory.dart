// To parse this JSON data, do
//
//     final responseDetailHistory = responseDetailHistoryFromJson(jsonString);

import 'dart:convert';

ResponseDetailHistory responseDetailHistoryFromJson(String str) => ResponseDetailHistory.fromJson(json.decode(str));

String responseDetailHistoryToJson(ResponseDetailHistory data) => json.encode(data.toJson());

class ResponseDetailHistory {
  bool? status;
  String? message;
  List<DetailHistoryItem>? data;

  ResponseDetailHistory({
    this.status,
    this.message,
    this.data,
  });

  factory ResponseDetailHistory.fromJson(Map<String, dynamic> json) => ResponseDetailHistory(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<DetailHistoryItem>.from(json["data"]!.map((x) => DetailHistoryItem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class DetailHistoryItem {
  String? namaMeja;
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
  dynamic notes;
  String? phone;
  int? durationMinutes;
  String? cashierName;

  DetailHistoryItem({
    this.namaMeja,
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
    this.durationMinutes,
    this.cashierName,
  });

  factory DetailHistoryItem.fromJson(Map<String, dynamic> json) => DetailHistoryItem(
    namaMeja: json["nama_meja"],
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
    durationMinutes: json["duration_minutes"],
    cashierName: json["cashier_name"],
  );

  Map<String, dynamic> toJson() => {
    "nama_meja": namaMeja,
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
    "duration_minutes": durationMinutes,
    "cashier_name": cashierName,
  };
}

// To parse this JSON data, do
//
//     final responseChangeTable = responseChangeTableFromJson(jsonString);

import 'dart:convert';

ResponseChangeTable responseChangeTableFromJson(String str) => ResponseChangeTable.fromJson(json.decode(str));

String responseChangeTableToJson(ResponseChangeTable data) => json.encode(data.toJson());

class ResponseChangeTable {
  bool? status;
  String? message;
  Data? data;

  ResponseChangeTable({
    this.status,
    this.message,
    this.data,
  });

  factory ResponseChangeTable.fromJson(Map<String, dynamic> json) => ResponseChangeTable(
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
  String? oldRooms;
  String? newRooms;

  Data({
    this.oldRooms,
    this.newRooms,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    oldRooms: json["old_rooms"],
    newRooms: json["new_rooms"],
  );

  Map<String, dynamic> toJson() => {
    "old_rooms": oldRooms,
    "new_rooms": newRooms,
  };
}

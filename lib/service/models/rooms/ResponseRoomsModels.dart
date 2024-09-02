// To parse this JSON data, do
//
//     final responseRoomsModels = responseRoomsModelsFromJson(jsonString);

import 'dart:convert';

ResponseRoomsModels responseRoomsModelsFromJson(String str) => ResponseRoomsModels.fromJson(json.decode(str));

String responseRoomsModelsToJson(ResponseRoomsModels data) => json.encode(data.toJson());

class ResponseRoomsModels {
  bool? status;
  String? message;
  List<Room>? data;

  ResponseRoomsModels({
    this.status,
    this.message,
    this.data,
  });

  factory ResponseRoomsModels.fromJson(Map<String, dynamic> json) => ResponseRoomsModels(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Room>.from(json["data"]!.map((x) => Room.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Room {
  int? id;
  String? name;
  String? code;
  dynamic createdAt;
  DateTime? updatedAt;
  int? status;
  int? roomsAvailable;
  int? idPanels;
  String? multipleChannel;
  dynamic isMultipleChannel;

  Room({
    this.id,
    this.name,
    this.code,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.roomsAvailable,
    this.idPanels,
    this.multipleChannel,
    this.isMultipleChannel,
  });

  factory Room.fromJson(Map<String, dynamic> json) => Room(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    status: json["status"],
    roomsAvailable: json["rooms_available"],
    idPanels: json["id_panels"],
    multipleChannel: json["multiple_channel"],
    isMultipleChannel: json["is_multiple_channel"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "created_at": createdAt,
    "updated_at": updatedAt?.toIso8601String(),
    "status": status,
    "rooms_available": roomsAvailable,
    "id_panels": idPanels,
    "multiple_channel": multipleChannel,
    "is_multiple_channel": isMultipleChannel,
  };
}

// To parse this JSON data, do
//
//     final responseListConfigModels = responseListConfigModelsFromJson(jsonString);

import 'dart:convert';

ResponseListConfigModels responseListConfigModelsFromJson(String str) => ResponseListConfigModels.fromJson(json.decode(str));

String responseListConfigModelsToJson(ResponseListConfigModels data) => json.encode(data.toJson());

class ResponseListConfigModels {
  bool? success;
  List<Room>? rooms;

  ResponseListConfigModels({
    this.success,
    this.rooms,
  });

  factory ResponseListConfigModels.fromJson(Map<String, dynamic> json) => ResponseListConfigModels(
    success: json["success"],
    rooms: json["rooms"] == null ? [] : List<Room>.from(json["rooms"]!.map((x) => Room.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "rooms": rooms == null ? [] : List<dynamic>.from(rooms!.map((x) => x.toJson())),
  };
}

class Room {
  int? id;
  String? ip;
  dynamic createdAt;
  dynamic updateAt;
  String? secret;

  Room({
    this.id,
    this.ip,
    this.createdAt,
    this.updateAt,
    this.secret,
  });

  factory Room.fromJson(Map<String, dynamic> json) => Room(
    id: json["id"],
    ip: json["ip"],
    createdAt: json["created_at"],
    updateAt: json["update_at"],
    secret: json["secret"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "ip": ip,
    "created_at": createdAt,
    "update_at": updateAt,
    "secret": secret,
  };
}

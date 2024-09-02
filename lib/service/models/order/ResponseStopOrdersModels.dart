// To parse this JSON data, do
//
//     final responseStopOrdersModels = responseStopOrdersModelsFromJson(jsonString);

import 'dart:convert';

ResponseStopOrdersModels responseStopOrdersModelsFromJson(String str) => ResponseStopOrdersModels.fromJson(json.decode(str));

String responseStopOrdersModelsToJson(ResponseStopOrdersModels data) => json.encode(data.toJson());

class ResponseStopOrdersModels {
  bool? status;
  String? message;
  Data? data;

  ResponseStopOrdersModels({
    this.status,
    this.message,
    this.data,
  });

  factory ResponseStopOrdersModels.fromJson(Map<String, dynamic> json) => ResponseStopOrdersModels(
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
  String? name;
  String? code;
  dynamic createdAt;
  DateTime? updatedAt;
  int? status;
  int? roomsAvailable;
  int? idPanels;
  Panel? panel;

  Data({
    this.id,
    this.name,
    this.code,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.roomsAvailable,
    this.idPanels,
    this.panel,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    status: json["status"],
    roomsAvailable: json["rooms_available"],
    idPanels: json["id_panels"],
    panel: json["panel"] == null ? null : Panel.fromJson(json["panel"]),
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
    "panel": panel?.toJson(),
  };
}

class Panel {
  int? id;
  String? position;
  String? ip;
  int? isActive;
  String? secret;
  DateTime? updatedAt;

  Panel({
    this.id,
    this.position,
    this.ip,
    this.isActive,
    this.secret,
    this.updatedAt,
  });

  factory Panel.fromJson(Map<String, dynamic> json) => Panel(
    id: json["id"],
    position: json["position"],
    ip: json["ip"],
    isActive: json["is_active"],
    secret: json["secret"],
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "position": position,
    "ip": ip,
    "is_active": isActive,
    "secret": secret,
    "updated_at": updatedAt?.toIso8601String(),
  };
}

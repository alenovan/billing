// To parse this JSON data, do
//
//     final responsePanelModels = responsePanelModelsFromJson(jsonString);

import 'dart:convert';

ResponsePanelModels responsePanelModelsFromJson(String str) => ResponsePanelModels.fromJson(json.decode(str));

String responsePanelModelsToJson(ResponsePanelModels data) => json.encode(data.toJson());

class ResponsePanelModels {
  bool? status;
  String? message;
  Data? data;

  ResponsePanelModels({
    this.status,
    this.message,
    this.data,
  });

  factory ResponsePanelModels.fromJson(Map<String, dynamic> json) => ResponsePanelModels(
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
  String? position;
  String? ip;
  int? isActive;
  String? secret;
  DateTime? updatedAt;

  Data({
    this.id,
    this.position,
    this.ip,
    this.isActive,
    this.secret,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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

// To parse this JSON data, do
//
//     final responseLoginModels = responseLoginModelsFromJson(jsonString);

import 'dart:convert';

ResponseLoginModels responseLoginModelsFromJson(String str) => ResponseLoginModels.fromJson(json.decode(str));

String responseLoginModelsToJson(ResponseLoginModels data) => json.encode(data.toJson());

class ResponseLoginModels {
  bool? status;
  String? message;
  Data? data;

  ResponseLoginModels({
    this.status,
    this.message,
    this.data,
  });

  factory ResponseLoginModels.fromJson(Map<String, dynamic> json) => ResponseLoginModels(
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
  String? username;
  dynamic createdAt;
  dynamic updateAt;
  int? isTimer;
  String? token;

  Data({
    this.id,
    this.username,
    this.createdAt,
    this.updateAt,
    this.isTimer,
    this.token,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    username: json["username"],
    createdAt: json["created_at"],
    updateAt: json["update_at"],
    isTimer: json["is_timer"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "created_at": createdAt,
    "update_at": updateAt,
    "is_timer": isTimer,
    "token": token,
  };
}

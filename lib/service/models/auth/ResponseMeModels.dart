// To parse this JSON data, do
//
//     final responseMeModels = responseMeModelsFromJson(jsonString);

import 'dart:convert';

ResponseMeModels responseMeModelsFromJson(String str) => ResponseMeModels.fromJson(json.decode(str));

String responseMeModelsToJson(ResponseMeModels data) => json.encode(data.toJson());

class ResponseMeModels {
  bool? success;
  List<Detail>? detail;

  ResponseMeModels({
    this.success,
    this.detail,
  });

  factory ResponseMeModels.fromJson(Map<String, dynamic> json) => ResponseMeModels(
    success: json["success"],
    detail: json["detail"] == null ? [] : List<Detail>.from(json["detail"]!.map((x) => Detail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "detail": detail == null ? [] : List<dynamic>.from(detail!.map((x) => x.toJson())),
  };
}

class Detail {
  int? id;
  String? username;
  String? password;
  dynamic createdAt;
  dynamic updateAt;
  int? isTimer;

  Detail({
    this.id,
    this.username,
    this.password,
    this.createdAt,
    this.updateAt,
    this.isTimer,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    id: json["id"],
    username: json["username"],
    password: json["password"],
    createdAt: json["created_at"],
    updateAt: json["update_at"],
    isTimer: json["is_timer"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "password": password,
    "created_at": createdAt,
    "update_at": updateAt,
    "is_timer": isTimer,
  };
}

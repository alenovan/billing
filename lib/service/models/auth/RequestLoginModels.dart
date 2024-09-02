// To parse this JSON data, do
//
//     final requestLoginModels = requestLoginModelsFromJson(jsonString);

import 'dart:convert';

RequestLoginModels requestLoginModelsFromJson(String str) => RequestLoginModels.fromJson(json.decode(str));

String requestLoginModelsToJson(RequestLoginModels data) => json.encode(data.toJson());

class RequestLoginModels {
  String? username;
  String? password;

  RequestLoginModels({
    this.username,
    this.password,
  });

  factory RequestLoginModels.fromJson(Map<String, dynamic> json) => RequestLoginModels(
    username: json["username"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "password": password,
  };
}

// To parse this JSON data, do
//
//     final responseConfigsModels = responseConfigsModelsFromJson(jsonString);

import 'dart:convert';

ResponseConfigsModels responseConfigsModelsFromJson(String str) => ResponseConfigsModels.fromJson(json.decode(str));

String responseConfigsModelsToJson(ResponseConfigsModels data) => json.encode(data.toJson());

class ResponseConfigsModels {
  bool? success;
  String? message;

  ResponseConfigsModels({
    this.success,
    this.message,
  });

  factory ResponseConfigsModels.fromJson(Map<String, dynamic> json) => ResponseConfigsModels(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}

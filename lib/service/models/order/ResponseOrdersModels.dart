// To parse this JSON data, do
//
//     final responseOrdersModels = responseOrdersModelsFromJson(jsonString);

import 'dart:convert';

ResponseOrdersModels responseOrdersModelsFromJson(String str) => ResponseOrdersModels.fromJson(json.decode(str));

String responseOrdersModelsToJson(ResponseOrdersModels data) => json.encode(data.toJson());

class ResponseOrdersModels {
  bool? status;
  String? message;
  String? data;

  ResponseOrdersModels({
    this.status,
    this.message,
    this.data,
  });

  factory ResponseOrdersModels.fromJson(Map<String, dynamic> json) => ResponseOrdersModels(
    status: json["status"],
    message: json["message"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data,
  };
}

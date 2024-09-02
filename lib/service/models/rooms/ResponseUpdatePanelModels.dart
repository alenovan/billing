// To parse this JSON data, do
//
//     final responseUpdatePanelModels = responseUpdatePanelModelsFromJson(jsonString);

import 'dart:convert';

ResponseUpdatePanelModels responseUpdatePanelModelsFromJson(String str) => ResponseUpdatePanelModels.fromJson(json.decode(str));

String responseUpdatePanelModelsToJson(ResponseUpdatePanelModels data) => json.encode(data.toJson());

class ResponseUpdatePanelModels {
  bool? success;
  String? message;

  ResponseUpdatePanelModels({
    this.success,
    this.message,
  });

  factory ResponseUpdatePanelModels.fromJson(Map<String, dynamic> json) => ResponseUpdatePanelModels(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}

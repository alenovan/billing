// To parse this JSON data, do
//
//     final requestConfigsModels = requestConfigsModelsFromJson(jsonString);

import 'dart:convert';

RequestConfigsModels requestConfigsModelsFromJson(String str) => RequestConfigsModels.fromJson(json.decode(str));

String requestConfigsModelsToJson(RequestConfigsModels data) => json.encode(data.toJson());

class RequestConfigsModels {
  String? ip;
  String? secret;

  RequestConfigsModels({
    this.ip,
    this.secret,
  });

  factory RequestConfigsModels.fromJson(Map<String, dynamic> json) => RequestConfigsModels(
    ip: json["ip"],
    secret: json["secret"],
  );

  Map<String, dynamic> toJson() => {
    "ip": ip,
    "secret": secret,
  };
}

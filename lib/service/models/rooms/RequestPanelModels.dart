// To parse this JSON data, do
//
//     final requestPanelModels = requestPanelModelsFromJson(jsonString);

import 'dart:convert';

RequestPanelModels requestPanelModelsFromJson(String str) => RequestPanelModels.fromJson(json.decode(str));

String requestPanelModelsToJson(RequestPanelModels data) => json.encode(data.toJson());

class RequestPanelModels {
  int? panelId;
  String? ip;

  RequestPanelModels({
    this.panelId,
    this.ip,
  });

  factory RequestPanelModels.fromJson(Map<String, dynamic> json) => RequestPanelModels(
    panelId: json["panel_id"],
    ip: json["ip"],
  );

  Map<String, dynamic> toJson() => {
    "panel_id": panelId,
    "ip": ip,
  };
}

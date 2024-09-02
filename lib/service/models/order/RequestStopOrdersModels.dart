// To parse this JSON data, do
//
//     final requestStopOrdersModels = requestStopOrdersModelsFromJson(jsonString);

import 'dart:convert';

RequestStopOrdersModels requestStopOrdersModelsFromJson(String str) => RequestStopOrdersModels.fromJson(json.decode(str));

String requestStopOrdersModelsToJson(RequestStopOrdersModels data) => json.encode(data.toJson());

class RequestStopOrdersModels {
  int? orderId;

  RequestStopOrdersModels({
    this.orderId,
  });

  factory RequestStopOrdersModels.fromJson(Map<String, dynamic> json) => RequestStopOrdersModels(
    orderId: json["order_id"],
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
  };
}

// To parse this JSON data, do
//
//     final requestVoidOrder = requestVoidOrderFromJson(jsonString);

import 'dart:convert';

RequestVoidOrder requestVoidOrderFromJson(String str) => RequestVoidOrder.fromJson(json.decode(str));

String requestVoidOrderToJson(RequestVoidOrder data) => json.encode(data.toJson());

class RequestVoidOrder {
  int? idOrder;
  String? notes;
  String? statusData;

  RequestVoidOrder({
    this.idOrder,
    this.notes,
    this.statusData,
  });

  factory RequestVoidOrder.fromJson(Map<String, dynamic> json) => RequestVoidOrder(
    idOrder: json["id_order"],
    notes: json["notes"],
    statusData: json["status_data"],
  );

  Map<String, dynamic> toJson() => {
    "id_order": idOrder,
    "notes": notes,
    "status_data": statusData,
  };
}

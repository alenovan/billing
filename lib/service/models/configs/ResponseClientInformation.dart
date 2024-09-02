// To parse this JSON data, do
//
//     final responseClientInformation = responseClientInformationFromJson(jsonString);

import 'dart:convert';

ResponseClientInformation responseClientInformationFromJson(String str) => ResponseClientInformation.fromJson(json.decode(str));

String responseClientInformationToJson(ResponseClientInformation data) => json.encode(data.toJson());

class ResponseClientInformation {
  bool? status;
  String? message;
  List<DetailInformation>? data;

  ResponseClientInformation({
    this.status,
    this.message,
    this.data,
  });

  factory ResponseClientInformation.fromJson(Map<String, dynamic> json) => ResponseClientInformation(
    status: json["status"],
    message: json["message"],
    data: json["data"] == null ? [] : List<DetailInformation>.from(json["data"]!.map((x) => DetailInformation.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class DetailInformation {
  int? id;
  dynamic createdAt;
  dynamic updatedAt;
  String? clientName;
  int? totalTable;
  int? clientId;

  DetailInformation({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.clientName,
    this.totalTable,
    this.clientId,
  });

  factory DetailInformation.fromJson(Map<String, dynamic> json) => DetailInformation(
    id: json["id"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    clientName: json["client_name"],
    totalTable: json["total_table"],
    clientId: json["client_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "client_name": clientName,
    "total_table": totalTable,
    "client_id": clientId,
  };
}

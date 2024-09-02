// To parse this JSON data, do
//
//     final requestOrdersModels = requestOrdersModelsFromJson(jsonString);

import 'dart:convert';

RequestOrdersModels requestOrdersModelsFromJson(String str) => RequestOrdersModels.fromJson(json.decode(str));

String requestOrdersModelsToJson(RequestOrdersModels data) => json.encode(data.toJson());

class RequestOrdersModels {
  String? idRooms;
  String? duration;
  String? version;
  String name;
  String? phone;

  RequestOrdersModels({
    this.idRooms,
    this.duration,
    this.phone,
    required this.version,
    required this.name,

  });

  factory RequestOrdersModels.fromJson(Map<String, dynamic> json) => RequestOrdersModels(
    idRooms: json["id_rooms"],
    duration: json["duration"],
    phone: json["phone"],
    version: json["version"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id_rooms": idRooms,
    "duration": duration,
    "phone": phone,
    "version": version,
    "name": name,
  };
}

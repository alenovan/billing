// To parse this JSON data, do
//
//     final requestChangeTable = requestChangeTableFromJson(jsonString);

import 'dart:convert';

RequestChangeTable requestChangeTableFromJson(String str) => RequestChangeTable.fromJson(json.decode(str));

String requestChangeTableToJson(RequestChangeTable data) => json.encode(data.toJson());

class RequestChangeTable {
  int? idRooms;
  int? idOrder;

  RequestChangeTable({
    this.idRooms,
    this.idOrder,
  });

  factory RequestChangeTable.fromJson(Map<String, dynamic> json) => RequestChangeTable(
    idRooms: json["id_rooms"],
    idOrder: json["id_order"],
  );

  Map<String, dynamic> toJson() => {
    "id_rooms": idRooms,
    "id_order": idOrder,
  };
}

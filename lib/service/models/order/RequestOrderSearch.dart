// To parse this JSON data, do
//
//     final requestOrderSearch = requestOrderSearchFromJson(jsonString);

import 'dart:convert';

RequestOrderSearch requestOrderSearchFromJson(String str) => RequestOrderSearch.fromJson(json.decode(str));

String requestOrderSearchToJson(RequestOrderSearch data) => json.encode(data.toJson());

class RequestOrderSearch {
  String? search;
  String? startDate;
  String? endDate;
  int? page;
  int? pageSize;

  RequestOrderSearch({
    this.search,
    this.startDate,
    this.endDate,
    this.page,
    this.pageSize,
  });

  factory RequestOrderSearch.fromJson(Map<String, dynamic> json) => RequestOrderSearch(
    search: json["search"],
    startDate: json["startDate"],
    endDate: json["endDate"],
    page: json["page"],
    pageSize: json["pageSize"],
  );

  Map<String, dynamic> toJson() => {
    "search": search,
    "startDate": startDate,
    "endDate": endDate,
    "page": page,
    "pageSize": pageSize,
  };
}

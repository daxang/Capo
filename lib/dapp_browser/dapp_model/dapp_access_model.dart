// To parse this JSON data, do
//
//     final dAppAccessModel = dAppAccessModelFromJson(jsonString);

import 'dart:convert';

DAppAccessModel dAppAccessModelFromJson(String str) =>
    DAppAccessModel.fromJson(json.decode(str));

String dAppAccessModelToJson(DAppAccessModel data) =>
    json.encode(data.toJson());

class DAppAccessModel {
  DAppAccessModel({
    this.name,
    this.url,
    this.addressAccess,
  });

  String name;
  String url;
  bool addressAccess;

  factory DAppAccessModel.fromJson(Map<String, dynamic> json) =>
      DAppAccessModel(
        name: json["name"],
        url: json["url"],
        addressAccess: json["addressAccess"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
        "addressAccess": addressAccess,
      };
}

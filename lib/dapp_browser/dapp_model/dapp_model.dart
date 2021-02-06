// To parse this JSON data, do
//
//     final dappInfoModel = dappInfoModelFromJson(jsonString);

import 'dart:convert';

DappInfoModel dappInfoModelFromJson(String str) =>
    DappInfoModel.fromJson(json.decode(str));

String dappInfoModelToJson(DappInfoModel data) => json.encode(data.toJson());

class DappInfoModel {
  DappInfoModel({
    this.url,
    this.name,
    this.subtitle,
    this.icon,
  });

  String url;
  String name;
  String subtitle;
  String icon;

  factory DappInfoModel.fromJson(Map<String, dynamic> json) => DappInfoModel(
        url: json["url"],
        name: json["name"],
        subtitle: json["subtitle"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "name": name,
        "subtitle": subtitle,
        "icon": icon,
      };
}

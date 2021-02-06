// To parse this JSON data, do
//
//     final dAppShareModel = dAppShareModelFromJson(jsonString);

import 'dart:convert';

DAppShareModel dAppShareModelFromJson(String str) =>
    DAppShareModel.fromJson(json.decode(str));

String dAppShareModelToJson(DAppShareModel data) => json.encode(data.toJson());

class DAppShareModel {
  DAppShareModel({
    this.url,
    this.title,
    this.content,
  });

  String url;
  String title;
  String content;

  factory DAppShareModel.fromJson(Map<String, dynamic> json) => DAppShareModel(
        url: json["url"],
        title: json["title"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "title": title,
        "content": content,
      };
}

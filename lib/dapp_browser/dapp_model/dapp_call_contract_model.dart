// To parse this JSON data, do
//
//     final dAppCallContractModel = dAppCallContractModelFromJson(jsonString);

import 'dart:convert';

DAppCallContractModel dAppCallContractModelFromJson(String str) =>
    DAppCallContractModel.fromJson(json.decode(str));

String dAppCallContractModelToJson(DAppCallContractModel data) =>
    json.encode(data.toJson());

class DAppCallContractModel {
  DAppCallContractModel({
    this.term,
  });

  String term;

  factory DAppCallContractModel.fromJson(Map<String, dynamic> json) =>
      DAppCallContractModel(
        term: json["term"],
      );

  Map<String, dynamic> toJson() => {
        "term": term,
      };
}

// To parse this JSON data, do
//
//     final readonlySections = readonlySectionsFromJson(jsonString);

import 'dart:convert';

ReadonlySections readonlySectionsFromJson(String str) =>
    ReadonlySections.fromJson(json.decode(str));

String readonlySectionsToJson(ReadonlySections data) =>
    json.encode(data.toJson());

class ReadonlySections {
  List<List<Section>> sections;
  String selectedNode;

  ReadonlySections({
    this.sections,
    this.selectedNode,
  });

  factory ReadonlySections.fromJson(Map<String, dynamic> json) =>
      ReadonlySections(
        sections: List<List<Section>>.from(json["sections"]
            .map((x) => List<Section>.from(x.map((x) => Section.fromJson(x))))),
        selectedNode: json["selectedNode"],
      );

  Map<String, dynamic> toJson() => {
        "sections": List<dynamic>.from(
            sections.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
        "selectedNode": selectedNode,
      };
}

class Section {
  String url;

  Section({
    this.url,
  });

  factory Section.fromJson(Map<String, dynamic> json) => Section(
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
      };
}

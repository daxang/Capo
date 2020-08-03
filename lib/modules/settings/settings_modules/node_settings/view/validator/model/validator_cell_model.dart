// To parse this JSON data, do
//
//     final validatorSections = validatorSectionsFromJson(jsonString);

import 'dart:convert';

ValidatorSections validatorSectionsFromJson(String str) =>
    ValidatorSections.fromJson(json.decode(str));

String validatorSectionsToJson(ValidatorSections data) =>
    json.encode(data.toJson());

class ValidatorSections {
  List<List<Section>> sections;
  String selectedNode;

  ValidatorSections({
    this.sections,
    this.selectedNode,
  });

  factory ValidatorSections.fromJson(Map<String, dynamic> json) =>
      ValidatorSections(
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

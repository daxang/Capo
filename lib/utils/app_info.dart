// To parse this JSON data, do
//
//     final updateInfo = updateInfoFromJson(jsonString);

import 'dart:convert';

UpdateInfo updateInfoFromJson(String str) =>
    UpdateInfo.fromJson(json.decode(str));

String updateInfoToJson(UpdateInfo data) => json.encode(data.toJson());

class UpdateInfo {
  int code;
  String msg;
  bool isForce;
  bool isIgnorable;
  int versionCode;
  String versionName;
  String updateContent;
  String downloadUrl;
  int apkSize;
  String apkMd5;

  UpdateInfo({
    this.code,
    this.msg,
    this.isForce,
    this.isIgnorable,
    this.versionCode,
    this.versionName,
    this.updateContent,
    this.downloadUrl,
    this.apkSize,
    this.apkMd5,
  });

  factory UpdateInfo.fromJson(Map<String, dynamic> json) => UpdateInfo(
        code: json["code"],
        msg: json["msg"],
        isForce: json["isForce"],
        isIgnorable: json["isIgnorable"],
        versionCode: json["versionCode"],
        versionName: json["versionName"],
        updateContent: json["updateContent"],
        downloadUrl: json["downloadUrl"],
        apkSize: json["apkSize"],
        apkMd5: json["apkMd5"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "isForce": isForce,
        "isIgnorable": isIgnorable,
        "versionCode": versionCode,
        "versionName": versionName,
        "updateContent": updateContent,
        "downloadUrl": downloadUrl,
        "apkSize": apkSize,
        "apkMd5": apkMd5,
      };
}

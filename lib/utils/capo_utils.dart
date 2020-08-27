import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xupdate/update_entity.dart';
import 'package:intl/intl.dart';
import 'package:package_info/package_info.dart';
import 'package:version/version.dart';

import 'app_info.dart';

const bool inProduction = const bool.fromEnvironment("dart.vm.product");

Locale capoAppDeviceLocale;

String get versionUpdateUrl {
  if (inProduction) {
    return "https://icapo.app";
  } else {
    // return "https://icapo.app";
    return "https://icapo.app";
//    return "http://10.0.0.2:5000";
  }
}

Future<UpdateEntity> fetchUpdateEntity() async {
  String url = versionUpdateUrl + "/check_update/update_en.json";
  if (capoAppDeviceLocale.languageCode.toLowerCase() == "zh") {
    url = versionUpdateUrl + "/check_update/update_zh.json";
  }
  final dio = Dio(BaseOptions(connectTimeout: 60000));
  Response response = await dio.get(url);
  UpdateInfo appInfo = UpdateInfo.fromJson(response.data);
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  Version currentVersion = Version.parse(packageInfo.version);
  Version latestVersion = Version.parse(appInfo.versionName);
  bool hasUpdate = latestVersion > currentVersion;
  return UpdateEntity(
      hasUpdate: hasUpdate,
      isForce: appInfo.isForce,
      isIgnorable: appInfo.isIgnorable,
      versionCode: appInfo.versionCode,
      versionName: appInfo.versionName,
      updateContent: appInfo.updateContent,
      downloadUrl: appInfo.downloadUrl,
      apkSize: appInfo.apkSize,
      apkMd5: appInfo.apkMd5);
}

String capoNumberFormat(dynamic number) {
  final formatter = NumberFormat();
  formatter.maximumFractionDigits = 8;
  formatter.minimumIntegerDigits = 1;
  formatter.minimumFractionDigits = 0;
  formatter.maximumIntegerDigits = 10;
  if (number is String) {
    return formatter.format(double.tryParse(number) ?? 0);
  }
  if (number is num) {
    return formatter.format(number);
  }
  return "0";
}

String capoAmountFormat(dynamic amount) {
  final formatter = NumberFormat("#,###.##", "en_US");
  var result = "0.00";

  if (amount is String) {
    result = formatter.format(double.tryParse(amount) ?? 0);
  }
  if (amount is num) {
    result = formatter.format(amount);
  }
  return result;
}

int hexToInt(String hex) {
  int val = 0;
  int len = hex.length;
  for (int i = 0; i < len; i++) {
    int hexDigit = hex.codeUnitAt(i);
    if (hexDigit >= 48 && hexDigit <= 57) {
      val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 65 && hexDigit <= 70) {
      // A..F
      val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
    } else if (hexDigit >= 97 && hexDigit <= 102) {
      // a..f
      val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
    } else {
      throw new FormatException("Invalid hexadecimal value");
    }
  }
  return val;
}

extension HexColor on Color {
  static Color mainColor = Color.fromARGB(255, 51, 118, 184);

  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16)}'
      '${red.toRadixString(16)}'
      '${green.toRadixString(16)}'
      '${blue.toRadixString(16)}';
}

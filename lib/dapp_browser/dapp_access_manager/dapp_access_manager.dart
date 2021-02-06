import 'dart:convert';

import 'package:capo/dapp_browser/dapp_model/dapp_access_model.dart';
import 'package:capo/utils/storage_manager.dart';
import 'package:flutter/cupertino.dart';

const kCapoDAppAccessSettings = 'kCapoDAppAccessSettingsV0.3.0';

class DAppAccessManager {
  static DAppAccessManager _instance;
  Map<String, dynamic> dAppAccessMap = {};

  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  DAppAccessManager._internal() {
    String jsonString =
        StorageManager.sharedPreferences.getString(kCapoDAppAccessSettings);
    if (jsonString != null && jsonString.isNotEmpty) {
      dAppAccessMap = json.decode(jsonString);
    }
  }

  bool queryDAppAddressAccess({@required String dAppURL}) {
    if (dAppAccessMap.containsKey(dAppURL)) {
      String dAppString = dAppAccessMap[dAppURL];
      DAppAccessModel dAppAccessModel = dAppAccessModelFromJson(dAppString);
      return dAppAccessModel.addressAccess ?? false;
    }

    return false;
  }

  clearAllowance() async {
    dAppAccessMap.clear();
    await saveAccessSettings2Storage();
  }

  saveAccessSettings2Storage() async {
    String jsonString = json.encode(dAppAccessMap);
    await Future.wait([
      StorageManager.sharedPreferences
          .setString(kCapoDAppAccessSettings, jsonString),
    ]);
  }

  /// 工厂构造方法，这里使用命名构造函数方式进行声明
  factory DAppAccessManager.getSharedInstance() => _getInstance();

  /// 获取单例内部方法
  static _getInstance() {
    // 只能有一个实例
    if (_instance == null) {
      _instance = DAppAccessManager._internal();
    }
    return _instance;
  }
}

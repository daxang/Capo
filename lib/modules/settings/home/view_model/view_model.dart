import 'dart:convert';

import 'package:capo/modules/settings/home/model/model.dart';
import 'package:easy_localization/public.dart';
import 'package:flutter/material.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsModel tableViewModel;
  bool _disposed = false;

  loadJson(context) async {
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('lib/modules/settings/home/model/sections.json');
    final map = json.decode(jsonString);
    tableViewModel = SettingsModel.fromJson(map);
    notifyListeners();
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  String contextForRowInSection(BuildContext context, int section, int row) {
    return tr(tableViewModel.sections[section][row].context);
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

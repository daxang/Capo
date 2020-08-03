import 'package:capo/utils/theme_view_model.dart';
import 'package:flutter/cupertino.dart';

class SettingDarkModeCellModel {
  DarkMode darkMode;
  String title;
  bool selected;
  bool showDivider;
  SettingDarkModeCellModel(
      {@required this.darkMode,
      @required this.title,
      this.selected = false,
      this.showDivider = false});
}

import 'package:flutter/cupertino.dart';

class SettingLanguageCellModel {
  Locale locale;
  String title;
  bool selected;
  bool showDivider;
  SettingLanguageCellModel(
      {this.locale,
      @required this.title,
      this.selected = false,
      this.showDivider = false});
}

import 'package:capo/modules/settings/settings_modules/dark_mode/model/model.dart';
import 'package:capo/utils/theme_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SettingDarkModeViewModel extends ChangeNotifier {
  List<SettingDarkModeCellModel> listModel;

  getUserSetting(BuildContext context) {
    var themeViewModel = Provider.of<ThemeViewModel>(context);
    listModel = [
      SettingDarkModeCellModel(
          darkMode: DarkMode.auto,
          title: tr("settings.dark_mode_setting.auto"),
          selected: themeViewModel.userDarkMode == DarkMode.auto,
          showDivider: false),
      SettingDarkModeCellModel(
          darkMode: DarkMode.dark,
          title: tr("settings.dark_mode_setting.dark"),
          selected: themeViewModel.userDarkMode == DarkMode.dark,
          showDivider: true),
      SettingDarkModeCellModel(
          darkMode: DarkMode.light,
          title:tr("settings.dark_mode_setting.light"),
          selected: themeViewModel.userDarkMode == DarkMode.light,
          showDivider: true),
    ];
    notifyListeners();
  }

  tappedCell(int index, BuildContext context) {
    SettingDarkModeCellModel model = listModel[index];
    if (model.selected) return;
    var themeViewModel = Provider.of<ThemeViewModel>(context);
    themeViewModel.switchTheme(userChangeDarkMode: model.darkMode);
    getUserSetting(context);
  }

  bool _disposed = false;

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

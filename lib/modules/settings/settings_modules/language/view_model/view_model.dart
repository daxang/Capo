import 'package:capo/modules/settings/settings_modules/language/model/model.dart';
import 'package:capo/utils/capo_utils.dart';
import 'package:capo/utils/dialog/capo_dialog_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

class SettingLanguageViewModel extends ChangeNotifier {
  List<SettingLanguageCellModel> listModel;

  getUserSetting(BuildContext context) {
    var data = EasyLocalizationProvider.of(context).data;
    Locale deviceLocal = data.locale ?? capoAppDeviceLocale;
    listModel = [
      SettingLanguageCellModel(
          locale: const Locale('en', 'US'),
          title: "English",
          selected: deviceLocal == const Locale('en', 'US'),
          showDivider: true),
      SettingLanguageCellModel(
          locale: const Locale('zh', 'CN'),
          title: "简体中文",
          selected: deviceLocal == const Locale('zh', 'CN'),
          showDivider: true),
    ];
    notifyListeners();
  }

  tappedCell(int index, BuildContext context) {
    SettingLanguageCellModel model = listModel[index];
    if (model.selected) return;
    var data = EasyLocalizationProvider.of(context).data;
    data.changeLocale(model.locale);
    CapoDialogUtils.showProcessIndicator(context: context);
    Future.delayed(Duration(milliseconds: 700), () {
      Navigator.of(context).pop();
      getUserSetting(context);
    });
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

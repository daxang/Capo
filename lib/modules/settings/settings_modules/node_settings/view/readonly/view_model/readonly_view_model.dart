import 'dart:convert';
import 'dart:math';

import 'package:capo/modules/balance/model/balanceModel.dart';
import 'package:capo/modules/settings/settings_modules/node_settings/view/readonly/model/readonly_cell_model.dart';
import 'package:capo/utils/check_balance_rho.dart';
import 'package:capo/utils/dialog/capo_dialog_utils.dart';
import 'package:capo/utils/rnode_networking.dart';
import 'package:capo/utils/storage_manager.dart';
import 'package:capo/utils/wallet_view_model.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';

class ReadonlyViewModel with ChangeNotifier {
  ReadonlySections tableViewSections;
  BuildContext _buildContext;
  loadJson(context) async {
    var sections = await getReadOnlyNodeSetting();
    tableViewSections = sections;

    notifyListeners();
    _buildContext = context;
  }

  static Future<ReadonlySections> getReadOnlyNodeSetting() async {
    String jsonString;
    jsonString = StorageManager.sharedPreferences
        .getString(kCapoUserReadonlyNodeSettings);
    if (jsonString == null) {
      jsonString = await rootBundle.loadString(
          "lib/modules/settings/settings_modules/node_settings/view/readonly/model/readonly_sections.json");
    }
    final map = json.decode(jsonString);
    ReadonlySections model = ReadonlySections.fromJson(map);

    if (model.selectedNode == null || model.selectedNode.length == 0) {
      var index = Random().nextInt(model.sections.first.length);
      model.selectedNode = model.sections.first.elementAt(index).url;
      String jsonString = json.encode(model.toJson());
      await saveNodeSettings2Storage(jsonString);
    }
    return model;
  }

  cellTapped({@required int section, @required int row}) async {
    String selectedNode = tableViewSections.sections[section][row].url;
    if (selectedNode == tableViewSections.selectedNode) {
      return;
    }
    tableViewSections.selectedNode = selectedNode;
    String jsonString = json.encode(tableViewSections.toJson());
    await saveNodeSettings2Storage(jsonString);
    notifyListeners();
  }

  static saveNodeSettings2Storage(String jsonString) async {
    await Future.wait([
      StorageManager.sharedPreferences
          .setString(kCapoUserReadonlyNodeSettings, jsonString),
    ]);
  }

  addCustomNode(String nodeUrl) async {
    if (nodeUrl == null || nodeUrl.length == 0) {
      return;
    }
    Uri uri = Uri.parse(nodeUrl);
    if (uri.scheme == null ||
        uri.scheme.length == 0 ||
        uri.host == null ||
        uri.host.length == 0) {
      CapoDialogUtils.showCupertinoDialog(
          buildContext: _buildContext,
          message: tr(
              "settings.note_settings.readonly_page.node_address_not_validate"));
      return;
    }

    for (List<Section> sections in tableViewSections.sections) {
      for (Section section in sections) {
        if (section.url == nodeUrl) {
          CapoDialogUtils.showCupertinoDialog(
              buildContext: _buildContext,
              message: tr(
                  "settings.note_settings.readonly_page.node_already_exists"));
          return;
        }
      }
    }

    CapoDialogUtils.showProcessIndicator(
        context: _buildContext,
        tip: tr("settings.note_settings.readonly_page.testing"));
    bool passed = await testNode(nodeUrl);
    Navigator.pop(_buildContext);
    if (!passed) {
      CapoDialogUtils.showCupertinoDialog(
          buildContext: _buildContext,
          message: tr(
              "settings.note_settings.readonly_page.unable_to_connect_to_this_node"));
      return;
    }

    tableViewSections.sections.last.add(Section(url: nodeUrl));
    String jsonString = json.encode(tableViewSections.toJson());
    await saveNodeSettings2Storage(jsonString);
    notifyListeners();
  }

  Future<bool> testNode(String nodeUrl) async {
    WalletViewModel walletViewModel =
        Provider.of<WalletViewModel>(_buildContext);

    try {
      Dio dio = Dio();
      dio.options = BaseOptions(connectTimeout: 20000);
      String term = checkBalanceRho(walletViewModel.currentWallet.address);
      Response response;
      try {
        response = await dio.post(nodeUrl + "/api/explore-deploy", data: term);
        if (response.statusCode != 200) {
          return false;
        }
        var data = jsonDecode(response.toString());
        BalanceModel model = BalanceModel.fromJson(data);
        if (model != null) {
          return true;
        } else {
          return false;
        }
      } on DioError catch (_) {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  deleteNode(int section, int row) async {
    String nodeUrl = tableViewSections.sections[section][row].url;
    if (nodeUrl == tableViewSections.selectedNode) {
      tableViewSections.selectedNode =
          tableViewSections.sections.first.first.url;
    }
    tableViewSections.sections[section].removeAt(row);
    String jsonString = json.encode(tableViewSections.toJson());
    await saveNodeSettings2Storage(jsonString);
    notifyListeners();
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

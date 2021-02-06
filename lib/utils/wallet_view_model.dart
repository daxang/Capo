import 'dart:convert';

import 'package:capo/utils/check_balance_rho.dart';
import 'package:capo/utils/rnode_networking.dart';
import 'package:capo/utils/storage_manager.dart';
import 'package:capo_core_dart/capo_core_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:rnode_grpc_dart/rnode_grpc_dart.dart';
import 'package:rxbus/rxbus.dart';

const kCapoREVBalance = 'kCapoREVBalanceV0.3.0';

class WalletViewModel extends ChangeNotifier {
  Future<bool> ready;
  WalletManager walletManager = WalletManager.shared;
  String revBalance = "--";
  Map storageREVBalanceMap = {};
  BasicWallet get currentWallet {
    return walletManager.currentWallet;
  }

  List<BasicWallet> get wallets {
    return walletManager.wallets;
  }

  Future<void> _init() async {
    await WalletManager.shared.ready;
  }

  factory WalletViewModel() => _sharedInstance();

  static WalletViewModel shared = WalletViewModel._internal();

  static WalletViewModel _sharedInstance() {
    return shared;
  }

  WalletViewModel._internal() {
    ready = new Future<bool>(() async {
      await this._init();
      return true;
    });
  }

  Future getBalance() async {
    if (currentWallet == null) {
      return;
    }
    getREVBalanceFromStorage();

    try {
      await RNodeNetworking.setExploratoryDeployGRPCNetwork();
      print(
          "setExploratoryDeployGRPCNetwork:${RNodeExploratoryDeployGRPCService.shared.host}");
      String term = checkBalanceRho(currentWallet.address);
      final ExploratoryDeployResponse result =
          await RNodeExploratoryDeployGRPCService.shared
              .sendExploratoryDeploy(deployCode: term)
              .whenComplete(() => () {
                    print("whenComplete");
                  })
              .catchError((error) {
        print('Something really unknown: ${error.toString()}');

        SmartDialog.showToast(error.toString());
      });

      if (result != null &&
          result.result.postBlockData.first.exprs.first.gInt != null) {
        // print(
        //     "query success: setExploratoryDeployGRPCNetwork:${result.toString()}");

        revBalance =
            (result.result.postBlockData.first.exprs.first.gInt.toInt() / 10e7)
                .toString();
        notifyListeners();
        saveREVBalance2Storage();
      }
    } catch (e) {
      // 非具体类型
      print('Something really unknown: $e');
    }
  }

  getREVBalanceFromStorage() async {
    String jsonString =
        StorageManager.sharedPreferences.getString(kCapoREVBalance);
    if (jsonString != null && jsonString.isNotEmpty) {
      storageREVBalanceMap = json.decode(jsonString);
      if (storageREVBalanceMap != null &&
          storageREVBalanceMap.containsKey(currentWallet.address)) {
        revBalance = storageREVBalanceMap[currentWallet.address];
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifyListeners();
        });
      }
    }
  }

  saveREVBalance2Storage() async {
    storageREVBalanceMap[currentWallet.address] = revBalance;
    String jsonString = json.encode(storageREVBalanceMap);
    await Future.wait([
      StorageManager.sharedPreferences.setString(kCapoREVBalance, jsonString),
    ]);
  }

  switchWallet(BasicWallet wallet) async {
    await walletManager.switchWallet(wallet);
    revBalance = "--";
    RxBus.post("SwitchWallet", tag: "WalletChanged");
    getBalance();
    notifyListeners();
  }

  modifyWalletName(BasicWallet wallet, String name) async {
    await walletManager.modifyWalletName(wallet, name);
    notifyListeners();
  }

  deleteWallet(BuildContext context, BasicWallet wallet) async {
    await walletManager.deleteWallet(wallet);
    RxBus.post("SwitchWallet", tag: "WalletChanged");
    getBalance();
    notifyListeners();
    if (currentWallet == null && wallets.isEmpty) {
      Navigator.pushNamedAndRemoveUntil(context,
          "capo://icapo.app/wallet/guide", (Route<dynamic> route) => false);
    }
  }
}

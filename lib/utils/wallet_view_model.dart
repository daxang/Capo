import 'package:capo/utils/check_balance_rho.dart';
import 'package:capo/utils/rnode_networking.dart';
import 'package:capo_core_dart/capo_core_dart.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rnode_grpc_dart/rnode_grpc_dart.dart';
import 'package:rxbus/rxbus.dart';

class WalletViewModel extends ChangeNotifier {
  Future<bool> ready;
  WalletManager walletManager = WalletManager.shared;
  String revBalance = "--";
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

    await RNodeNetworking.setExploratoryDeployGRPCNetwork();
    String term = checkBalanceRho(currentWallet.address);
    Error exploratoryDeployError;
    final ExploratoryDeployResponse result =
        await RNodeExploratoryDeployGRPCService.shared
            .sendExploratoryDeploy(deployCode: term)
            .whenComplete(() => () {
                  print("whenComplete");
                })
            .catchError((error) {
      exploratoryDeployError = error;
      showToast(error.toString());
    });

    if (exploratoryDeployError != null) {
      return;
    }
    if (result != null &&
        result.result.postBlockData.first.exprs.first.gInt != null) {
      revBalance =
          (result.result.postBlockData.first.exprs.first.gInt.toInt() / 10e7)
              .toString();
      notifyListeners();
    }
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

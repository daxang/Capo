import 'dart:convert';

import 'package:capo/modules/balance/model/balanceModel.dart';
import 'package:capo/utils/check_balance_rho.dart';
import 'package:capo/utils/rnode_networking.dart';
import 'package:capo_core_dart/capo_core_dart.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/public.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
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
    String term = checkBalanceRho(currentWallet.address);
    try {
      var rNodeDio = await RNodeNetworking.rNodeDio;
      Response response =
          await rNodeDio.post("/api/explore-deploy", data: term);

      BalanceModel model = BalanceModel.fromJson(response.data);
      final error = model.expr.first.exprString.data;
      if (error == null) {
        final balanceInt = model.expr.first.exprInt.data != null &&
                model.expr.first.exprInt.data > 0
            ? model.expr.first.exprInt.data / 10e7
            : 0;
        final String balance = balanceInt.toString();
        revBalance = balance;
        notifyListeners();
      } else {
        showToast(error);
      }
    } on DioError catch (_) {
      showToast(tr(
          "settings.note_settings.readonly_page.unable_to_connect_to_this_node"));
    }
  }

  switchWallet(BasicWallet wallet) async {
    await walletManager.switchWallet(wallet);
    revBalance = "--";
    RxBus.post("SwitchWallet", tag: "WalletChanged");
    notifyListeners();
    await getBalance();
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

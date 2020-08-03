import 'dart:convert';

import 'package:capo/modules/balance/send/model/send_history_model.dart';
import 'package:capo/utils/capo_storage_utils.dart';
import 'package:capo/utils/wallet_view_model.dart';
import 'package:flutter/cupertino.dart';

class TransactionsViewModel with ChangeNotifier {
  TransactionHistoryModel historyModel;

  getTransactions() async {
    String jsonString = await CapoStorageUtils.shared.readByAddress(
        address: WalletViewModel.shared.currentWallet.address,
        key: kUserTransactions);
    if (jsonString == null || jsonString.length == 0) {
      historyModel = null;
      notifyListeners();
      return;
    }
    historyModel = TransactionHistoryModel.fromJson(json.decode(jsonString));
    historyModel.transactionHistoryList.sort((left, right) {
      return right.timestamp.compareTo(left.timestamp);
    });

    notifyListeners();
  }

  saveTransactions(String address) {
    String jsonString = json.encode(historyModel.toJson());
    CapoStorageUtils.shared.saveByAddress(
        address: address, key: kUserTransactions, content: jsonString);
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

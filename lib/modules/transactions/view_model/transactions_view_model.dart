import 'package:capo/modules/transactions/model/transfer_state_info.dart';
import 'package:capo/utils/rnode_networking.dart';
import 'package:capo/utils/wallet_view_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class TransactionsViewModel with ChangeNotifier {
  TransferHistory historyModel;
  BuildContext context;
  Future getTransactions() async {
    Response<List<dynamic>> response = await RNodeNetworking.rNodeStatusDio
        .get("/api/transfer/${WalletViewModel.shared.currentWallet.address}");
    RNodeNetworking.rNodeStatusDio.close();

    var arr0 = List<TransferHistoryItem>();
    arr0 = response.data.map((e) => TransferHistoryItem.fromJson(e)).toList();
    historyModel = TransferHistory();
    historyModel.history = arr0;
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

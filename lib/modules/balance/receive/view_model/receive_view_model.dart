import 'package:capo/utils/wallet_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ReceiveViewModel extends ChangeNotifier {
  String revAddress;
  String qrCodeString;
  String receiveAmount;
  getRevAddress(BuildContext context) {
    WalletViewModel walletViewModel = Provider.of<WalletViewModel>(context);
    revAddress = walletViewModel.currentWallet.address;
    qrCodeString = "revAddress:$revAddress";
  }

  setAmount(String amount) {
    try {
      double.parse(amount);
      receiveAmount = amount;
      qrCodeString = "revAddress:$revAddress?amount=$amount";
      notifyListeners();
    } catch (_) {
      qrCodeString = "revAddress:$revAddress";
      receiveAmount = "";
      notifyListeners();
    }
  }

  bool get isShowAmountText {
    return receiveAmount != null && receiveAmount.length > 0;
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

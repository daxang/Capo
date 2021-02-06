import 'package:capo/utils/wallet_view_model.dart';
import 'package:capo_core_dart/capo_core_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class CardViewModel extends ChangeNotifier {
  WalletViewModel walletViewModel;
  BasicWallet get currentWallet {
    return walletViewModel.currentWallet;
  }

  CardViewModel();
  getWalletViewModel(BuildContext context) {
    walletViewModel = Provider.of<WalletViewModel>(context);
    getBalance();
  }

  Future getBalance({bool showLoading = true}) async {
    notifyListeners();
    await walletViewModel.getBalance().then((_) {
      notifyListeners();
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

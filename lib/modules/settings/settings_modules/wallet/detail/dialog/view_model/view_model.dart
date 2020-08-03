import 'package:capo/utils/wallet_view_model.dart';
import 'package:capo_core_dart/capo_core_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class TextFieldDialogViewModel extends ChangeNotifier {
  bool isButtonAvailable = false;

  String get walletName {
    return walletNameEtController.text;
  }

  TextEditingController walletNameEtController = TextEditingController();
  BasicWallet wallet;
  TextFieldDialogViewModel(this.wallet) {
    walletNameEtController.text = wallet.capoMeta.name;
    walletNameEtController.addListener(() {
      isButtonAvailable = walletName.length > 0;
      notifyListeners();
    });
  }

  tappedModifyWalletName(BuildContext context) {
    WalletViewModel walletViewModel = Provider.of<WalletViewModel>(context);
    walletViewModel.modifyWalletName(wallet, walletName);
    Navigator.pop(context);
  }

  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  bool _disposed = false;

  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

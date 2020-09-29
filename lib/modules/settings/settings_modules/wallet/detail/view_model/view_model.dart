import 'package:capo/modules/common/dialog/password_dialog.dart';
import 'package:capo/modules/settings/settings_modules/wallet/detail/dialog/view/textfield_dialog.dart';
import 'package:capo/utils/dialog/capo_dialog_utils.dart';
import 'package:capo/utils/wallet_view_model.dart';
import 'package:capo_core_dart/capo_core_dart.dart';
import 'package:easy_localization/public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WalletDetailViewModel extends ChangeNotifier {
  BasicWallet wallet;
  BuildContext context;
  bool showSwitchWallet;
  bool showExportMnemonic;
  WalletViewModel walletViewModel;
  getRouteWallet(BuildContext context) {
    walletViewModel = Provider.of<WalletViewModel>(context);
    this.wallet = ModalRoute.of(context).settings.arguments;
    this.context = context;
    if (wallet != null && walletViewModel.currentWallet != null) {
      showSwitchWallet =
          walletViewModel.currentWallet.address != wallet.address;
      showExportMnemonic = wallet.keystore is REVMnemonicKeystore;
    }
  }

  tappedChangeWalletName() {
    showDialog(
        context: context,
        builder: (_) {
          return TextFieldDialog(wallet);
        });
  }

  tappedSwitchWallet() async {
    if (walletViewModel != null) {
      CapoDialogUtils.showProcessIndicator(
          context: context, tip: tr("settings.wallets.detail.switching"));
      await walletViewModel.switchWallet(wallet);
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  tappedExportPrivateKey(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return PasswordDialog(
            wallet: wallet,
            okClick: (password) {
              CapoDialogUtils.showProcessIndicator(
                  context: context,
                  tip: tr("settings.wallets.detail.exporting"));

              wallet
                  .exportPrivateKey(password: password)
                  .then((String privateKey) {
                Navigator.pop(context);
                Navigator.pushNamed(context,
                    "capo://icapo.app/settings/wallets/detail/export_private_key?privateKey=$privateKey");
              }).catchError((error) {
                Navigator.pop(context);
                CapoDialogUtils.showErrorDialog(error: error, context: context);
              });
            },
          );
        });
  }

  tappedExportMnemonic(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return PasswordDialog(
            wallet: wallet,
            okClick: (password) {
              CapoDialogUtils.showProcessIndicator(
                  context: context,
                  tip: tr("settings.wallets.detail.exporting"));
              wallet.exportMnemonic(password).then((String mnemonic) {
                Navigator.pop(context);
                Navigator.pushNamed(context,
                    "capo://icapo.app/settings/wallets/detail/export_mnemonic?mnemonic=$mnemonic");
              }).catchError((error) {
                Navigator.pop(context);
                CapoDialogUtils.showErrorDialog(error: error, context: context);
              });
            },
          );
        });
  }

  tappedExportKeystore(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return PasswordDialog(
              wallet: wallet,
              okClick: (password) async {
                CapoDialogUtils.showProcessIndicator(
                    context: context,
                    tip: tr("settings.wallets.detail.exporting"));
                bool isVerisy = await wallet.verifyPassword(password);
                if (isVerisy) {
                  Navigator.pop(context);
                  Navigator.pushNamed(context,
                      "capo://icapo.app/settings/wallets/detail/export_keystore?keystore=${wallet.keystore.export()}");
                } else {
                  Navigator.pop(context);
                  final error = AppError(type: AppErrorType.passwordIncorrect);
                  CapoDialogUtils.showErrorDialog(
                      error: error, context: context);
                }
              });
        });
  }

  Future deleteWallet() async {
    showDialog(
        context: context,
        builder: (_) {
          return PasswordDialog(
            wallet: wallet,
            okClick: (password) {
              CapoDialogUtils.showProcessIndicator(
                  context: context,
                  tip: tr("settings.wallets.detail.deleting"));
              wallet.verifyPassword(password).then((correct) async {
                if (correct) {
                  WalletViewModel walletViewModel =
                      Provider.of<WalletViewModel>(context);
                  await walletViewModel.deleteWallet(context, wallet);
                  if (walletViewModel.currentWallet == null) {
                  } else {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                } else {
                  Navigator.pop(context);
                  final error = AppError(type: AppErrorType.passwordIncorrect);
                  CapoDialogUtils.showErrorDialog(
                      error: error, context: context);
                }
              }).catchError((error) {
                Navigator.pop(context);
                CapoDialogUtils.showErrorDialog(error: error, context: context);
              });
            },
          );
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

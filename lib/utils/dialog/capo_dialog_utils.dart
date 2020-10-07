import 'package:capo/modules/common/dialog/password_dialog.dart';
import 'package:capo/modules/common/view/loading.dart';
import 'package:capo/utils/wallet_view_model.dart';
import 'package:capo_core_dart/capo_core_dart.dart';
import 'package:easy_localization/public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../capo_utils.dart';

typedef PrivateKeyCallback = void Function(String);

class CapoDialogUtils {
  static void showCupertinoDialog(
      {@required BuildContext buildContext,
      @required String message,
      VoidCallback okTapped}) {
    var dialog = CupertinoAlertDialog(
      content: Text(
        message != null ? message : "",
        style: TextStyle(fontSize: 20),
      ),
      actions: <Widget>[
        CupertinoButton(
          child: Text(
            tr("sendPage.dialogBtn"),
            style: TextStyle(color: HexColor.mainColor),
          ),
          onPressed: () {
            Navigator.pop(buildContext);
            if (okTapped != null) {
              okTapped();
            }
          },
        ),
      ],
    );

    showDialog(context: buildContext, builder: (_) => dialog);
  }

  static showPasswordDialog(
      {@required BuildContext buildContext,
      @required String tip,
      @required PrivateKeyCallback decryptSuccess}) {
    WalletViewModel walletViewModel =
        Provider.of<WalletViewModel>(buildContext);
    BasicWallet wallet = walletViewModel.currentWallet;
    var decryptError;
    showDialog(
        context: buildContext,
        builder: (_) {
          return PasswordDialog(
            wallet: wallet,
            okClick: (password) async {
              showProcessIndicator(context: buildContext, tip: tip);
              final String privateKey = await wallet
                  .exportPrivateKey(password: password)
                  .catchError((error) {
                decryptError = error;
                Navigator.pop(buildContext);
                showErrorDialog(error: error, context: buildContext);
              });
              if (decryptError != null) {
                return;
              }
              Navigator.pop(buildContext);
              if (decryptSuccess != null) {
                decryptSuccess(privateKey);
              }
            },
          );
        });
  }

  static showErrorDialog({@required error, @required BuildContext context}) {
    String errorText;
    if (error is AppError) {
      final type = error.type;
      if (type == AppErrorType.passwordIncorrect) {
        errorText = tr("settings.wallets.detail.password_invalid");
      } else if (type == AppErrorType.addressAlreadyExist) {
        errorText = tr("appError.addressError.address_already_exist");
      } else if (type == AppErrorType.mnemonicInvalid) {
        errorText = tr("wallet.restore.from_mnemonic.mnemonic_not_validate");
      } else if (type == AppErrorType.privateKeyInvalid) {
        errorText =
            tr("wallet.restore.from_private_key.private_key_not_validate");
      } else {
        errorText = tr("appError.genericError");
      }
    } else if (error is PlatformException) {
      if (error.code == "10005") {
        errorText = tr("settings.wallets.detail.password_invalid");
      } else if (error.code == "10002") {
        errorText = tr("wallet.restore.from_mnemonic.mnemonic_not_validate");
      } else {
        errorText = tr("appError.genericError");
      }
    } else {
      errorText = tr("appError.genericError");
    }

    showCupertinoDialog(buildContext: context, message: errorText);
  }

  static showProcessIndicator({@required BuildContext context, String tip}) {
    showDialog(
        context: context,
        builder: (_) {
          return Loading(
            widget: CupertinoActivityIndicator(
              radius: 13,
            ),
            text: tip,
          );
        });
  }
}

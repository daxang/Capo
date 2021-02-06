import 'package:capo/dapp_browser/dapp_model/dapp_model.dart';
import 'package:capo/modules/common/dialog/password_dialog.dart';
import 'package:capo/modules/common/view/loading.dart';
import 'package:capo/utils/dialog/call_contract_bottom_sheet_view.dart';
import 'package:capo/utils/wallet_view_model.dart';
import 'package:capo_core_dart/capo_core_dart.dart';
import 'package:easy_localization/public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../capo_utils.dart';

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
                Navigator.pop(buildContext);
                showErrorDialog(error: error, context: buildContext);
              });

              if (decryptError != null) {
                return;
              }
              Navigator.pop(buildContext);
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
            text: tip ?? " ",
          );
        });
  }

  static Future<bool> showAccessBottomSheet(
      {@required DappInfoModel dAppInfo, @required String accessDesc}) async {
    BuildContext context = currentContext;
    bool isAccess = await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            Container(
              height: 320 + MediaQuery.of(context).padding.bottom,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 30, 16, 0),
                  child: Column(
                    children: <Widget>[
                      Image.network(
                        dAppInfo.icon ?? null,
                        alignment: Alignment.center,
                        height: 60,
                        width: 60,
                      ),
                      Container(
                          height: 40,
                          child: Center(
                              child: Text(
                            dAppInfo.name ?? "",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ))),
                      Container(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                          height: 50,
                          child: Center(
                              child: Text(
                            (dAppInfo.name ?? "") + " " + accessDesc,
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 14),
                            textAlign: TextAlign.center,
                          ))),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: CupertinoButton(
                                color: Color.fromARGB(255, 226, 236, 246),
                                padding: EdgeInsets.all(16),
                                pressedOpacity: 0.8,
                                child: Text(
                                  tr("DApp_browser.reject"),
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .apply(
                                          color: Color.fromARGB(
                                              255, 51, 118, 184)),
                                ),
                                onPressed: () {
                                  Navigator.pop(context, false);
                                }),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: CupertinoButton(
                                color: Color.fromARGB(255, 51, 118, 184),
                                padding: EdgeInsets.all(16),
                                pressedOpacity: 0.8,
                                child: Text(
                                  tr("DApp_browser.confirm"),
                                  style: Theme.of(context).textTheme.button,
                                ),
                                onPressed: () {
                                  Navigator.pop(context, true);
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        );
      },
    );
    if (isAccess != null && isAccess) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> showCallContractAccessBottomSheet(
      {@required DappInfoModel dAppInfo,
      @required String accessDesc,
      @required PrivateKeyCallback decryptSuccess}) async {
    BuildContext context = currentContext;
    bool isAccess = await showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8))),
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 320 + MediaQuery.of(context).viewInsets.bottom,
          child: CallContractBottomSheetView(
            dAppInfo: dAppInfo,
            accessDesc: accessDesc,
            decryptSuccess: decryptSuccess,
          ),
        );
      },
    );
    if (isAccess != null && isAccess) {
      return true;
    } else {
      return false;
    }
  }
}

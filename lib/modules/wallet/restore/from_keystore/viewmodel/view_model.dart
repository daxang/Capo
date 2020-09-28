import 'dart:core';

import 'package:capo/modules/common/view/loading.dart';
import 'package:capo/utils/capo_utils.dart';
import 'package:capo/utils/dialog/capo_dialog_utils.dart';
import 'package:capo/utils/wallet_view_model.dart';
import 'package:capo_core_dart/capo_core_dart.dart';
import 'package:easy_localization/public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class FromPrivateKeyViewModel with ChangeNotifier {
  PublishSubject<String> keystoreKeySubject = PublishSubject<String>();
  PublishSubject<String> walletNameSubject = PublishSubject<String>();
  PublishSubject<String> walletPasswordSubject = PublishSubject<String>();

  String keystoreString;
  String walletNameString;
  String walletPasswordString;
  bool isButtonAvailable = false;
  bool isPasswordAvailable = true;
  bool isRepeatPasswordMatch = true;
  bool _disposed = false;
  FromPrivateKeyViewModel() {
    isButtonAvailableObservable
        .distinct()
        .doOnEach((value) => isButtonAvailable = value.value)
        .doOnEach((_) => notifyListeners())
        .listen((_) {});

    keystoreKeySubject
        .distinct()
        .doOnEach((observable) => keystoreString = observable.value)
        .listen((_) {});

    walletNameSubject
        .distinct()
        .doOnEach((observable) => walletNameString = observable.value)
        .listen((_) {});

    walletPasswordSubject
        .distinct()
        .doOnEach((observable) => walletPasswordString = observable.value)
        .listen((_) {});
  }

  Stream<bool> get isButtonAvailableObservable => Rx.combineLatest3(
          keystoreKeySubject, walletNameSubject, walletPasswordSubject,
          (String mnemonic, String walletName, String walletPassword) {
        return mnemonic.isNotEmpty &&
            walletName.isNotEmpty &&
            walletPassword.isNotEmpty;
      });

  Future btnTapped(context) async {
    if (!checkInput()) return;
    CapoDialogUtils.showProcessIndicator(
        context: context, tip: tr("wallet.restore.from_keystore.importing"));

    var importError;
    await WalletManager.importFromKeystore(
            password: walletPasswordString,
            keystoreString: keystoreString,
            name: walletNameString)
        .catchError((error) {
      importError = error;
      Navigator.of(context).pop();
      CapoDialogUtils.showErrorDialog(error: error, context: context);
    });

    if (importError != null) {
      return;
    }
    Navigator.of(context).pop();
    showToastWidget(Loading(
      widget: Icon(
        Icons.check,
        size: 40,
        color: HexColor.mainColor,
      ),
      text: tr("wallet.restore.from_keystore.success"),
    ));

    showToastWidget(
      Container(
        width: 130.0,
        height: 130.0,
        decoration: ShapeDecoration(
          color: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check,
              size: 40,
              color: HexColor.mainColor,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(5, 15, 5, 5),
              child: FittedBox(
                child: Text(
                  tr("wallet.restore.from_keystore.success"),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    Navigator.pushNamedAndRemoveUntil(
        context, "capo://icapo.app/tabbar", (Route<dynamic> route) => false);
  }

  bool checkInput() {
    if (walletPasswordString.length < 8) {
      isPasswordAvailable = false;
      notifyListeners();
      return false;
    } else {
      isPasswordAvailable = true;
    }

    notifyListeners();
    return true;
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  void dispose() {
    _disposed = true;
    keystoreKeySubject.close();
    walletNameSubject.close();
    walletPasswordSubject.close();
    super.dispose();
  }
}

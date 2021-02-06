import 'dart:core';

import 'package:capo/modules/common/view/loading.dart';
import 'package:capo/utils/dialog/capo_dialog_utils.dart';
import 'package:capo_core_dart/capo_core_dart.dart';
import 'package:easy_localization/public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:rxdart/rxdart.dart';

class FromMnemonicViewModel with ChangeNotifier {
  PublishSubject<String> mnemonicSubject = PublishSubject<String>();
  PublishSubject<String> walletNameSubject = PublishSubject<String>();
  PublishSubject<String> walletPasswordSubject = PublishSubject<String>();
  PublishSubject<String> repeatPasswordSubject = PublishSubject<String>();

  String mnemonicString;
  String walletNameString;
  String walletPasswordString;
  String repeatPasswordString;

  bool isButtonAvailable = false;
  bool isPasswordAvailable = true;
  bool isRepeatPasswordMatch = true;
  bool _disposed = false;
  FromMnemonicViewModel() {
    isButtonAvailableObservable
        .distinct()
        .doOnEach((value) => isButtonAvailable = value.value)
        .doOnEach((_) => notifyListeners())
        .listen((_) {});

    mnemonicSubject
        .distinct()
        .doOnEach((observable) => mnemonicString = observable.value)
        .listen((_) {});

    walletNameSubject
        .distinct()
        .doOnEach((observable) => walletNameString = observable.value)
        .listen((_) {});

    walletPasswordSubject
        .distinct()
        .doOnEach((observable) => walletPasswordString = observable.value)
        .listen((_) {});

    repeatPasswordSubject
        .distinct()
        .doOnEach((observable) => repeatPasswordString = observable.value)
        .listen((_) {});
  }

  Stream<bool> get isButtonAvailableObservable => Rx.combineLatest4(
          mnemonicSubject,
          walletNameSubject,
          walletPasswordSubject,
          repeatPasswordSubject, (String mnemonic, String walletName,
              String walletPassword, String repeatPassword) {
        return mnemonic.isNotEmpty &&
            walletName.isNotEmpty &&
            walletPassword.isNotEmpty &&
            repeatPassword.isNotEmpty;
      });

  Future btnTapped(context) async {
    if (!checkInput()) return;
    CapoDialogUtils.showProcessIndicator(
        context: context, tip: tr("wallet.restore.from_mnemonic.importing"));
    var importError;
    await WalletManager.importFromMnemonic(
            password: walletPasswordString,
            mnemonic: mnemonicString,
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
    SmartDialog.show(
        widget: Loading(
      widget: Icon(
        Icons.check,
        size: 50,
      ),
      text: tr("wallet.restore.from_mnemonic.success"),
    ));

    Navigator.pushNamedAndRemoveUntil(
        context, "capo://icapo.app/tabbar", (Route<dynamic> route) => false);
    await Future.delayed(Duration(seconds: 2));
    SmartDialog.dismiss();
  }

  bool checkInput() {
    if (walletPasswordString.length < 8) {
      isPasswordAvailable = false;
      notifyListeners();
      return false;
    } else {
      isPasswordAvailable = true;
    }

    if (walletPasswordString != repeatPasswordString) {
      isRepeatPasswordMatch = false;
      notifyListeners();
      return false;
    } else {
      isRepeatPasswordMatch = true;
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
    mnemonicSubject.close();
    walletNameSubject.close();
    walletPasswordSubject.close();
    repeatPasswordSubject.close();
    super.dispose();
  }
}

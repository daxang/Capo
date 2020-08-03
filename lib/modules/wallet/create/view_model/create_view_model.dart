import 'dart:core';

import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class CreateWalletViewModel with ChangeNotifier {
  PublishSubject<String> walletNameSubject = PublishSubject<String>();
  PublishSubject<String> walletPasswordSubject = PublishSubject<String>();
  PublishSubject<String> repeatPasswordSubject = PublishSubject<String>();

  String walletNameString;
  String walletPasswordString;
  String repeatPasswordString;

  bool isButtonAvailable = false;
  bool isPasswordAvailable = true;
  bool isRepeatPasswordMatch = true;
  bool _disposed = false;
  final String mnemonic = bip39.generateMnemonic();

  CreateWalletViewModel() {
    isButtonAvailableObservable
        .distinct()
        .doOnEach((value) => isButtonAvailable = value.value)
        .doOnEach((_) => notifyListeners())
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

  Stream<bool> get isButtonAvailableObservable => Rx.combineLatest3(
          walletNameSubject, walletPasswordSubject, repeatPasswordSubject,
          (String walletName, String walletPassword, String repeatPassword) {
        return walletName.isNotEmpty &&
            walletPassword.isNotEmpty &&
            repeatPassword.isNotEmpty;
      });

  void createBtnTapped(context) {
    if (walletPasswordString.length < 8) {
      isPasswordAvailable = false;
      notifyListeners();
      return;
    } else {
      isPasswordAvailable = true;
    }

    if (walletPasswordString != repeatPasswordString) {
      isRepeatPasswordMatch = false;
      notifyListeners();
      return;
    } else {
      isRepeatPasswordMatch = true;
    }

    notifyListeners();
    Map map = {
      "walletName": walletNameString,
      "walletPassword": walletPasswordString,
      "mnemonic": mnemonic
    };
    Navigator.pushNamed(context, "capo://icapo.app/wallet/backup/tip",
        arguments: map);
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  void dispose() {
    _disposed = true;
    walletNameSubject.close();
    walletPasswordSubject.close();
    repeatPasswordSubject.close();
    super.dispose();
  }
}

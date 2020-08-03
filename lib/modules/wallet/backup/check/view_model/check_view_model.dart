import 'package:capo/modules/common/view/loading.dart';
import 'package:capo/utils/wallet_view_model.dart';
import 'package:capo_core_dart/capo_core_dart.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class CheckViewModel extends ChangeNotifier {
  PublishSubject<String> firstWordSubject = PublishSubject<String>();
  PublishSubject<String> secondWordSubject = PublishSubject<String>();

  String firstWord;
  String secondWord;

  int firstIndex = 0;
  int secondIndex = 0;

  bool isButtonAvailable = false;

  bool firstWordCorrect = true;
  bool secondWordCorrect = true;
  String mnemonic;
  final Map arguments;
  String walletName;
  String password;

  bool showLoading = false;
  CheckViewModel(this.arguments) {
    this.mnemonic = arguments['mnemonic'];
    this.walletName = arguments['walletName'];
    this.password = arguments['walletPassword'];

    var list = new List<int>.generate(12, (int index) => index);
    list.shuffle();
    firstIndex = list[0] + 1;
    secondIndex = list[1] + 1;

    firstWordSubject.distinct().doOnEach((observable) {
      if (observable.value != null) firstWord = observable.value.trimRight();
    }).listen((_) {});

    secondWordSubject.distinct().doOnEach((observable) {
      if (observable.value != null) secondWord = observable.value.trimRight();
    }).listen((_) {});
    _isButtonAvailableObservable
        .distinct()
        .doOnEach((observable) => isButtonAvailable = observable.value)
        .doOnEach((_) => notifyListeners())
        .listen((_) {});
  }

  Stream<bool> get _isButtonAvailableObservable =>
      Rx.combineLatest2(firstWordSubject, secondWordSubject, (
        String firstWord,
        String secondWord,
      ) {
        return firstWord.isNotEmpty && secondWord.isNotEmpty;
      });

  btnTapped(context) async {
    if (!checkMnemonic()) return;
    showProcessIndicator(context);
    final meta = WalletMeta(
        name: walletName,
        source: Source.create,
        timestamp: DateTime.now().millisecondsSinceEpoch);

    var viewModel = Provider.of<WalletViewModel>(context);
    viewModel.walletManager
        .importFromMnemonic(
      password: password,
      mnemonic: mnemonic,
      metadata: meta,
    )
        .then((keystore) {
      Navigator.of(context).pop();
      showToastWidget(
        Loading(
          widget: Icon(
            Icons.check,
            size: 50,
          ),
          text: tr("wallet.backup.check.success"),
        ),
        context: context,
        dismissOtherToast: true,
      );
      Navigator.pushNamedAndRemoveUntil(
          context, "capo://icapo.app/tabbar", (Route<dynamic> route) => false);
    }).catchError((error) {
      Navigator.of(context).pop();
      showErrorToast(error, context);
    });
  }

  bool checkMnemonic() {
    List<String> wordsList = mnemonic.split(" ");
    if (wordsList[firstIndex - 1] != firstWord) {
      firstWordCorrect = false;
      notifyListeners();
      return false;
    } else {
      firstWordCorrect = true;
    }

    if (wordsList[secondIndex - 1] != secondWord) {
      secondWordCorrect = false;
      notifyListeners();
      return false;
    } else {
      secondWordCorrect = true;
    }
    notifyListeners();
    return true;
  }

  showProcessIndicator(context) {
    showDialog(
        context: context,
        builder: (_) {
          final indicator = CircularProgressIndicator(
            strokeWidth: 2.4,
            valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).focusColor),
          );
          return Loading(
            widget: indicator,
            text: tr("wallet.backup.check.creating"),
          );
        });
  }

  showErrorToast(error, context) {
    String errorText;
    if (error is AppError) {
      final type = error.type;
      if (type == AppErrorType.addressAlreadyExist) {
        errorText = tr("appError.addressError.address_already_exist");
      } else if (type == AppErrorType.mnemonicInvalid) {
        errorText = tr("wallet.restore.from_mnemonic.mnemonic_not_validate");
      } else {
        errorText = tr("appError.genericError");
      }
    } else {
      errorText = tr("appError.genericError");
    }

    showToastWidget(
        Loading(
          widget: Icon(
            Icons.close,
            size: 50,
          ),
          text: errorText,
        ),
        context: context,
        dismissOtherToast: true,
        handleTouch: true);
  }

  bool _disposed = false;

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    firstWordSubject.close();
    secondWordSubject.close();
    super.dispose();
  }
}

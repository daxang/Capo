import 'package:capo/dapp_browser/dapp_model/dapp_model.dart';
import 'package:capo/modules/common/dialog/password_dialog.dart';
import 'package:capo_core_dart/capo_core_dart.dart';
import 'package:easy_localization/public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

typedef PrivateKeyCallback = void Function(String);

class CallContractBottomSheetView extends StatefulWidget {
  final DappInfoModel dAppInfo;
  final String accessDesc;
  final PrivateKeyCallback decryptSuccess;

  CallContractBottomSheetView(
      {Key key, this.dAppInfo, this.accessDesc, this.decryptSuccess})
      : super(key: key);

  @override
  _CallContractBottomSheetViewState createState() =>
      _CallContractBottomSheetViewState();
}

class _CallContractBottomSheetViewState
    extends State<CallContractBottomSheetView> {
  final _pageController = PageController(initialPage: 0);

  BasicWallet currentWallet = WalletManager().currentWallet;

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(16, 30, 16, 0),
                child: Column(
                  children: <Widget>[
                    Image.network(
                      widget.dAppInfo.icon ?? null,
                      alignment: Alignment.center,
                      height: 60,
                      width: 60,
                    ),
                    Container(
                        height: 40,
                        child: Center(
                            child: Text(
                          widget.dAppInfo.name ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ))),
                    Container(
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                        height: 50,
                        child: Center(
                            child: Text(
                          (widget.dAppInfo.name ?? "") +
                              " " +
                              widget.accessDesc,
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
                                style: Theme.of(context).textTheme.button.apply(
                                    color: Color.fromARGB(255, 51, 118, 184)),
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
                                _pageController.nextPage(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut);
                              }),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          width: double.infinity,
          color: Theme.of(context).cardColor,
          child: Column(children: <Widget>[
            ListTile(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 30,
                ),
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _pageController.previousPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut);
                },
              ),
            ),
            PasswordWidget(
                null,
                (password) async => {
                      FocusScope.of(context).requestFocus(FocusNode()),
                      SmartDialog.showLoading(msg: tr("sendPage.signing")),
                      await currentWallet
                          .exportPrivateKey(password: password)
                          .then((privateKey) => {
                                SmartDialog.dismiss(),
                                if (widget.decryptSuccess != null)
                                  {
                                    widget.decryptSuccess(privateKey),
                                  }
                              })
                          .catchError((error) {
                        SmartDialog.dismiss();
                        if (error is PlatformException) {
                          if (error.code == "10005") {
                            SmartDialog.showToast(
                                tr("DApp_browser.password_error"));
                          }
                          return;
                        }
                        SmartDialog.showToast(error.toString());
                      }),
                    }),
          ]),
        )
      ],
    );
  }
}

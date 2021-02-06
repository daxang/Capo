import 'dart:async';

import 'package:capo/dapp_browser/dapp_access_manager/dapp_access_manager.dart';
import 'package:capo/dapp_browser/dapp_model/dapp_access_model.dart';
import 'package:capo/dapp_browser/dapp_model/dapp_call_contract_model.dart';
import 'package:capo/dapp_browser/dapp_model/dapp_share_model.dart';
import 'package:capo/utils/capo_utils.dart';
import 'package:capo/utils/dialog/capo_dialog_utils.dart';
import 'package:capo/utils/rnode_networking.dart';
import 'package:capo/utils/wallet_view_model.dart';
import 'package:capo_core_dart/capo_core_dart.dart';
import 'package:easy_localization/public.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_jsbridge_plugin/js_bridge.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:rnode_grpc_dart/rnode_grpc_dart.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'dapp_model/dapp_model.dart';

@FFRoute(name: "capo://icapo.app/dappbrowser")
class DAppBrowserPage extends StatefulWidget {
  DAppBrowserPage({Key key}) : super(key: key);
  @override
  _DAppBrowserPageState createState() => _DAppBrowserPageState();
}

class _DAppBrowserPageState extends State<DAppBrowserPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  final JsBridge _jsBridge = JsBridge();
  bool showDappBrowser = false;
  DappInfoModel dAppInfo;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map map = ModalRoute.of(context).settings.arguments;
    if (map != null && map['data'] != null) {
      String data = map['data'] as String;
      dAppInfo = dappInfoModelFromJson(data);
      if (dAppInfo != null && dAppInfo.url.isNotEmpty) {
        setState(() {
          showDappBrowser = true;
        });
      }
    }
    return MaterialApp(
      home: Scaffold(
          appBar: showDappBrowser
              ? AppBar(
                  title: Text(
                    dAppInfo.name,
                    style: TextStyle(color: Colors.black87),
                  ),
                  centerTitle: true,
                  backgroundColor: HexColor.fromHex("#fbfbfd"),
                  shadowColor: Colors.black12,
                  actions: <Widget>[
                    // IconButton(
                    //     icon: Icon(
                    //       Icons.more_horiz,
                    //       color: Colors.black45,
                    //     ),
                    //     onPressed: () {}),
                    IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.black45,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ],
                  bottom: new PreferredSize(
                    preferredSize: const Size.fromHeight(0.5),
                    child: new Theme(
                      data:
                          Theme.of(context).copyWith(accentColor: Colors.white),
                      child: new Container(
                        height: 0.5,
                        color: Colors.black26,
                      ),
                    ),
                  ),
                )
              : null,
          body: WebView(
            // https://dapp.icapo.app/dappbrowser/#
            // http://192.168.55.149:8080/#/
            initialUrl: showDappBrowser
                ? dAppInfo.url
                : "https://dapp.icapo.app/dappbrowser/#",
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) async {
              _jsBridge.setWebViewController(webViewController);
              _controller.complete(webViewController);
              registerHandler();
            },
            navigationDelegate: (NavigationRequest request) {
              if (_jsBridge.handlerUrl(request.url)) {
                return NavigationDecision.navigate;
              }
              return NavigationDecision.prevent;
            },
            onPageStarted: (url) {
              _jsBridge.init();
              // CapoBridge.shared().capoJSBridge.init();
              print("onPageStarted:$url");
            },
            onPageFinished: (url) {
              _jsBridge.init();
            },
          )),
    );
  }

  registerHandler() {
    _jsBridge.registerHandler("openDApp", onCallBack: (data, _) {
      Navigator.pushNamed(currentContext, "capo://icapo.app/dappbrowser",
          arguments: {"data": data});
      // func({"success": true});
    });

    _jsBridge.registerHandler("share", onCallBack: (data, _) {
      DAppShareModel dAppShareModel = dAppShareModelFromJson(data);
      final String share = dAppShareModel.title + '\n' + dAppShareModel.url;
      Share.share(share, subject: dAppShareModel.content ?? "");
    });

    _jsBridge.registerHandler("callContract",
        onCallBack: (data, jsCallback) async {
      final String desc = tr("DApp_browser.contract_access_desc");
      DAppCallContractModel dAppCallContractModel =
          dAppCallContractModelFromJson(data);
      if (dAppCallContractModel == null ||
          dAppCallContractModel.term == null ||
          dAppCallContractModel.term.isEmpty) {
        jsCallback({
          "error": {"code": 1003, "message": tr("DApp_browser.contract_error")}
        });
        return;
      }

      bool isAccess = await CapoDialogUtils.showCallContractAccessBottomSheet(
          dAppInfo: dAppInfo,
          accessDesc: desc,
          decryptSuccess: (privateKey) => {
                Navigator.of(context).pop(true),
                doDeploy(
                    privateKey: privateKey,
                    term: dAppCallContractModel.term,
                    jsCallback: jsCallback),
              });

      if (!isAccess) {
        jsCallback({
          "error": {
            "code": 1001,
            "message": tr("DApp_browser.user_not_authorized")
          }
        });
      }
    });

    _jsBridge.registerHandler("getREVAddress",
        onCallBack: (data, jsCallback) async {
      String address = WalletManager.shared.currentWallet.address;
      String revAmount = WalletViewModel.shared.revBalance;
      if (dAppInfo == null || dAppInfo.url.isEmpty) {
        jsCallback({
          "error": {
            "code": 1002,
            "message": tr("DApp_browser.dApp_not_authorized")
          }
        });
        return;
      }
      bool queryAccess = DAppAccessManager.getSharedInstance()
          .queryDAppAddressAccess(dAppURL: dAppInfo.url);
      if (queryAccess) {
        jsCallback({"address": address, "revAmount": revAmount});
        return;
      }

      final String desc = tr("DApp_browser.address_access_desc");
      bool isAccess = await CapoDialogUtils.showAccessBottomSheet(
          dAppInfo: dAppInfo, accessDesc: desc);
      DAppAccessModel dApp = DAppAccessModel();
      dApp.name = dAppInfo.name;
      dApp.url = dAppInfo.url;
      dApp.addressAccess = isAccess;

      DAppAccessManager.getSharedInstance().dAppAccessMap[dApp.url] =
          dAppAccessModelToJson(dApp);
      DAppAccessManager.getSharedInstance().saveAccessSettings2Storage();
      if (isAccess) {
        jsCallback({"address": address, "revAmount": revAmount});
      } else {
        jsCallback({
          "error": {
            "code": 1001,
            "message": tr("DApp_browser.user_not_authorized")
          }
        });
      }
    });
  }

  doDeploy(
      {@required String privateKey,
      @required String term,
      @required CallBackFunction jsCallback}) async {
    BuildContext buildContext = currentContext;
    SmartDialog.showLoading(msg: tr("sendPage.fetching_node"));

    await RNodeNetworking.setDeployGRPCNetwork();

    SmartDialog.showLoading(msg: tr("sendPage.sending"));

    RNodeDeployGRPCService.shared
        .sendDeploy(deployCode: term, privateKey: privateKey)
        .then((Map map) async {
      DeployResponse response = map["response"];
      String deployID = map["deployID"];

      String error = (response.error.messages != null &&
              response.error.messages.length > 0)
          ? response.error.messages.first
          : null;
      if (error != null && error.length > 0) {
        print("error1: ${error.toString()}");

        SmartDialog.dismiss();
        // Navigator.of(context).pop(true);

        jsCallback({
          "error": {"code": 1100, "message": error.toString()}
        });
      } else {
        SmartDialog.dismiss();
        // Navigator.of(context).pop(true);
        jsCallback({"deployID": deployID});
        print("deployID: $deployID");
      }
    }).catchError((error) {
      jsCallback({
        "error": {"code": 1101, "message": tr("DApp_browser.deploy_error")}
      });
      print("error3: ${error.toString()}");
      SmartDialog.dismiss();
      // Navigator.of(context).pop(true);
    });
  }
}

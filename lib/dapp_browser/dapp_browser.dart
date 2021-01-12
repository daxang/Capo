import 'dart:async';

import 'package:capo/jsbridge/jsbridge.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BrowserPage extends StatefulWidget {
  BrowserPage({Key key}) : super(key: key);
  @override
  _BrowserPageState createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: WebView(
        initialUrl: "http://192.168.55.149:8080/",
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) async {
          _controller.complete(webViewController);
          CapoBridge.shared().capoJSBridge.loadJs(webViewController);
        },
        navigationDelegate: (NavigationRequest request) {
          if (CapoBridge.shared().capoJSBridge.handlerUrl(request.url)) {
            return NavigationDecision.navigate;
          }
          return NavigationDecision.prevent;
        },
        onPageStarted: (url) {
          // CapoBridge.shared().capoJSBridge.init();
        },
        onPageFinished: (url) {},
      )),
    );
  }
}

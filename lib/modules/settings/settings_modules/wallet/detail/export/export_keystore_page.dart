import 'package:easy_localization/public.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

@FFRoute(name: "capo://icapo.app/settings/wallets/detail/export_keystore")
class ExportKeystorePage extends StatelessWidget {
  ExportKeystorePage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: PreferredSize(
          preferredSize: Size.fromHeight(44),
          child: AppBar(
            title: Text(
                tr("settings.wallets.detail.export_keystore_page.title"),
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
      body: SafeArea(child: bodyWidget(context)),
    );
  }

  Widget bodyWidget(context) {
    String keystore;
    final Map map = ModalRoute.of(context).settings.arguments;
    if (map != null && map.isNotEmpty) {
      keystore = map['keystore'];
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(children: [
        ListView(
          children: <Widget>[
            Text(
              tr("settings.wallets.detail.export_keystore_page.export_tip"),
              style:
                  Theme.of(context).textTheme.headline6.apply(fontSizeDelta: 5),
            ),
            SizedBox(
              height: 14,
            ),
            Text(
              tr("settings.wallets.detail.export_keystore_page.desc"),
              style:
                  Theme.of(context).textTheme.caption.apply(fontSizeDelta: 5),
            ),
            SizedBox(
              height: 25,
            ),
            SizedBox(
              height: 0.5,
              child: Container(
                color: Theme.of(context).textTheme.caption.color,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              tr("settings.wallets.detail.export_keystore_page.first_tip"),
              style:
                  Theme.of(context).textTheme.caption.apply(fontSizeDelta: 4),
              maxLines: 2,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              tr("settings.wallets.detail.export_keystore_page.second_tip"),
              style:
                  Theme.of(context).textTheme.caption.apply(fontSizeDelta: 4),
              maxLines: 2,
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: Text(
                keystore,
                style:
                    Theme.of(context).textTheme.caption.apply(fontSizeDelta: 1),
                maxLines: 20,
              ),
              decoration: new BoxDecoration(
                border: new Border.all(
                    width: 1.5, color: Theme.of(context).dividerColor),
                color: Theme.of(context).dividerColor,
                borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
              ),
            )
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: CupertinoButton(
            padding: EdgeInsets.all(16),
            pressedOpacity: 0.8,
            color: Color.fromARGB(255, 51, 118, 184),
            child: Text(
              tr("settings.wallets.detail.export_keystore_page.btn_title"),
              style: Theme.of(context).textTheme.button,
            ),
            onPressed: () async {
              final data = ClipboardData(text: keystore);
              await Clipboard.setData(data);
              SmartDialog.showToast(
                  tr("settings.wallets.detail.export_keystore_page.copied"));
            },
          ),
        )
      ]),
    );
  }
}

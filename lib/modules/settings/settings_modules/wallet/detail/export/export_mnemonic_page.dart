import 'package:easy_localization/public.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

@FFRoute(name: "capo://icapo.app/settings/wallets/detail/export_mnemonic")
class ExportMnemonicPage extends StatelessWidget {
  ExportMnemonicPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: AppBar(
          title: Text(tr("settings.wallets.detail.export_mnemonic_page.title"),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ),
      ),
      body: SafeArea(child: bodyWidget(context)),
    );
  }

  Widget bodyWidget(context) {
    List<String> wordList;
    String mnemonic;
    final Map map = ModalRoute.of(context).settings.arguments;
    if (map != null && map.isNotEmpty) {
      mnemonic = map['mnemonic'];
      wordList = mnemonic.split(" ");
    }
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(children: [
        ListView(
          children: <Widget>[
            Text(
              tr("settings.wallets.detail.export_mnemonic_page.export_tip"),
              style:
                  Theme.of(context).textTheme.headline6.apply(fontSizeDelta: 5),
            ),
            SizedBox(
              height: 14,
            ),
            Text(
              tr("settings.wallets.detail.export_mnemonic_page.desc"),
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
              tr("settings.wallets.detail.export_mnemonic_page.first_tip"),
              style:
                  Theme.of(context).textTheme.caption.apply(fontSizeDelta: 4),
              maxLines: 2,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              tr("settings.wallets.detail.export_mnemonic_page.second_tip"),
              style:
                  Theme.of(context).textTheme.caption.apply(fontSizeDelta: 4),
              maxLines: 2,
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: wordList == null || wordList.isEmpty
                  ? Container()
                  : Container(
                      height: MediaQuery.of(context).size.height - 390.0,
                      child: Scrollbar(
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: wordList.length,
                            itemBuilder: ((context, index) {
                              return Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 40,
                                    child: Text(
                                      (index + 1).toString() + ".",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .apply(
                                            fontSizeDelta: 4,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    wordList[index],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .apply(fontSizeDelta: 4),
                                  ),
                                ],
                              );
                            })),
                      ),
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
              tr("settings.wallets.detail.export_mnemonic_page.btn_title"),
              style: Theme.of(context).textTheme.button,
            ),
            onPressed: () async {
              final data = ClipboardData(text: mnemonic);
              await Clipboard.setData(data);
              showToast(
                  tr("settings.wallets.detail.export_mnemonic_page.copied"));
            },
          ),
        )
      ]),
    );
  }
}

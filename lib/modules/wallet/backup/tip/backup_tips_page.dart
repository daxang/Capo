import 'package:easy_localization/public.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@FFRoute(name: "capo://icapo.app/wallet/backup/tip")
class BackupTipsPage extends StatelessWidget {
  BackupTipsPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: AppBar(
//        title: Text(''),
            ),
      ),
      body: SafeArea(child: bodyWidget(context)),
    );
  }

  Widget bodyWidget(context) {
    final Map map = ModalRoute.of(context).settings.arguments;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(children: [
        ListView(
          children: <Widget>[
            Text(
              tr("wallet.backup.tip.backup_tip"),
              style:
                  Theme.of(context).textTheme.headline6.apply(fontSizeDelta: 5),
            ),
            SizedBox(
              height: 14,
            ),
            Text(
              tr("wallet.backup.tip.desc"),
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
              height: 30,
            ),
            Text(
              tr("wallet.backup.tip.first_tip"),
              style:
                  Theme.of(context).textTheme.caption.apply(fontSizeDelta: 4),
              maxLines: 5,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              tr("wallet.backup.tip.second_tip"),
              style:
                  Theme.of(context).textTheme.caption.apply(fontSizeDelta: 4),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              tr("wallet.backup.tip.third_tip"),
              style:
                  Theme.of(context).textTheme.caption.apply(fontSizeDelta: 4),
            ),
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
              tr("wallet.backup.tip.next_btn"),
              style: Theme.of(context).textTheme.button,
            ),
            onPressed: () {
              Navigator.pushNamed(
                  context, "capo://icapo.app/wallet/backup/show",
                  arguments: map);
            },
          ),
        )
      ]),
    );
  }
}

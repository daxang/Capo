import 'package:capo/modules/wallet/restore/from_keystore/view/from_keystore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter/material.dart';

import 'from_private_key/view/from_private_key_view.dart';

@FFRoute(name: "capo://icapo.app/wallet/restore")
class TabBarDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new TabBarDemoState();
  }
}

class TabBarDemoState extends State<TabBarDemo>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(tr("wallet.restore.title"),
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        bottom: new TabBar(
          indicatorColor: Color.fromARGB(255, 51, 118, 184),
          indicatorSize: TabBarIndicatorSize.label,
          tabs: <Widget>[
            // Tab(
            //   text: tr("wallet.restore.mnemonic"),
            // ),
            Tab(
              text: tr("wallet.restore.private_key"),
            ),
            Tab(
              text: tr("wallet.restore.keystore"),
            ),
          ],
          controller: _tabController,
        ),
      ),
      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          // FromMnemonicView(),
          FromPrivateKeyView(),
          FromKeystoreView()
        ],
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@FFRoute(name: "capo://icapo.app/wallet/guide")
class CreateWalletGuidePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool showAppBar = false;
    final Map map = ModalRoute.of(context).settings.arguments;
    if (map != null && map.isNotEmpty) {
      showAppBar = map['showAppBar'] == "true";
    }
    return Scaffold(
      appBar: showAppBar
          ? PreferredSize(preferredSize: Size.fromHeight(44), child: AppBar())
          : null,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
              child: Container(
                height: 360,
                width: MediaQuery.of(context).size.width,
//                color: Colors.teal,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: 220,
                      height: 200,
                      child: Image.asset(
                        "resources/images/background/guide.png",
                        fit: BoxFit.fitWidth,
                        height: 20.0,
                        width: 20.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FittedBox(
                        child: Text(tr("wallet.guide.desc"),
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .apply(fontSizeDelta: 1)),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: 10,
                left: 16,
                right: 16,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: CupertinoButton(
                            padding: EdgeInsets.all(16),
                            pressedOpacity: 0.8,
                            color: Color.fromARGB(255, 51, 118, 184),
                            child: Text(
                              tr("wallet.guide.create"),
                              style: Theme.of(context).textTheme.button,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, "capo://icapo.app/wallet/create");
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: CupertinoButton(
                            padding: EdgeInsets.all(16),
                            pressedOpacity: 0.8,
                            color: Colors.transparent,
                            child: Text(
                              tr("wallet.guide.restore"),
                              style: Theme.of(context).textTheme.button.apply(
                                  color: Color.fromARGB(255, 51, 118, 184)),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, "capo://icapo.app/wallet/restore");
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

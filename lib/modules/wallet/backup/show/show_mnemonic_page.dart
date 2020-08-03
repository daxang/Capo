import 'package:easy_localization/public.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@FFRoute(name: "capo://icapo.app/wallet/backup/show")
class ShowMnemonicPage extends StatelessWidget {
  ShowMnemonicPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: AppBar(
          title: Text(tr("wallet.backup.show.title"),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ),
      ),
      body: SafeArea(child: bodyWidget(context)),
    );
  }

  Widget bodyWidget(context) {
    final Map arguments = ModalRoute.of(context).settings.arguments;
    String mnemonic = arguments['mnemonic'];

    List<String> wordList = mnemonic.split(" ");
    return Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
              itemCount: wordList.length,
              itemBuilder: ((context, index) {
                return Row(
                  children: <Widget>[
                    SizedBox(
                      width: 40,
                      child: Text(
                        (index + 1).toString() + ".",
                        style: Theme.of(context).textTheme.headline6.apply(
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
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: CupertinoButton(
            padding: EdgeInsets.all(16),
            pressedOpacity: 0.8,
            color: Color.fromARGB(255, 51, 118, 184),
            child: Text(
              tr("wallet.backup.show.confirm_btn"),
              style: Theme.of(context).textTheme.button,
            ),
            onPressed: () {
              Navigator.pushNamed(
                  context, "capo://icapo.app/wallet/backup/check",
                  arguments: arguments);
            },
          ),
        )
      ],
    );
  }
}

import 'package:capo/modules/wallet/backup/check/view_model/check_view_model.dart';
import 'package:capo/provider/provider_widget.dart';
import 'package:easy_localization/public.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@FFRoute(name: "capo://icapo.app/wallet/backup/check")
// ignore: must_be_immutable
class CheckMnemonicPage extends StatelessWidget {
  CheckMnemonicPage({Key key}) : super(key: key);
  CheckViewModel viewModel;
  bool isLoad = false;
  Widget listView(context) {
    if (!isLoad) {
      final Map walletMap = ModalRoute.of(context).settings.arguments;
      viewModel = CheckViewModel(walletMap);
      isLoad = true;
    }

    return ProviderWidget<CheckViewModel>(
      model: viewModel,
      builder: (_, viewModel, __) => ListView(children: [
        Text(
          tr("wallet.backup.check.desc"),
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(
          height: 25,
        ),
        Row(children: [
          SizedBox(
            width: 37,
            child: Text(
              viewModel.firstIndex.toString() + ".",
              style:
                  Theme.of(context).textTheme.caption.apply(fontSizeDelta: 10),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: TextField(
              cursorColor: Theme.of(context).textTheme.subtitle1.color,
              keyboardType: TextInputType.text,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .apply(fontSizeDelta: -2),
              onChanged: (out) => viewModel.firstWordSubject.add(out),
              decoration: InputDecoration(
                  errorText: viewModel.firstWordCorrect
                      ? null
                      : tr("wallet.backup.check.word_mismatch"),
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  border: OutlineInputBorder()),
            ),
          ),
        ]),
        SizedBox(
          height: 16,
        ),
        Row(children: [
          SizedBox(
            width: 37,
            child: Text(
              viewModel.secondIndex.toString() + ".",
              style:
                  Theme.of(context).textTheme.caption.apply(fontSizeDelta: 10),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: TextField(
              cursorColor: Theme.of(context).textTheme.subtitle1.color,
              keyboardType: TextInputType.text,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .apply(fontSizeDelta: -2),
              onChanged: (out) => viewModel.secondWordSubject.add(out),
              decoration: InputDecoration(
                  errorText: viewModel.secondWordCorrect
                      ? null
                      : tr("wallet.backup.check.word_mismatch"),
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  border: OutlineInputBorder()),
            ),
          ),
        ]),
        SizedBox(
          height: 36,
        ),
        CupertinoButton(
          padding: EdgeInsets.all(16),
          pressedOpacity: 0.8,
          color: Color.fromARGB(255, 51, 118, 184),
          child: Text(
            tr("wallet.backup.check.next_btn"),
            style: Theme.of(context).textTheme.button,
          ),
          onPressed: viewModel.isButtonAvailable
              ? () {
                  viewModel.btnTapped(context);
                }
              : null,
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: AppBar(
          title: Text(tr("wallet.backup.check.title"),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: bodyWidget(context),
      ),
    );
  }

  Widget bodyWidget(context) => Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black54,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: listView(context),
        ),
      );
}

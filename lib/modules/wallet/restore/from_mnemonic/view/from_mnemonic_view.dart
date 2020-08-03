import 'package:capo/modules/common/dialog/password_field.dart';
import 'package:capo/modules/wallet/restore/from_mnemonic/viewmodel/view_model.dart';
import 'package:capo/provider/provider_widget.dart';
import 'package:easy_localization/public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FromMnemonicView extends StatefulWidget {
  FromMnemonicView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FromMnemonicState();
  }
}

class _FromMnemonicState extends State<FromMnemonicView>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final viewModel = FromMnemonicViewModel();
  Widget bodyWidget(context) => Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black54,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: listView(context),
        ),
      );

  Widget listView(context) {
    return ProviderWidget<FromMnemonicViewModel>(
        model: viewModel,
        builder: (_, viewModel, __) => ListView(
              children: <Widget>[
                TextField(
                  maxLines: 4,
                  cursorColor: Theme.of(context).textTheme.subtitle1.color,
                  keyboardType: TextInputType.text,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .apply(fontSizeDelta: 1),
                  onChanged: (out) => viewModel.mnemonicSubject.add(out),
                  decoration: InputDecoration(
                      hintText:
                          tr("wallet.restore.from_mnemonic.mnemonic_hint_text"),
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 16,
                ),
                TextField(
                  maxLength: 12,
                  cursorColor: Theme.of(context).textTheme.subtitle1.color,
                  keyboardType: TextInputType.text,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .apply(fontSizeDelta: -2),
                  onChanged: (out) => viewModel.walletNameSubject.add(out),
                  decoration: InputDecoration(
                      labelText: tr("wallet.create.wallet_name"),
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 16,
                ),
                PasswordField(
                  autoFocus: false,
                  errorText: viewModel.isPasswordAvailable
                      ? null
                      : tr("wallet.create.password_error"),
                  labelText: tr("wallet.create.wallet_password"),
                  onChanged: (value) =>
                      viewModel.walletPasswordSubject.add(value),
                ),
                SizedBox(
                  height: 16,
                ),
                PasswordField(
                  autoFocus: false,
                  errorText: viewModel.isRepeatPasswordMatch
                      ? null
                      : tr("wallet.create.password_mismatch"),
                  labelText: tr("wallet.create.repeat_password"),
                  onChanged: (value) =>
                      viewModel.repeatPasswordSubject.add(value),
                ),
                SizedBox(
                  height: 30,
                ),
                CupertinoButton(
                  padding: EdgeInsets.all(16),
                  pressedOpacity: 0.8,
                  color: Color.fromARGB(255, 51, 118, 184),
                  child: Text(
                    tr("wallet.restore.from_mnemonic.btnTitle"),
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed: viewModel.isButtonAvailable
                      ? () {
                          viewModel.btnTapped(context);
                        }
                      : null,
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (_) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: bodyWidget(context),
    );
  }
}

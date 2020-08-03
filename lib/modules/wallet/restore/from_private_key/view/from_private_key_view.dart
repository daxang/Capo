import 'package:capo/modules/common/dialog/password_field.dart';
import 'package:capo/modules/wallet/restore/from_private_key/viewmodel/view_model.dart';
import 'package:capo/provider/provider_widget.dart';
import 'package:easy_localization/public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FromPrivateKeyView extends StatefulWidget {
  FromPrivateKeyView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FromPrivateKeyState();
  }
}

class _FromPrivateKeyState extends State<FromPrivateKeyView>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final viewModel = FromPrivateKeyViewModel();
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
    return ProviderWidget<FromPrivateKeyViewModel>(
        model: viewModel,
        builder: (_, viewModel, __) => ListView(
              children: <Widget>[
                TextField(
                  maxLines: 3,
                  cursorColor: Theme.of(context).textTheme.subtitle1.color,
                  keyboardType: TextInputType.text,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .apply(fontSizeDelta: -2),
                  onChanged: (out) => viewModel.privateKeySubject.add(out),
                  decoration: InputDecoration(
                      hintText: tr(
                          "wallet.restore.from_private_key.private_key_hint_text"),
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
                    tr("wallet.restore.from_private_key.btnTitle"),
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

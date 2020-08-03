import 'package:capo/modules/common/dialog/password_field.dart';
import 'package:capo/provider/provider_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../view_model/create_view_model.dart';

@FFRoute(name: "capo://icapo.app/wallet/create")
class CreateWalletPage extends StatelessWidget {
  CreateWalletPage({Key key}) : super(key: key);
  final viewModel = CreateWalletViewModel();

  Widget listView() {
    return ProviderWidget<CreateWalletViewModel>(
      model: viewModel,
      builder: (context, viewModel, __) => ListView(children: [
        SizedBox(
          height: 5,
        ),
        TextField(
          maxLength: 12,
          cursorColor: Theme.of(context).textTheme.subtitle1.color,
          keyboardType: TextInputType.text,
          style: Theme.of(context).textTheme.subtitle1.apply(fontSizeDelta: -2),
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
          onChanged: (value) => viewModel.walletPasswordSubject.add(value),
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
          onChanged: (value) => viewModel.repeatPasswordSubject.add(value),
        ),
        SizedBox(
          height: 30,
        ),
        CupertinoButton(
          color: Color.fromARGB(255, 51, 118, 184),
          padding: EdgeInsets.all(16),
          pressedOpacity: 0.8,
          child: Text(
            tr("wallet.create.button_title"),
            style: Theme.of(context).textTheme.button,
          ),
          onPressed: viewModel.isButtonAvailable
              ? () {
                  viewModel.createBtnTapped(context);
                }
              : null,
        ),
      ]),
    );
  }

  Widget bodyWidget(context) => Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black54,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: listView(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: AppBar(
          title: Text(tr("wallet.create.appBarTitle"),
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
}

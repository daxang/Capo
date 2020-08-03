import 'package:capo/modules/settings/settings_modules/wallet/detail/dialog/view_model/view_model.dart';
import 'package:capo/provider/provider_widget.dart';
import 'package:capo_core_dart/capo_core_dart.dart';
import 'package:easy_localization/public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFieldDialog extends AlertDialog {
  final BasicWallet wallet;
  TextFieldDialog(
    this.wallet, {
    Key key,
  }) : super(key: key);

  @override
  Widget get content => TextFieldWidget(wallet);

  @override
  EdgeInsetsGeometry get contentPadding => EdgeInsets.all(0.0);

  @override
  Color get backgroundColor => Colors.transparent;
}

class TextFieldWidget extends StatelessWidget {
  final BasicWallet wallet;
  TextFieldWidget(this.wallet, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(
          primaryColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black54,
        ),
        child: ProviderWidget<TextFieldDialogViewModel>(
          model: TextFieldDialogViewModel(wallet),
          builder: (_, viewModel, __) {
            return Wrap(
              children: <Widget>[
                Container(
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                            color: Theme.of(context).cardColor, width: 1),
                        color: Theme.of(context).cardColor),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Text(tr(
                              "settings.wallets.detail.text_field_dialog.title")),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                          child: TextField(
                            autofocus: true,
                            controller: viewModel.walletNameEtController,
                            maxLength: 12,
                            cursorColor:
                                Theme.of(context).textTheme.subtitle1.color,
                            keyboardType: TextInputType.text,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .apply(fontSizeDelta: -2),
                            decoration: InputDecoration(
                              labelText: tr("wallet.create.wallet_name"),
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(children: [
                            Expanded(
                              child: CupertinoButton(
                                color: Color.fromARGB(255, 51, 118, 184),
                                padding: EdgeInsets.all(16),
                                pressedOpacity: 0.8,
                                child: Text(
                                  tr("settings.wallets.detail.text_field_dialog.btn_title"),
                                  style: Theme.of(context).textTheme.button,
                                ),
                                onPressed: viewModel.isButtonAvailable
                                    ? () {
                                        viewModel
                                            .tappedModifyWalletName(context);
                                      }
                                    : null,
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ))
              ],
            );
          },
        ));
  }
}

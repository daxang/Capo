import 'package:capo/modules/settings/settings_modules/wallet/detail/view_model/view_model.dart';
import 'package:capo/provider/provider_widget.dart';
import 'package:easy_localization/public.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

@FFRoute(name: "capo://icapo.app/settings/wallets/detail")
class WalletDetailPage extends StatelessWidget {
  final WalletDetailViewModel viewModel = WalletDetailViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: AppBar(
            title: Text(tr("settings.wallets.detail.title"),
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
      ),
      body: ProviderWidget<WalletDetailViewModel>(
        model: viewModel,
        onModelReady: viewModel.getRouteWallet(context),
        builder: (_, viewModel, __) {
          return viewModel.wallet == null
              ? Container()
              : ListView(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  children: <Widget>[
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: ListTile(
                        title: Text(
                            tr("settings.wallets.detail.change_wallet_name")),
                        onTap: () {
                          viewModel.tappedChangeWalletName();
                        },
                        trailing: Text(viewModel.wallet.capoMeta.name),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: viewModel.showExportMnemonic
                            ? BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0))
                            : BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: ListTile(
                        title: Text(
                            tr("settings.wallets.detail.export_private_key")),
                        onTap: () {
                          viewModel.tappedExportPrivateKey(context);
                        },
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16.0,
                        ),
                      ),
                    ),
                    viewModel.showExportMnemonic
                        ? Column(
                            children: <Widget>[
                              Divider(
                                indent: 16,
                                endIndent: 0,
                                height: 1,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(8.0),
                                      bottomLeft: Radius.circular(8.0)),
                                ),
                                child: ListTile(
                                  title: Text(tr(
                                      "settings.wallets.detail.export_mnemonic_phrase")),
                                  onTap: () {
                                    viewModel.tappedExportMnemonic(context);
                                  },
                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16.0,
                                  ),
                                ),
                              )
                            ],
                          )
                        : Container(),
                    Column(
                      children: <Widget>[
                        Divider(
                          indent: 16,
                          endIndent: 0,
                          height: 1,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(8.0),
                                bottomLeft: Radius.circular(8.0)),
                          ),
                          child: ListTile(
                            title: Text(
                                tr("settings.wallets.detail.export_keystore")),
                            onTap: () {
                              viewModel.tappedExportKeystore(context);
                            },
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 16.0,
                            ),
                          ),
                        )
                      ],
                    ),
                    viewModel.showSwitchWallet
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Text(tr(
                                        "settings.wallets.detail.switch_wallet")),
                                    onTap: () {
                                      viewModel.tappedSwitchWallet();
                                    },
                                  )),
                            ],
                          )
//
                        : Container(),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        child: ListTile(
                            onTap: () async {
                              await Clipboard.setData(ClipboardData(
                                  text: viewModel.wallet.address));
                              showToast(tr("settings.wallets.detail.copied"),
                                  position: ToastPosition.bottom);
                            },
                            title: Text(
                                tr("settings.wallets.detail.copy_address")))),
                    Container(
                      padding: EdgeInsets.fromLTRB(16, 6, 6, 16),
                      child: Text(
                        viewModel.wallet.address,
                        style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).textTheme.caption.color),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          showCupertinoDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoAlertDialog(
                              title: Column(
                                children: <Widget>[
                                  Text(tr(
                                      "settings.wallets.detail.delete_alert.title")),
                                  Text(
                                    tr("settings.wallets.detail.delete_alert.content"),
                                    style: TextStyle(fontSize: 15),
                                  )
                                ],
                              ),
                              actions: <Widget>[
                                CupertinoDialogAction(
                                  child: Text(tr(
                                      "settings.wallets.detail.delete_alert.delete_btn_title")),
                                  isDestructiveAction: true,
                                  onPressed: () {
                                    Navigator.pop(context);
                                    viewModel.deleteWallet();
                                  },
                                ),
                                CupertinoDialogAction(
                                  child: Text(tr(
                                      "settings.wallets.detail.delete_alert.cancel_btn_title")),
                                  isDefaultAction: true,
                                  onPressed: () => Navigator.pop(context),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                            height: 46,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                tr("settings.wallets.detail.delete_wallet"),
                                style: TextStyle(color: Colors.red),
                              ),
                            ))),
                  ],
                );
        },
      ),
    );
  }
}

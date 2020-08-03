import 'package:capo/modules/settings/settings_modules/wallet/view/wallet_cell.dart';
import 'package:capo/utils/wallet_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@FFRoute(name: "capo://icapo.app/settings/wallets")
class SettingsWalletsPage extends StatefulWidget {
  @override
  _SettingsWalletsPageState createState() => _SettingsWalletsPageState();
}

class _SettingsWalletsPageState extends State<SettingsWalletsPage> {
  WalletViewModel walletViewModel;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      walletViewModel = Provider.of<WalletViewModel>(context);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(44),
          child: AppBar(
            title: Text(tr("settings.wallets.title"),
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            actions: <Widget>[
              IconButton(
                // action button
                icon: new Icon(
                  Icons.add,
                  size: 32,
                ),
                onPressed: () {
                  Navigator.pushNamed(
                      context, "capo://icapo.app/wallet/guide?showAppBar=true");
                },
              ),
            ],
          ),
        ),
        body: walletViewModel == null || walletViewModel.wallets.length == 0
            ? Container()
            : ListView.builder(
                itemCount: walletViewModel.wallets.length,
                itemBuilder: (_, index) {
                  final wallet = walletViewModel.wallets[index];
                  final bool selected = walletViewModel.currentWallet.address ==
                      walletViewModel.wallets[index].address;
                  return WalletCell(
                    wallet: wallet,
                    selected: selected,
                  );
                }));
  }
}

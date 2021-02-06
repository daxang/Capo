import 'package:capo/dapp_browser/dapp_access_manager/dapp_access_manager.dart';
import 'package:easy_localization/public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class DAppSettings extends StatelessWidget {
  DAppSettings({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: AppBar(
          title: Text(tr("settings.dApp_settings.title"),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              leading: Text(
                tr("settings.dApp_settings.clear_DApp_allowance"),
                style: TextStyle(fontSize: 16),
              ),
              onTap: () {
                showCupertinoDialog(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    title: Column(
                      children: <Widget>[
                        Text(tr("settings.dApp_settings.clear_DApp_allowance")),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          tr("settings.dApp_settings.clear_alert_context"),
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        child: Text(
                            tr("settings.dApp_settings.clear_alert_cancel")),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoDialogAction(
                        child: Text(
                            tr("settings.dApp_settings.clear_alert_confirm")),
                        isDefaultAction: true,
                        onPressed: () async {
                          Navigator.pop(context);
                          await DAppAccessManager.getSharedInstance()
                              .clearAllowance();
                          SmartDialog.showToast(
                              tr("settings.dApp_settings.clear_alert_success"),
                              alignment: Alignment.center);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

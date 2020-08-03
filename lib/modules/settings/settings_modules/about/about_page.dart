import 'dart:io';

import 'package:capo/modules/settings/settings_modules/about/view_model/about_view_model.dart';
import 'package:capo/provider/provider_widget.dart';
import 'package:capo/utils/capo_utils.dart';
import 'package:capo/utils/dialog/capo_dialog_utils.dart';
import 'package:easy_localization/public.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:oktoast/oktoast.dart';
import 'package:url_launcher/url_launcher.dart';

@FFRoute(name: "capo://icapo.app/settings/about")
class CapoAboutPage extends StatelessWidget {
  CapoAboutPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: AppBar(
          title: Text(tr("settings.about_page.title"),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ),
      ),
      body: SafeArea(
        child: ProviderWidget<AboutViewModel>(
          model: AboutViewModel(),
          onModelReady: (model) {
            model.getVersionNumber();
          },
          builder: (_, viewModel, __) {
            return ListView(
              padding: EdgeInsets.fromLTRB(0, 18, 0, 0),
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "resources/images/app_icon/capo_icon.png",
                      fit: BoxFit.cover,
                      height: 50.0,
                      width: 50.0,
                    ),
                    Container(
//                      color: Colors.red,
                      width: 80,
                      child: ListTile(
                        title: FittedBox(
                          child: Text(
                            "Capo",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        subtitle: Text(
                          viewModel.version != null ? viewModel.version : "",
                          style: Theme.of(context).textTheme.subtitle2.apply(
                              color: Theme.of(context).textTheme.caption.color),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  color: Theme.of(context).cardColor,
                  child: ListTile(
                    onTap: () {
                      Navigator.pushNamed(context,
                          "capo://icapo.app/settings/about/privacy_security");
                    },
                    title:
                        Text(tr("settings.about_page.terms_and_privacy.title")),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 1,
                ),
                Container(
                  color: Theme.of(context).cardColor,
                  child: ListTile(
                    onTap: () async {
                      if (Platform.isIOS) {
                        _iosCheckUpdate();
                      } else if (Platform.isAndroid) {
                        _androidCheckUpdate(context);
                      }
                    },
                    title: Text(tr("settings.about_page.version_update")),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16.0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  color: Theme.of(context).cardColor,
                  child: ListTile(
                    title: Text(tr("settings.about_page.website")),
                    trailing: Text(
                      "https://icapo.app",
                      style: TextStyle(color: HexColor.mainColor),
                    ),
                    onTap: () async {
                      _showBottomSheet(context, 'https://icapo.app');
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  _iosCheckUpdate() async {
    const url = 'itms-beta://testflight.apple.com/k5HpQbcV';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showToast('Could not launch $url');
    }
  }

  _androidCheckUpdate(BuildContext context) async {
    CapoDialogUtils.showProcessIndicator(context: context);
    FlutterXUpdate.setUpdateHandler(
        onUpdateError: (Map<String, dynamic> message) async {
      showToast(message["message"], dismissOtherToast: true);
    });
    UpdateEntity entity = await fetchUpdateEntity().catchError((error) {
      showToast(error.toString());
      Navigator.pop(context);
    });
    if (entity != null) {
      Navigator.pop(context);
      FlutterXUpdate.updateByInfo(updateEntity: entity);
    }
  }

  _showBottomSheet(BuildContext context, String copyContent) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Stack(children: <Widget>[
          Container(
            height: 150 + MediaQuery.of(context).padding.bottom,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
          ),
          Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Container(
                color: Theme.of(context).cardColor,
                height: 50,
                width: double.infinity,
                child: Center(
                    child: Text(
                  copyContent,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.caption,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                )),
              ),
            ),
            Container(
              color: Theme.of(context).highlightColor,
              height: 1,
            ),
            Container(
              color: Theme.of(context).cardColor,
              height: 50,
              width: double.infinity,
              child: CupertinoButton(
                padding: EdgeInsets.all(0),
                child: Text(
                  tr("transaction_detail.copy_btn_title"),
                  style: TextStyle(
                      color: HexColor.mainColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                onPressed: () async {
                  final data = ClipboardData(text: copyContent);
                  await Clipboard.setData(data);
                  showToast(tr("transaction_detail.copy_hint"));
                  Navigator.pop(context);
                },
              ),
            ),
            Container(
              color: Theme.of(context).highlightColor,
              height: 1,
            ),
            Container(
              color: Theme.of(context).cardColor,
              height: 50,
              width: double.infinity,
              child: CupertinoButton(
                padding: EdgeInsets.all(0),
                child: Text(
                  tr("settings.about_page.open"),
                  style: TextStyle(
                      color: HexColor.mainColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  if (await canLaunch(copyContent)) {
                    await launch(copyContent);
                  } else {
                    showToast('Could not launch $copyContent');
                  }
                },
              ),
            ),
//            Divider(),
          ])
        ]);
      },
    );
  }
}

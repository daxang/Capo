import 'package:capo/utils/capo_utils.dart';
import 'package:easy_localization/public.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:oktoast/oktoast.dart';
import 'package:url_launcher/url_launcher.dart';

@FFRoute(name: "capo://icapo.app/settings/about/privacy_security")
class PrivacySecurityPage extends StatelessWidget {
  PrivacySecurityPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: AppBar(
          title: Text(tr("settings.about_page.terms_and_privacy.title"),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              MarkdownBody(
                data: tr("settings.about_page.terms_and_privacy.terms"),
                onTapLink: (href) {
                  if (href.startsWith(RegExp(r'https?:'))) {
                    _showBottomSheet(context, href);
                    return;
                  } else if (href.startsWith("capo://icapo.app/")) {
                    String routeUrl = href +
                        "?revAddress=11112mmfnqD3UgtpEAmFxVfU6g26W7fdyFgS6dNUpk9ycS2GXYU3pL&donate=true";
                    Navigator.pushNamed(context, routeUrl);
                  }
                },
              ),
            ],
          )),
    );
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
                  _launchURL(copyContent);
                },
              ),
            ),
//            Divider(),
          ])
        ]);
      },
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showToast('Could not launch $url');
    }
  }
}

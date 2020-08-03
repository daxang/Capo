import 'package:easy_localization/public.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter/material.dart';

@FFRoute(name: "capo://icapo.app/settings/node_settings")
class NodeSettings extends StatelessWidget {
  NodeSettings({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: AppBar(
          title: Text(tr("settings.note_settings.title"),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ),
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              leading: Text(
                tr("settings.note_settings.readonly_node"),
                style: TextStyle(fontSize: 16),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
              onTap: () {
                Navigator.pushNamed(context,
                    "capo://icapo.app/settings/node_settings/readonly");
              },
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            color: Theme.of(context).cardColor,
            child: ListTile(
              onTap: () {
                Navigator.pushNamed(context,
                    "capo://icapo.app/settings/node_settings/validator");
              },
              leading: Text(
                tr("settings.note_settings.validator_node"),
                style: TextStyle(fontSize: 16),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
            ),
          )
        ],
      ),
    );
  }
}

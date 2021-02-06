import 'package:capo/modules/common/dialog/capo_textfield_dialog.dart';
import 'package:capo/modules/settings/settings_modules/node_settings/view/readonly/view_model/readonly_view_model.dart';
import 'package:capo/provider/provider_widget.dart';
import 'package:capo/utils/capo_utils.dart';
import 'package:easy_localization/public.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_section_table_view/flutter_section_table_view.dart';

@FFRoute(name: "capo://icapo.app/settings/node_settings/readonly")
class NodeSettingReadonlyPage extends StatelessWidget {
  NodeSettingReadonlyPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: AppBar(
          title: Text(tr("settings.node_settings.readonly_page.title"),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ),
      ),
      body: SafeArea(
        child: ProviderWidget<ReadonlyViewModel>(
          model: ReadonlyViewModel(),
          onModelReady: (model) => model.loadJson(context),
          builder: (_, viewModel, __) {
            return viewModel.tableViewSections == null
                ? Container()
                : Stack(
                    children: [
                      Container(
                        height: double.infinity,
                      ),
                      Stack(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height - 200),
                            child: SectionTableView(
                              divider: SizedBox(
                                height: 1,
                              ),
                              sectionCount: viewModel.tableViewSections.sections
                                          .last.length >
                                      0
                                  ? 2
                                  : 1,
                              numOfRowInSection: (section) {
                                return viewModel
                                    .tableViewSections.sections[section].length;
                              },
                              cellAtIndexPath: (section, row) {
                                return Dismissible(
                                  key: Key(viewModel.tableViewSections
                                      .sections[section][row].url),
                                  background: Container(
                                    color: section == 0
                                        ? Colors.transparent
                                        : Colors.redAccent,
                                  ),
                                  onDismissed: (_) {
                                    viewModel.deleteNode(section, row);
                                  },
                                  confirmDismiss: (direction) async {
                                    if (section == 0) {
                                      return false;
                                    }
                                    var isDismiss =
                                        await _showDeleteAlertDialog(
                                            context,
                                            viewModel.tableViewSections
                                                .sections[section][row].url);
                                    return isDismiss;
                                  },
                                  child: Container(
                                    color: Theme.of(context).cardColor,
                                    child: ListTile(
                                      onTap: () {
                                        viewModel.cellTapped(
                                            section: section, row: row);
                                      },
                                      title: ConstrainedBox(
                                        constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                200),
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            viewModel
                                                    .tableViewSections
                                                    .sections[section][row]
                                                    .url ??
                                                "",
                                            maxLines: 1,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ),
                                      trailing: viewModel.tableViewSections
                                                  .selectedNode ==
                                              viewModel.tableViewSections
                                                  .sections[section][row].url
                                          ? Container(
                                              width: 20.0,
                                              height: 20.0,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255)),
                                              child: Icon(
                                                Icons.check_circle,
                                                size: 20,
                                                color: Color.fromARGB(
                                                    255, 51, 118, 184),
                                              ),
                                            )
                                          : SizedBox(
                                              width: 20,
                                              height: 20,
                                            ),
                                    ),
                                  ),
                                );
                              },
                              headerInSection: (section) {
                                return Container(
                                    height: 50.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(section == 0
                                          ? tr(
                                              "settings.node_settings.readonly_page.official")
                                          : tr(
                                              "settings.node_settings.readonly_page.custom")),
                                    ));
                              },
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 50,
                          child: Container(
                            color: Theme.of(context).cardColor,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Divider(
                                  height: 2,
                                ),
                                Center(
                                  child: FlatButton(
                                    child: Text(
                                      tr("settings.node_settings.readonly_page.add_custom_node"),
                                      style:
                                          TextStyle(color: HexColor.mainColor),
                                    ),
                                    onPressed: () {
                                      _showBottomSheet(viewModel, context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  );
          },
        ),
      ),
    );
  }

  Future<bool> _showDeleteAlertDialog(BuildContext context, String nodeUrl) {
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Column(
          children: <Widget>[
            Text(tr("settings.node_settings.readonly_page.delete_node")),
            SizedBox(
              height: 10,
            ),
            Text(
              nodeUrl,
              style: TextStyle(fontSize: 15),
            )
          ],
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(
                tr("settings.wallets.detail.delete_alert.delete_btn_title")),
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          CupertinoDialogAction(
            child: Text(
                tr("settings.wallets.detail.delete_alert.cancel_btn_title")),
            isDefaultAction: true,
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );
  }

  _showBottomSheet(ReadonlyViewModel viewModel, BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            height: 330,
            child: Stack(children: <Widget>[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 40,
                    width: double.infinity,
                    child: Center(
                        child: Text(
                      tr("settings.node_settings.readonly_page.add_custom_node"),
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    )),
                  ),
                  Divider(),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Icon(
                      Icons.warning,
                      size: 70,
                      color: Colors.yellow,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        tr("settings.node_settings.readonly_page.warning"),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                  bottom: 25,
                  left: 16,
                  right: 16,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: CupertinoButton(
                              padding: EdgeInsets.all(16),
                              pressedOpacity: 0.8,
                              color: Color.fromARGB(255, 51, 118, 184),
                              child: Text(
                                tr("settings.node_settings.readonly_page.understood"),
                                style: Theme.of(context).textTheme.button,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                showTextFieldDialog(viewModel, context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ]),
          );
        });
  }

  showTextFieldDialog(ReadonlyViewModel viewModel, BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return CapoTextFieldDialog(
            topTitle:
                tr("settings.node_settings.readonly_page.text_dialog.title"),
            labelText: tr(
                "settings.node_settings.readonly_page.text_dialog.label_text"),
            hint: "https://icapo.app",
            inputCallback: (text) {
              viewModel.addCustomNode(text);
            },
          );
        });
  }
}

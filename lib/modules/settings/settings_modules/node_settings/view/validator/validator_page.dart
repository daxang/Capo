import 'package:capo/modules/common/dialog/capo_textfield_dialog.dart';
import 'package:capo/modules/settings/settings_modules/node_settings/view/validator/view_model/validator_view_model.dart';
import 'package:capo/provider/provider_widget.dart';
import 'package:easy_localization/public.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_section_table_view/flutter_section_table_view.dart';

@FFRoute(name: "capo://icapo.app/settings/node_settings/validator")
class NodeSettingValidatorPage extends StatelessWidget {
  NodeSettingValidatorPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: AppBar(
          title: Text(tr("settings.note_settings.validator_page.title"),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ),
      ),
      body: SafeArea(
        child: ProviderWidget<ValidatorViewModel>(
          model: ValidatorViewModel(),
          onModelReady: (model) => model.loadJson(context),
          builder: (_, viewModel, __) {
            return viewModel.nodeModel == null
                ? Container()
                : Stack(
                    children: [
                      Container(
                        height: double.infinity,
                      ),
                      SectionTableView(
                        divider: SizedBox(
                          height: 1,
                        ),
                        sectionCount: 2,
                        numOfRowInSection: (section) {
                          if (section == 0) {
                            return 1;
                          }
                          return viewModel.nodeModel.validators.length;
                        },
                        cellAtIndexPath: (section, row) {
                          if (section == 0) {
                            return Container(
                              color: Theme.of(context).cardColor,
                              child: ListTile(
                                title: Text(tr(
                                    "settings.note_settings.validator_page.auto_selected")),
                                onTap: () {
                                  viewModel.cellTapped(
                                      section: section, row: row);
                                },
                                trailing: viewModel.nodeModel.autoSelected ==
                                        true
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
                                          color:
                                              Color.fromARGB(255, 51, 118, 184),
                                        ),
                                      )
                                    : SizedBox(
                                        width: 20,
                                        height: 20,
                                      ),
                              ),
                            );
                          }
                          return Container(
                            color: Theme.of(context).cardColor,
                            child: ListTile(
                              onTap: () {
                                viewModel.cellTapped(
                                    section: section, row: row);
                              },
                              title: ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width -
                                            200),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    viewModel.nodeModel.validators[row].host,
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              trailing: ((viewModel.nodeModel.selectedNode !=
                                                  null
                                              ? viewModel
                                                  .nodeModel.selectedNode.host
                                              : "") ==
                                          viewModel.nodeModel.validators[row]
                                              .host) &&
                                      (viewModel.nodeModel.autoSelected ==
                                          false)
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
                                        color:
                                            Color.fromARGB(255, 51, 118, 184),
                                      ),
                                    )
                                  : SizedBox(
                                      width: 20,
                                      height: 20,
                                    ),
                            ),
                          );
                        },
//                        headerInSection: (section) {
//                          return Container(
//                              height: 50.0,
//                              child: Padding(
//                                padding: const EdgeInsets.all(16.0),
//                                child: Text(section == 0
//                                    ? tr(
//                                        "settings.note_settings.validator_page.official")
//                                    : tr(
//                                        "settings.note_settings.validator_page.custom")),
//                              ));
//                        },
                      )
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
            Text(tr("settings.note_settings.validator_page.delete_node")),
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

  _showBottomSheet(ValidatorViewModel viewModel, BuildContext context) {
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
                      tr("settings.note_settings.validator_page.add_custom_node"),
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
                        tr("settings.note_settings.validator_page.warning"),
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
                                tr("settings.note_settings.validator_page.understood"),
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

  showTextFieldDialog(ValidatorViewModel viewModel, BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return CapoTextFieldDialog(
            topTitle:
                tr("settings.note_settings.validator_page.text_dialog.title"),
            labelText: tr(
                "settings.note_settings.validator_page.text_dialog.label_text"),
            hint: "icapo.app:40401",
            inputCallback: (text) {
              viewModel.addCustomNode(text);
            },
          );
        });
  }
}

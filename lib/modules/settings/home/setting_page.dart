import 'package:capo/modules/settings/home/view/cell.dart';
import 'package:capo/modules/settings/home/view_model/view_model.dart';
import 'package:capo/provider/provider_widget.dart';
import 'package:easy_localization/public.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_section_table_view/flutter_section_table_view.dart';

@FFRoute(name: "capo://icapo.app/settings")
class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(44),
          child: AppBar(
            title: Text(tr("settings.title"),
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ),
        ),
        body: SafeArea(
          child: ProviderWidget<SettingsViewModel>(
              model: SettingsViewModel(),
              onModelReady: (model) => model.loadJson(context),
              builder: (_, viewModel, __) {
                if (viewModel.tableViewModel == null) {
                  return Container();
                }
                return SectionTableView(
                  sectionCount: viewModel.tableViewModel.sections.length,
                  numOfRowInSection: (section) {
                    return viewModel.tableViewModel.sections[section].length;
                  },
                  cellAtIndexPath: (section, row) {
                    return SettingsCell(
                      cellModel: viewModel.tableViewModel.sections[section]
                          [row],
                    );
                  },
                  headerInSection: (section) {
                    return Container(
                      height: 10.0,
                      color: Colors.transparent,
                    );
                  },
                );
              }),
        ));
  }
}

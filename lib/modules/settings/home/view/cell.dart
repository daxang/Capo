import 'package:capo/modules/settings/home/model/model.dart';
import 'package:capo/utils/capo_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SettingsCell extends StatelessWidget {
  final SettingsCellModel cellModel;
  SettingsCell({Key key, @required this.cellModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, cellModel.url);
      },
      child: Container(
        height: 46,
        color: Theme.of(context).cardColor,
//        decoration: BoxDecoration(
//          color: Theme.of(context).cardColor,
//          borderRadius: BorderRadius.all(
//            Radius.circular(8.0),
//          ),
//        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          IconData(hexToInt(cellModel.icon),
                              fontFamily: cellModel.iconFontFamily),
                          color: Theme.of(context).textTheme.caption.color,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(tr(cellModel.context)),
//                  Icon(Icons.lightbulb_outline),
                      ],
                    ),
                    cellModel.arrow
                        ? Row(
                            children: <Widget>[
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16.0,
                              ),
                              SizedBox(
                                width: 16,
                              )
                            ],
                          )
                        : Container(),
                  ],
                ),
                cellModel.divideLine
                    ? Row(
                        children: <Widget>[
                          SizedBox(
                            width: 35,
                          ),
                          Expanded(
                            child: Container(
                              height: 0.5,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      )
                    : Container()
              ]),
        ),
      ),
    );
  }
}

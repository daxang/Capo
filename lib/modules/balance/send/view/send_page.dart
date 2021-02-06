import 'dart:io';

import 'package:capo/modules/balance/send/view_model/send_view_model.dart';
import 'package:capo/provider/provider_widget.dart';
import 'package:capo/utils/capo_utils.dart';
import 'package:capo/utils/dialog/capo_dialog_utils.dart';
import 'package:easy_localization/public.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:r_scan/r_scan.dart';

@FFRoute(name: "capo://icapo.app/balance/send")
class SendPage extends StatelessWidget {
  final _sendViewModel = SendViewModel();

  Future<bool> canReadStorage() async {
    if (Platform.isIOS) return true;
    var status = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (status != PermissionStatus.granted) {
      var future = await PermissionHandler()
          .requestPermissions([PermissionGroup.storage]);
      for (final item in future.entries) {
        if (item.value != PermissionStatus.granted) {
          return false;
        }
      }
    } else {
      return true;
    }
    return true;
  }

  Future<bool> canOpenCamera() async {
    var status =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
    if (status != PermissionStatus.granted) {
      var future = await PermissionHandler()
          .requestPermissions([PermissionGroup.camera]);
      for (final item in future.entries) {
        if (item.value != PermissionStatus.granted) {
          return false;
        }
      }
    } else {
      return true;
    }
    return true;
  }

  _add(BuildContext context) async {
    await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(
            10.0, MediaQuery.of(context).padding.top + 60, 0, 10.0),
        items: <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
              value: 'Photo',
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(
                    Icons.photo,
                    size: 20,
                  ),
                  Text(
                    tr('sendPage.photo'),
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )),
          PopupMenuDivider(height: 2.0),
          PopupMenuItem<String>(
              value: 'Scan',
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Icon(
                    IconData(0xeb1f, fontFamily: 'iconfont'),
                    size: 16,
                  ),
                  Text(
                    tr('sendPage.scan'),
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              )),
        ]).then((value) async {
      if (value == "Photo") {
        if (await canReadStorage()) {
          var file = await ImagePicker.pickImage(source: ImageSource.gallery);
          if (file == null) {
            return;
          }
          CapoDialogUtils.showProcessIndicator(context: context);
          Future.delayed(Duration(milliseconds: 700), () async {
            final result = await RScan.scanImagePath(file.path);
            Navigator.pop(context);
            if (result == null) {
              SmartDialog.showToast(tr("appError.nothingScanned"));
              return;
            }
            if (result != null && result.message.length > 0) {
              _sendViewModel.decodeQrCode(result.message);
            }
          });
        }
      } else if (value == "Scan") {
        Future.delayed(Duration(milliseconds: 200), () async {
          if (await canOpenCamera()) {
            _sendViewModel.scan();
          }
        });
      }
    });
    return;
  }

  SendPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: AppBar(
          title: Text(tr('sendPage.title'),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add_circle_outline,
              ),
              onPressed: () {
                _add(context);
              },
            )
          ],
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onPanDown: (_) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ProviderWidget<SendViewModel>(
            model: _sendViewModel,
            onModelReady: (model) {
              model.getRevBalance(context);
            },
            builder: (context, viewModel, __) => Theme(
              data: Theme.of(context).copyWith(
                primaryColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black54,
              ),
              child: ListView(children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    boxShadow: [
                      new BoxShadow(
                        color: Colors.black12,
                        offset: new Offset(0.0, 1.0),
                        blurRadius: 2.0,
                      )
                    ],

                    color: Theme.of(context).cardColor,
                    borderRadius: new BorderRadius.circular((10.0)), // 圆角度
                  ),
                  child: Column(
                    children: <Widget>[
                      TextField(
                        cursorColor:
                            Theme.of(context).textTheme.subtitle1.color,
                        maxLines: viewModel.transferAddress.length > 0 ? 2 : 1,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            fontSize:
                                viewModel.transferAddress.length > 0 ? 12 : 18),
                        controller: viewModel.addressEditController,
                        enabled: !viewModel.fromDonate,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: tr("sendPage.to_hint"),
                            labelStyle: TextStyle(fontSize: 18),
                            suffixIcon: CupertinoButton(
                              onPressed: () async {
                                await Future.delayed(Duration(milliseconds: 50))
                                    .then((_) async {
                                  ClipboardData r =
                                      await Clipboard.getData('text/plain');

                                  if (r != null &&
                                      r.text != null &&
                                      r.text.length > 0) {
                                    viewModel.addressEditController.text =
                                        r.text;
                                  }
                                });
                              },
                              padding: EdgeInsets.all(0),
                              child: Text(
                                tr("sendPage.paste"),
                                style: TextStyle(
                                    color: HexColor.mainColor, fontSize: 14),
                              ),
                            )),
                      ),
                      Divider(
                        height: 5,
                      ),
                      TextField(
                        controller: viewModel.transferAmountEditController,
                        cursorColor:
                            Theme.of(context).textTheme.subtitle1.color,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: tr("sendPage.amount_hint"),
                            labelStyle: TextStyle(fontSize: 18),
                            suffixIcon: CupertinoButton(
                              onPressed: () async {
                                await Future.delayed(Duration(milliseconds: 50))
                                    .then((_) {
                                  viewModel.transferAmountEditController.text =
                                      viewModel.maxTransferAmount;
                                });
                              },
                              padding: EdgeInsets.all(0),
                              child: Text(
                                tr("sendPage.max"),
                                style: TextStyle(
                                    color: HexColor.mainColor, fontSize: 14),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(tr("sendPage.balance",
                        args: [capoNumberFormat(viewModel.selfRevBalance)])),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                CupertinoButton(
                  color: Color.fromARGB(255, 51, 118, 184),
                  padding: EdgeInsets.all(16),
                  pressedOpacity: 0.8,
                  child: Text(
                    tr("sendPage.btn_title"),
                    style: Theme.of(context).textTheme.button,
                  ),
                  onPressed:
                      viewModel.btnEnable ? viewModel.tappedSendBtn : null,
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

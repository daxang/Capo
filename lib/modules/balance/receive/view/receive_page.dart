import 'package:capo/modules/balance/receive/view/set_amount_textfield_dialog.dart';
import 'package:capo/modules/balance/receive/view_model/receive_view_model.dart';
import 'package:capo/provider/provider_widget.dart';
import 'package:capo/utils/capo_utils.dart';
import 'package:easy_localization/public.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:qr_flutter/qr_flutter.dart';

@FFRoute(name: "capo://icapo.app/balance/receive")
class ReceivePage extends StatelessWidget {
  ReceivePage({Key key}) : super(key: key);
  final GlobalKey globalKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: AppBar(
          title: Text(tr('receivePage.title'),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ),
      ),
      body: ProviderWidget<ReceiveViewModel>(
        model: ReceiveViewModel(),
        onModelReady: (model) {
          model.getRevAddress(context);
        },
        builder: (context, viewModel, child) {
          return Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(16),
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
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Capo Wallet",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: HexColor.mainColor),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      RepaintBoundary(
                        key: globalKey,
                        child: viewModel.qrCodeString == null
                            ? Container()
                            : QrImage(
                                backgroundColor: Colors.white,
                                data: viewModel.qrCodeString,
                                size: MediaQuery.of(context).size.width * 2 / 3,
                              ),
                      ),
                      viewModel.revAddress == null
                          ? Container()
                          : Container(
                              padding: EdgeInsets.fromLTRB(4, 8, 4, 5),
                              width: MediaQuery.of(context).size.width * 2 / 3,
                              child: Text(
                                viewModel.revAddress,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
                                    fontSize: 14),
                              ),
                            )
                    ],
                  ),
                ),
                Container(
                  height: viewModel.isShowAmountText ? 0 : 30,
                ),
                viewModel.isShowAmountText
                    ? Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: Text(
                          capoNumberFormat(viewModel.receiveAmount) + " REV",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 18),
                        ))
                    : Container(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        RaisedButton(
                          padding: EdgeInsets.all(12),
                          onPressed: () async {
                            final data =
                                ClipboardData(text: viewModel.revAddress);
                            await Clipboard.setData(data);
                            SmartDialog.showToast(tr("copy"),
                                alignment: Alignment.topCenter);
                          },
                          color: HexColor.mainColor,
                          child: Icon(
                            Icons.content_copy,
                            size: 30,
                            color: Colors.white,
                          ),
                          //shape:new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)) ,
                          shape: new CircleBorder(),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          tr('receivePage.copy'),
                          style: TextStyle(
                              color: HexColor.mainColor,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        RaisedButton(
                          padding: EdgeInsets.all(12),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) {
                                  return AmountTextFieldDialog(
                                    inputCallback: (amount) {
                                      viewModel.setAmount(amount);
                                    },
                                  );
                                });
                          },
                          color: Color.fromARGB(255, 229, 237, 244),
                          child: Icon(
                            Icons.attach_money,
                            size: 30,
                            color: HexColor.mainColor,
                          ),
                          //shape:new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)) ,
                          shape: new CircleBorder(),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          tr('receivePage.set_amount'),
                          style: TextStyle(
                              color: HexColor.mainColor,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

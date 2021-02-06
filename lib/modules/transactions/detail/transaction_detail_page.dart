import 'package:capo/modules/transactions/model/transfer_state_info.dart';
import 'package:capo/utils/capo_utils.dart';
import 'package:capo/utils/wallet_view_model.dart';
import 'package:easy_localization/public.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intl/intl.dart';

@FFRoute(name: "capo://icapo.app/transactions/detail")
class TransactionDetail extends StatefulWidget {
  TransactionDetail({Key key}) : super(key: key);

  @override
  _TransactionDetailState createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  String getTransferState(Transaction transaction) {
    if (transaction.fromAddr == WalletViewModel.shared.currentWallet.address) {
      if (transaction.isSucceeded) {
        return tr("transaction_detail.transfer_success");
      } else {
        return tr("transaction_detail.transfer_failed");
      }
    } else {
      if (transaction.isSucceeded) {
        return tr("transaction_detail.receive_success");
      } else {
        return tr("transaction_detail.receive_failed");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Map map = ModalRoute.of(context).settings.arguments;
    Transaction transaction = map["transaction"];
    bool isSend =
        transaction.fromAddr == WalletViewModel.shared.currentWallet.address;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: AppBar(
          title: Text(
              isSend
                  ? tr("transaction_detail.send_title")
                  : tr("transaction_detail.receive_title"),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
        children: <Widget>[
          ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Stack(alignment: const Alignment(0, 0), children: [
                  Container(
                    height: 34,
                    width: 34,
                    decoration: new BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(17)),
                      border: new Border.all(
                          width: 2,
                          color: transaction.isSucceeded
                              ? Colors.green
                              : Colors.red),
                    ),
                  ),
                  Icon(isSend ? Icons.call_made : Icons.call_received),
                ]),
                SizedBox(
                  height: 8,
                ),
                Text(
                  getTransferState(transaction),
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                SizedBox(
                  height: (!transaction.isSucceeded) ? 8 : 0,
                ),
                !transaction.isSucceeded
                    ? FittedBox(
                        child: Text(
                          transaction.reason,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          Divider(
            height: 2,
          ),
          ListTile(
            onTap: () {
              showBottomSheet(context, getAmount(transaction));
            },
            title: Text(
              tr("transaction_detail.amount"),
            ),
            subtitle: Text(
              getAmount(transaction),
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          Divider(
            height: 2,
          ),
          ListTile(
            onTap: () {
              showBottomSheet(context, getTime(transaction));
            },
            title: Text(
              tr("transaction_detail.transaction_time"),
            ),
            subtitle: Text(
              getTime(transaction),
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          Divider(
            height: 2,
          ),
//          ListTile(
//            onTap: () {
//              showBottomSheet(context, getFee(transaction));
//            },
//            title: Text(
//              tr("transaction_detail.transaction_fee"),
//            ),
//            subtitle: Text(
//              getFee(transaction),
//              style: Theme.of(context).textTheme.caption,
//            ),
//          ),

          ListTile(
            onTap: () {
              showBottomSheet(context, transaction.toAddr);
            },
            title: Text(
              tr("transaction_detail.receive_address"),
            ),
            subtitle: Text(
              transaction.toAddr,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          Divider(
            height: 2,
          ),
          ListTile(
            onTap: () {
              showBottomSheet(context, transaction.fromAddr);
            },
            title: Text(
              tr("transaction_detail.send_address"),
            ),
            subtitle: Text(
              transaction.fromAddr,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          Divider(
            height: 2,
          ),
          ListTile(
            onTap: () {
              showBottomSheet(context, transaction.deployId);
            },
            title: Text(
              "DeployID:",
            ),
            subtitle: Text(
              transaction.deployId,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ],
      ),
    );
  }

  String getAmount(Transaction transaction) {
    if (transaction.amount > 0) {
      String amount = capoNumberFormat(transaction.amount / 10e7);
      return amount + " REV";
    }
    return null;
  }

  /*String getFee(Transaction transaction) {
    if (transaction. != null && transaction.cost != 0) {
      String fee = capoNumberFormat(transaction.deploy.cost / 10e7);
      return fee + " REV";
    }
    return null;
  }
*/
  String getTime(Transaction transaction) {
    var date = DateTime.fromMillisecondsSinceEpoch(transaction.timestamp);
    date.toLocal();
    var formatter = DateFormat('yyyy/MM/dd HH:mm:ss');
    String dateString = formatter.format(date);
    return dateString;
  }

  showBottomSheet(BuildContext context, String copyContent) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Stack(children: <Widget>[
          Container(
            height: 100 + MediaQuery.of(context).padding.bottom,
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
                height: 55,
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
                  SmartDialog.showToast(tr("transaction_detail.copy_hint"));
                  Navigator.pop(context);
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

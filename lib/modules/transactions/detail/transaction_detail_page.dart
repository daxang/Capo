import 'package:capo/modules/balance/send/model/send_history_model.dart';
import 'package:capo/utils/capo_utils.dart';
import 'package:easy_localization/public.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rxbus/rxbus.dart';

@FFRoute(name: "capo://icapo.app/transactions/detail")
class TransactionDetail extends StatefulWidget {
  TransactionDetail({Key key}) : super(key: key);

  @override
  _TransactionDetailState createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  @override
  void initState() {
    super.initState();

    RxBus.register<String>(tag: "TransactionStatusChanged")
        .listen((event) => setState(() {
              setState(() {});
            }));
  }

  @override
  void dispose() {
    RxBus.destroy(tag: "TransactionStatusChanged");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map map = ModalRoute.of(context).settings.arguments;
    TransactionHistory transaction = map["transaction"];
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: AppBar(
          title: Text(
              transaction.type == TransactionType.send
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
                  transaction.status == TransactionStatus.pending
                      ? SizedBox(
                          width: 34,
                          height: 34,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                HexColor.mainColor),
                          ),
                        )
                      : Container(
                          height: 34,
                          width: 34,
                          decoration: new BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(17)),
                            border: new Border.all(
                                width: 2,
                                color: getIndicatorColor(transaction)),
                          ),
                        ),
                  Icon(transaction.type == TransactionType.send
                      ? Icons.call_made
                      : Icons.call_received),
                ]),
                SizedBox(
                  height: 8,
                ),
                Text(
                  getStatusDesc(transaction),
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                SizedBox(
                  height: (transaction.status == TransactionStatus.failed ||
                          transaction.status == TransactionStatus.unknown)
                      ? 8
                      : 0,
                ),
                transaction.status == TransactionStatus.failed ||
                        transaction.status == TransactionStatus.unknown
                    ? FittedBox(
                        child: Text(
                          transaction.failedDesc,
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
          transaction.minerFee == null
              ? Container()
              : Divider(
                  height: 2,
                ),
          transaction.minerFee == null
              ? Container()
              : ListTile(
                  onTap: () {
                    showBottomSheet(context, getFee(transaction) + " REV");
                  },
                  title: Text(
                    tr("transaction_detail.transaction_fee"),
                  ),
                  subtitle: Text(
                    getFee(transaction) + " REV",
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
          Divider(
            height: 2,
          ),
          ListTile(
            onTap: () {
              showBottomSheet(context, transaction.to);
            },
            title: Text(
              tr("transaction_detail.receive_address"),
            ),
            subtitle: Text(
              transaction.to,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          Divider(
            height: 2,
          ),
          ListTile(
            onTap: () {
              showBottomSheet(context, transaction.from);
            },
            title: Text(
              tr("transaction_detail.send_address"),
            ),
            subtitle: Text(
              transaction.from,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          transaction.blockHash == null
              ? Container()
              : Divider(
                  height: 2,
                ),
          transaction.blockHash == null
              ? Container()
              : ListTile(
                  onTap: () {
                    showBottomSheet(context, transaction.blockHash);
                  },
                  title: Text(
                    "BlockHash:",
                  ),
                  subtitle: Text(
                    transaction.blockHash,
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

  String getStatusDesc(TransactionHistory transaction) {
    if (transaction.status == TransactionStatus.pending) {
      return tr("transaction_detail.pending");
    } else if (transaction.status == TransactionStatus.success) {
      return tr("transaction_detail.success");
    } else if (transaction.status == TransactionStatus.failed) {
      return tr("transaction_detail.failed");
    }
    return "";
  }

  Color getIndicatorColor(TransactionHistory transaction) {
    Color color = transaction.status == TransactionStatus.failed
        ? Colors.red
        : Colors.green;
    if (transaction.type == TransactionType.receive) {
      color = Colors.green;
    }
    if (transaction.status == TransactionStatus.unknown) {
      color = Colors.yellow;
    }
    return color;
  }

  String getAmount(TransactionHistory transaction) {
    return capoNumberFormat(transaction.amount) + " REV";
  }

  String getFee(TransactionHistory transaction) {
    if (transaction.minerFee != null) {
      String fee = capoNumberFormat(transaction.minerFee);
      return fee;
    }
    return null;
  }

  String getTime(TransactionHistory transaction) {
    int timestamp = int.parse(transaction.timestamp);
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    date.toLocal();
    var formatter = new DateFormat('yyyy/MM/dd HH:mm:ss');
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
                  showToast(tr("transaction_detail.copy_hint"));
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

import 'package:capo/modules/transactions/model/transfer_state_info.dart';
import 'package:capo/utils/capo_utils.dart';
import 'package:capo/utils/wallet_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionCell extends StatelessWidget {
  final Transaction history;
  TransactionCell({@required this.history, Key key}) : super(key: key);

  String getTime(Transaction transaction) {
    var date = DateTime.fromMillisecondsSinceEpoch(transaction.timestamp);
    date.toLocal();
    var formatter = DateFormat('yyyy/MM/dd HH:mm:ss');
    String dateString = formatter.format(date);
    return dateString;
  }

  String getAmount(Transaction transaction) {
    if (transaction.amount > 0) {
      String amount = capoNumberFormat(transaction.amount / 10e7);
      return amount + " REV";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Theme.of(context).cardColor,
          child: ListTile(
            onTap: () {
              Navigator.pushNamed(
                  context, "capo://icapo.app/transactions/detail",
                  arguments: {"transaction": history});
            },
            leading: Stack(alignment: const Alignment(0, 0), children: [
              Container(
                height: 28,
                width: 28,
                decoration: new BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                  border: new Border.all(
                      width: 2,
                      color: history.isSucceeded ? Colors.green : Colors.red),
                ),
              ),
              Icon(history.fromAddr ==
                      WalletViewModel.shared.currentWallet.address
                  ? Icons.call_made
                  : Icons.call_received),
            ]),
            subtitle: Text(
              getTime(history),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            title: Text(
              (history.fromAddr == WalletViewModel.shared.currentWallet.address
                  ? ("To:${history.toAddr}")
                  : ("From:${history.fromAddr}")),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14),
            ),
            trailing: Text((history.fromAddr ==
                        WalletViewModel.shared.currentWallet.address
                    ? "-"
                    : "+") +
                getAmount(history)),
          ),
        ),
        Divider(
          height: 2,
        )
      ],
    );
  }
}

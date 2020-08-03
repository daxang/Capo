import 'package:capo/modules/balance/send/model/send_history_model.dart';
import 'package:capo/modules/transactions/view_model/cell_view_model.dart';
import 'package:capo/provider/provider_widget.dart';
import 'package:capo/utils/capo_utils.dart';
import 'package:flutter/material.dart';

class TransactionCell extends StatelessWidget {
  final TransactionHistory history;
  TransactionCell({@required this.history, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<TransactionCellViewModel>(
      model: TransactionCellViewModel(history: history),
      onModelReady: (model) {
        model.fetchTransactionStatus();
      },
      builder: (_, viewModel, __) {
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
                  viewModel.shouldAnimate()
                      ? SizedBox(
                          width: 25,
                          height: 25,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                HexColor.mainColor),
                          ),
                        )
                      : Container(
                          height: 28,
                          width: 28,
                          decoration: new BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.all(Radius.circular(14)),
                            border: new Border.all(
                                width: 2, color: viewModel.getIndicatorColor()),
                          ),
                        ),
                  Icon(history.type == TransactionType.send
                      ? Icons.call_made
                      : Icons.call_received),
                ]),
                subtitle: Text(viewModel.getTime()),
                title: Text(
                  (viewModel.getType(history)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14),
                ),
                trailing: Text(viewModel.getAmount() + " REV"),
              ),
            ),
            Divider(
              height: 2,
            )
          ],
        );
      },
    );
  }
}

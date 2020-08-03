import 'package:capo/modules/balance/send/model/send_history_model.dart';
import 'package:capo/modules/transactions/view/transaction_cell.dart';
import 'package:capo/modules/transactions/view_model/transactions_view_model.dart';
import 'package:capo/provider/provider_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter/material.dart';
import 'package:rxbus/rxbus.dart';

@FFRoute(name: "capo://icapo.app/transactions")
class TransactionsPage extends StatefulWidget {
  TransactionsPage({Key key}) : super(key: key);

  @override
  _TransactionsPageState createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final TransactionsViewModel _transactionsViewModel = TransactionsViewModel();
  @override
  void initState() {
    super.initState();
    RxBus.register<String>(tag: "AddTransaction")
        .listen((event) => setState(() {
              _transactionsViewModel.getTransactions();
            }));
    RxBus.register<String>(tag: "SaveTransactions")
        .listen((String address) => setState(() {
              _transactionsViewModel.saveTransactions(address);
            }));

    RxBus.register<String>(tag: "WalletChange").listen((event) => setState(() {
          _transactionsViewModel.getTransactions();
        }));
  }

  @override
  void dispose() {
    RxBus.destroy(tag: "AddTransaction");
    RxBus.destroy(tag: "SaveTransactions");

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: PreferredSize(
          preferredSize: Size.fromHeight(44),
          child: AppBar(
            title: Text(tr("transactions.title"),
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
//          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              color: Theme.of(context).cardColor,
              child: ListTile(
                leading: Icon(
                  Icons.warning,
                  color: Colors.yellow,
                  size: 30,
                ),
                title: Text(
                  tr("transactions.warning"),
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.caption.color),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ProviderWidget<TransactionsViewModel>(
              model: _transactionsViewModel,
              onModelReady: (model) {
                model.getTransactions();
              },
              builder: (_, viewModel, __) {
                return Expanded(
                  child: viewModel.historyModel == null ||
                          viewModel
                                  .historyModel.transactionHistoryList.length ==
                              0
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.search,
                              size: 52,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              tr("transactions.no_transactions"),
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .color),
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: viewModel
                              .historyModel.transactionHistoryList.length,
                          itemBuilder: (context, index) {
                            TransactionHistory history = viewModel
                                .historyModel.transactionHistoryList[index];
                            return TransactionCell(
                              key: UniqueKey(),
                              history: history,
                            );
                          }),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

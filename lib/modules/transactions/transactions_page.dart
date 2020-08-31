import 'package:capo/modules/transactions/view/transaction_cell.dart';
import 'package:capo/modules/transactions/view_model/transactions_view_model.dart';
import 'package:capo/provider/provider_widget.dart';
import 'package:capo/utils/capo_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter/material.dart';
import 'package:rxbus/rxbus.dart';

import 'model/transfer_state_info.dart';

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
  GlobalKey<RefreshIndicatorState> refreshIndicatorKey;



  @override
  void initState() {
    super.initState();
    refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

    RxBus.register<String>(tag: "WalletChanged")
        .listen((event) => setState(() {
          if(event == "SwitchWallet"){
            refreshIndicatorKey.currentState.show();
          }
    }));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshIndicatorKey.currentState.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _transactionsViewModel.context = context;
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
        child: RefreshIndicator(
            key: refreshIndicatorKey,
            backgroundColor: HexColor.mainColor,
            color: Colors.white,
            onRefresh: _transactionsViewModel.getTransactions,
            child: ProviderWidget<TransactionsViewModel>(
              model: _transactionsViewModel,
              builder: (_, viewModel, __) {
                return ListView.builder(
//                    scrollDirection: Axis.vertical,
//                    shrinkWrap: true,
                    itemCount: (viewModel.historyModel == null || viewModel.historyModel.history.length == 0)
                        ? 1
                        : viewModel.historyModel.history.length,
                    itemBuilder: (context, index) {
                      if (viewModel.historyModel == null ||
                          viewModel.historyModel.history.length == 0) {
                        return Column(
                          children: <Widget>[
                            SizedBox(
                              height: 200,
                            ),
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
//                            SizedBox(
//                              height: 1000,
//                            ),
                          ],
                        );
                      }
                      TransferHistoryItem history =
                          viewModel.historyModel.history[index];
                      return TransactionCell(
                        key: UniqueKey(),
                        history: history,
                      );
                    });
              },
            )),
      ),
    );
  }
}

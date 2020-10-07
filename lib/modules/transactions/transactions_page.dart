import 'package:easy_localization/easy_localization.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart'
    as refresh;
import 'package:rxbus/rxbus.dart';

import 'model/transfer_state_info.dart';
import 'view/transaction_cell.dart';
import 'view_model/transactions_repository.dart';

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
  TransactionsRepository listSourceRepository;

  @override
  void initState() {
    listSourceRepository = TransactionsRepository();

    RxBus.register<String>(tag: "WalletChanged").listen((event) => setState(() {
          if (event == "SwitchWallet") {
            listSourceRepository.refresh();
          }
        }));
    super.initState();
  }

  @override
  void dispose() {
    listSourceRepository?.dispose();
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
        child: refresh.PullToRefreshNotification(
          onRefresh: listSourceRepository.refresh,
          // pullBackDuration: const Duration(seconds: 1),
          // pullBackOnRefresh: true,
          child: ListView(children: <Widget>[
            refresh.PullToRefreshContainer(buildPulltoRefreshWidget),
            LoadingMoreList(
              ListConfig<Transaction>(
                itemBuilder:
                    ((BuildContext context, Transaction item, int index) {
                  return TransactionCell(
                    key: UniqueKey(),
                    history: item,
                  );
                }),
                sourceList: listSourceRepository,
                padding: EdgeInsets.all(0.0),
                indicatorBuilder: _buildIndicator,
              ),
            ),
          ]),
        ),
//
      ),
    );
  }

  Widget buildPulltoRefreshWidget(
      refresh.PullToRefreshScrollNotificationInfo info) {
    double maxOffset() {
      if (info != null && info.dragOffset != null) {
        return info.dragOffset > 60 ? 60 : info.dragOffset;
      }
      return 0;
    }

    final double offset = maxOffset();
    Widget refreshWidget = Container(
      margin: const EdgeInsets.only(right: 5.0),
      height: 0.0,
      width: 0.0,
      child: getIndicator(context),
    );

    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
            height: (info == null || info.mode == null) ? 0 : offset,
            width: double.infinity),
        (info == null || info.mode == null) ? Container() : refreshWidget
      ],
    );
  }

  Widget _buildIndicator(BuildContext context, IndicatorStatus status) {
    //if your list is sliver list ,you should build sliver indicator for it
    //isSliver=true, when use it in sliver list
    const bool isSliver = false;
    final double bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewPadding.top -
        kToolbarHeight -
        kBottomNavigationBarHeight;
    Widget widget;
    switch (status) {
      case IndicatorStatus.none:
        widget = Container(height: 0.0);
        widget = _setbackground(false, widget, 35.0);
        break;
      case IndicatorStatus.loadingMoreBusying:
        widget = Container(
          margin: const EdgeInsets.only(right: 5.0),
          height: 15.0,
          width: 15.0,
          child: getIndicator(context),
        );
        widget = _setbackground(false, widget, 35.0);
        break;
      case IndicatorStatus.fullScreenBusying:
        widget = Container(
          margin: const EdgeInsets.only(right: 0.0),
          height: 30.0,
          width: 30.0,
          child: getIndicator(context),
        );
        widget = _setbackground(true, widget, bodyHeight);
        // if (isSliver) {
        //   widget = SliverFillRemaining(
        //     child: widget,
        //   );
        // } else {
        //   widget = SliverFillRemaining(
        //     child: widget,
        //   );
        // }
        break;
      case IndicatorStatus.error:
        widget = Text(tr("appError.genericError"));
        widget = _setbackground(false, widget, 35.0);

        widget = GestureDetector(
          onTap: () {
            listSourceRepository.errorRefresh();
          },
          child: widget,
        );

        break;
      case IndicatorStatus.fullScreenError:
        widget = Text(tr("list_info.fetch_data_error"));
        widget = _setbackground(true, widget, bodyHeight);
        widget = GestureDetector(
          onTap: () {
            listSourceRepository.errorRefresh();
          },
          child: widget,
        );
        break;
      case IndicatorStatus.noMoreLoad:
        widget = Text(tr("list_info.no_more"));
        widget = _setbackground(false, widget, bodyHeight);
        break;
      case IndicatorStatus.empty:
        widget = Text(tr("list_info.empty_list"));
        widget = _setbackground(false, widget, bodyHeight);
        break;
    }
    return widget;
  }

  Widget _setbackground(bool full, Widget widget, double height) {
    widget = Container(
        width: double.infinity,
        height: height,
        child: widget,
        color: Colors.grey[200],
        alignment: Alignment.center);
    return widget;
  }

  Widget getIndicator(BuildContext context) {
    final TargetPlatform platform = Theme.of(context).platform;
    return const CupertinoActivityIndicator(
      animating: true,
      radius: 16.0,
    );
  }
}

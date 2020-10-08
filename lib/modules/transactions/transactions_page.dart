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

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      key.currentState.show(notificationDragOffset: 80);
    });
    RxBus.register<String>(tag: "WalletChanged").listen((event) => setState(() {
          if (event == "SwitchWallet") {
            key.currentState.show(notificationDragOffset: 80);
          }
        }));
    super.initState();
  }

  @override
  void dispose() {
    listSourceRepository?.dispose();
    super.dispose();
  }

  final GlobalKey<refresh.PullToRefreshNotificationState> key =
      GlobalKey<refresh.PullToRefreshNotificationState>();
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
      body: Stack(children: <Widget>[
        refresh.PullToRefreshNotification(
          key: key,
          onRefresh: listSourceRepository.refresh,
          child: CustomScrollView(slivers: <Widget>[
            refresh.PullToRefreshContainer(buildPulltoRefreshHeader),
            LoadingMoreSliverList(
              SliverListConfig<Transaction>(
                autoRefresh: false,
                // scrollDirection: Axis.vertical,
                itemBuilder:
                    ((BuildContext context, Transaction item, int index) {
                  return TransactionCell(
                    key: UniqueKey(),
                    history: item,
                  );
                }),
                sourceList: listSourceRepository,
                padding: new EdgeInsets.all(0),
                indicatorBuilder: _buildIndicator,
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget buildPulltoRefreshHeader(
      refresh.PullToRefreshScrollNotificationInfo info) {
    final double offset = info?.dragOffset ?? 0.0;
    final refresh.RefreshIndicatorMode mode = info?.mode;
    final double bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewPadding.top -
        kToolbarHeight -
        kBottomNavigationBarHeight;
    print("info: ${mode}");
    Widget child;
    if (mode == refresh.RefreshIndicatorMode.error) {
      listSourceRepository.clear();

      child = Text(tr("list_info.fetch_data_error"));
      child = _setbackground(true, child, bodyHeight);
      child = GestureDetector(
        onTap: () {
          info?.pullToRefreshNotificationState?.show();
        },
        child: child,
      );
    } else {
      Widget refreshWidget = Container(
        margin: const EdgeInsets.only(right: 5.0),
        height: 0.0,
        width: 0.0,
        color: Colors.red,
        child: getIndicator(context),
      );
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(height: offset > 60 ? 60 : offset, width: double.infinity),
          refreshWidget
        ],
      );
    }

    return SliverToBoxAdapter(
      child: child,
    );
  }

  Widget _buildIndicator(BuildContext context, IndicatorStatus status) {
    print("status: $status");
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
        widget = SliverToBoxAdapter(child: Container());

        // widget = Container(
        //   margin: const EdgeInsets.only(right: 0.0),
        //   height: 30.0,
        //   width: 30.0,
        //   child: getIndicator(context),
        // );
        // widget = _setbackground(true, widget, bodyHeight);
        // widget = SliverToBoxAdapter(
        //   child: widget,
        // );

        break;
      case IndicatorStatus.error:
        widget = Container(
          height: 0,
        );

        // widget = Text(tr("appError.genericError"));
        // widget = _setbackground(false, widget, 35.0);
        //
        // widget = GestureDetector(
        //   onTap: () {
        //     key.currentState.show(notificationDragOffset: 80);
        //   },
        //   child: widget,
        // );

        break;
      case IndicatorStatus.fullScreenError:
        widget = Container();
        widget = SliverToBoxAdapter(
          child: widget,
        );
        break;
        widget = Text(tr("list_info.fetch_data_error"));
        widget = _setbackground(true, widget, bodyHeight);
        widget = GestureDetector(
          onTap: () {
            listSourceRepository.errorRefresh();
          },
          child: widget,
        );
        widget = SliverToBoxAdapter(
          child: widget,
        );
        break;
      case IndicatorStatus.noMoreLoad:
        widget = Text(tr("list_info.no_more"));
        widget = _setbackground(false, widget, 55);
        break;
      case IndicatorStatus.empty:
        widget = Text(tr("list_info.empty_list"));
        widget = _setbackground(false, widget, bodyHeight);
        widget = SliverToBoxAdapter(
          child: widget,
        );
        break;
    }
    return widget;
  }

  Widget _setbackground(bool full, Widget widget, double height) {
    widget = Container(
        width: double.infinity,
        height: height,
        child: widget,
        // color: Colors.grey[200],
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

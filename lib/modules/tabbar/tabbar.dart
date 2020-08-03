import 'package:capo/modules/settings/home/setting_page.dart';
import 'package:capo/modules/transactions/transactions_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

import '../balance/view/balance_page.dart';

@FFRoute(
    name: "capo://icapo.app/tabbar", pageRouteType: PageRouteType.transparent)
class BottomTabBar extends StatefulWidget {
  BottomTabBar({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BottomTabBarState();
}

class _BottomTabBarState extends State<BottomTabBar> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    BalanceHomePage(),
    TransactionsPage(),
    SettingsPage()
  ];

  final _pageController = PageController();

  void onTabTapped(int index) {
    _pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      final Map arguments = ModalRoute.of(context).settings.arguments;
      final indexString = (arguments != null && arguments['index'] != null)
          ? arguments['index']
          : "0";
      _currentIndex = int.parse(indexString);
      if (_currentIndex > 2 || _currentIndex < 0) {
        _currentIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime lastPopTime;
    final items = [
      BottomNavigationBarItem(
          title: Text(tr('bottomTabBar.balance')),
          icon: const Icon(Icons.account_balance)),
      BottomNavigationBarItem(
          title: Text(tr('bottomTabBar.transactions')),
          icon: const Icon(Icons.transform)),
      BottomNavigationBarItem(
          title: Text(tr('bottomTabBar.settings')),
          icon: const Icon(Icons.settings)),
    ];
    return WillPopScope(
      onWillPop: () async {
        if (lastPopTime == null ||
            DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
          lastPopTime = DateTime.now();
          //实现toast
          showToast(tr("exit_hint"), duration: Duration(seconds: 2));
        } else {
          lastPopTime = DateTime.now();
          // 退出app
          await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        }
        return;
      },
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: onPageChanged,
          children: _children,
          physics: const NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: onTabTapped,
          items: items,
          selectedItemColor: Color.fromARGB(255, 51, 118, 184),
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }
}

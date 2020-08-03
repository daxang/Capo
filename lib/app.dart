import 'dart:io';

import 'package:capo/modules/common/view/notfound_page.dart';
import 'package:capo/utils/capo_utils.dart';
import 'package:capo/utils/provider_manager.dart';
import 'package:capo/utils/theme_view_model.dart';
import 'package:capo/utils/wallet_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'capo_route.dart';
import 'capo_route_helper.dart';

class CapoApp extends StatefulWidget {
  @override
  _CapoAppState createState() => _CapoAppState();
}

class _CapoAppState extends State<CapoApp> {
    static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  @override
  Widget build(BuildContext context) {
    final data = EasyLocalizationProvider.of(context).data;
    return OKToast(
      child: MultiProvider(
        providers: providers,
        child: Consumer2<ThemeViewModel, WalletViewModel>(
          builder: (context, themeModel, walletModel, child) {
            return MaterialApp(
              theme: themeModel.themeData(),
              darkTheme: themeModel.themeData(platformDarkMode: true),
              navigatorObservers: <NavigatorObserver>[observer],

              //init localization
              locale: data.locale,
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                //app-specific localization
                EasyLocalizationDelegate(
                    locale: data.locale, path: 'resources/langs')
              ],
              localeResolutionCallback: (deviceLocale, supportedLocales) {
                for (Locale local in supportedLocales) {
                  if (local.languageCode == deviceLocale.languageCode) {
                    capoAppDeviceLocale = local;
                    return local;
                  }
                }
                capoAppDeviceLocale = Locale('en', 'US');
                return Locale('en', 'US');
              },
              supportedLocales: [
                const Locale('zh', 'CN'),
                const Locale('en', 'US'),
              ],
              //init route
              initialRoute: walletModel.walletManager.currentWallet == null
                  ? "capo://icapo.app/wallet/guide"
                  : "capo://icapo.app/tabbar",
              onGenerateRoute: (RouteSettings settings) {
                final routeResult = getRouteResult(pageUrl: settings.name);
                final queryParameters =
                    Uri.parse(settings.name ?? "").queryParameters;
                final arguments = queryParameters.isEmpty
                    ? settings.arguments
                    : queryParameters;

                if (routeResult.showStatusBar != null ||
                    routeResult.routeName != null) {
                  settings = FFRouteSettings(
                      arguments: arguments,
                      name: settings.name,
                      routeName: routeResult.routeName,
                      showStatusBar: routeResult.showStatusBar);
                }

                var page = routeResult.widget ?? NotFoundPage();

                switch (routeResult.pageRouteType) {
                  case PageRouteType.material:
                    return MaterialPageRoute(
                        settings: settings, builder: (c) => page);
                  case PageRouteType.cupertino:
                    return CupertinoPageRoute(
                        settings: settings, builder: (c) => page);
                  case PageRouteType.transparent:
                    return FFTransparentPageRoute(
                        settings: settings,
                        pageBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secondaryAnimation) =>
                            page);
                  default:
                    return Platform.isIOS
                        ? CupertinoPageRoute(
                            settings: settings, builder: (c) => page)
                        : MaterialPageRoute(
                            settings: settings, builder: (c) => page);
                }
              },
            );
          },
        ),
      ),
    );
  }

  ///初始化
  void initXUpdate() {
    if (Platform.isAndroid) {
      FlutterXUpdate.init(
              debug: false,
              isPost: false,
              isPostJson: false,
              isWifiOnly: false,
              isAutoMode: false,
              supportSilentInstall: false,
              enableRetry: false)
          .then((value) {
        checkUpdate();
      }).catchError((_) {});

      FlutterXUpdate.setUpdateHandler(
          onUpdateError: (Map<String, dynamic> message) async {
        int code = message["code"];
        if (code != null && code == 5000) {
          showToast(message["message"], dismissOtherToast: true);
        }
      });
    }
  }

  void checkUpdate() async {
    UpdateEntity entity = await fetchUpdateEntity().catchError((_) {});
    if (entity != null) {
      FlutterXUpdate.updateByInfo(updateEntity: entity);
    }
  }

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      initXUpdate();
    }
  }
}

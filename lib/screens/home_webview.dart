import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:upgrader/upgrader.dart';
import 'screen_base.dart';
import '../widgets/float_buttons/expanded_float_button.dart';
import '../core/remote_configuration/models/mobile_ads.dart';
import '../widgets/banner_ad_widget.dart';

import '../consts.dart';
import '../globals.dart';
import '../core/app_helper.dart';
import '../core/connection_status_listener.dart';
import '../core/mobile_ads/app_open_ads_helper.dart';
import '../core/mobile_ads/interstitial_ad_helper.dart';
import '../widgets/app_webview.dart';
import '../widgets/bottom_control_bar.dart';
import '../widgets/bottom_nagivation_bar.dart';
import '../widgets/webview_scaffold.dart';

class HomeWebviewScreen extends StatefulWidget {
  const HomeWebviewScreen({Key? key}) : super(key: key);

  @override
  HomeWebviewScreenState createState() => HomeWebviewScreenState();
}

class HomeWebviewScreenState extends State<HomeWebviewScreen>
    with WidgetsBindingObserver, ScreenBase {
  final ConnectionStatusListener _connectionStatus =
      ConnectionStatusListener.getInstance();
  late Future<void> checkruntime;
  late StreamSubscription<bool> connectionListener;

  @override
  void initState() {
    configure(context: context, fullscreen: false);
    AppHelper.checkForcedPermission();

    AppOpenAdsHelper.showOnAppOpen();
    InterstitialAdsHelper.startInterval();
    connectionListener =
        _connectionStatus.connectionChange.listen((isConnectedToInternet) {
      if (!isConnectedToInternet) {
        Navigator.of(context).pushReplacementNamed(AppConsts.notOnlineRoute);
      }
    });

    WidgetsBinding.instance.addObserver(this);

    checkruntime = Future.delayed(const Duration(seconds: 3),
        () => AppHelper.checkWebsiteVersion(context));
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    Globals.inAppWebViewController = Completer<InAppWebViewController>();
    checkruntime.ignore();
    connectionListener.cancel();
    super.dispose();
  }

  AppLifecycleState? oldState;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (oldState == AppLifecycleState.paused &&
        state == AppLifecycleState.resumed) {
      AppOpenAdsHelper.showOnAppResumed();
    }
    oldState = state;
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = WebviewScafoldWidget(
      bottomNavBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          BannerAdWidget(location: BannerAdLocation.bottom),
          AppBottomNavigationBarWidget(),
          BottomControlBarWidget(),
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: const ExpandableFloatButton(),
      webView: AppWebViewWidget(
        initialURL: Globals.configuration.initialLinkWithParameters,
        onWebViewCreated: (InAppWebViewController argController) {
          if (!Globals.inAppWebViewController.isCompleted) {
            Globals.inAppWebViewController.complete(argController);
          }
        },
        onLoadStart: (url) {},
        onLoadStop: (url) async {},
      ),
    );
    return Globals.configuration.preferences.appUpgrader
        ? UpgradeAlert(child: scaffold)
        : scaffold;
  }
}

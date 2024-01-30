import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../core/app_helper.dart';
import '../core/remote_configuration/models/mobile_ads.dart';
import '../globals.dart';
import 'app_bar.dart';
import 'app_webview.dart';
import 'banner_ad_widget.dart';
import 'double_back_to_close_app.dart';

class WebviewScafoldWidget extends StatelessWidget {
  final AppWebViewWidget webView;
  final Widget? bottomNavBar;
  final Widget floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const WebviewScafoldWidget({
    Key? key,
    required this.webView,
    required this.floatingActionButton,
    this.bottomNavBar,
    this.floatingActionButtonLocation,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Globals.configuration.backgroundColor,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
            bottom: Globals.configuration.preferences.floatButtonBottomPadding),
        child: floatingActionButton,
      ),
      floatingActionButtonLocation: floatingActionButtonLocation,
      resizeToAvoidBottomInset:
          Globals.configuration.preferences.resizeToAvoidBottomInset,
      bottomNavigationBar: bottomNavBar,
      appBar: const AppBarWidget(),
      body: DoubleBackToCloseAppWidget(
        snackBar: SnackBar(
          content: Text(tr("tap_to_exit")),
        ),
        child: Column(
          children: [
            const BannerAdWidget(location: BannerAdLocation.top),
            Expanded(
              child: webView,
            ),
          ],
        ),
      ),
    );
  }
}

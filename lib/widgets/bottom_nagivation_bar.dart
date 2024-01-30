// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:webvify/core/link_redirection/url_link_redirect.dart';

import '../extensions.dart';
import '../globals.dart';
import '../core/app_helper.dart';
import '../core/mobile_ads/interstitial_ad_helper.dart';
import '../core/remote_configuration/models/bottom_navigation_bar.dart';
import 'app_webview.dart';

class AppBottomNavigationBarWidget extends StatefulWidget {
  const AppBottomNavigationBarWidget({Key? key}) : super(key: key);

  @override
  State<AppBottomNavigationBarWidget> createState() =>
      _AppBottomNavigationBarWidgetState();
}

class _AppBottomNavigationBarWidgetState
    extends State<AppBottomNavigationBarWidget> {
  bool hideNavBar = true;
  late Timer timer;
  BottomNavigationBarModel get bottomNavBarConf =>
      Globals.configuration.bottomNavigationBarProps;
  int bottomNavBarSelectedIndex =
      Globals.configuration.bottomNavigationBarProps.initialIndex;
  Color bottomNavigationActiveColor = Globals.configuration.primaryColor;

  @override
  void initState() {
    super.initState();
    if (bottomNavBarConf.active) {
      listenWebview();
    }
  }

  @override
  void dispose() {
    if (bottomNavBarConf.active) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return bottomNavBarConf.active
        ? _navbar
        : const SizedBox(height: 0, width: 0);
  }

  void listenWebview() async {
    String lastUrl = "";
    timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      try {
        var controller = await Globals.inAppWebViewController.future;
        String currentURL = (await controller.getUrl()).toString();

        if (lastUrl != currentURL) {
          lastUrl = currentURL;
          setBottomNavigationBarVisibilty(currentURL);
          if (bottomNavBarConf.listenWebview) {
            setBottomNavigationBarIndex(currentURL);
          }
        }
      } on Error {
        timer.cancel();
      }
    });
  }

  PersistentBottomNavBar get _navbar {
    return PersistentBottomNavBar(
      navBarDecoration: NavBarDecoration(
        adjustScreenBottomPaddingOnCurve: false,
        colorBehindNavBar: bottomNavBarConf.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, -7), // changes position of shadow
          ),
        ],
      ),
      confineToSafeArea: false,
      margin: EdgeInsets.zero,
      navBarEssentials: NavBarEssentials(
        popScreensOnTapOfSelectedTab: false,
        navBarHeight: hideNavBar ? 0 : AppHelper.navigationBarHeight(context),
        backgroundColor: bottomNavBarConf.backgroundColor,
        selectedIndex: bottomNavBarSelectedIndex,
        items: _navbarItems,
        padding: NavBarPadding.only(
            bottom: AppHelper.hasBottomSpace(context) ? 24.0 : 12.0),
        onItemSelected: (int index) async {
          InterstitialAdsHelper.onBottomNavBarClicked();
          setState(() {
            bottomNavBarSelectedIndex = index;
          });
          var controller = await Globals.inAppWebViewController.future;

          var item = bottomNavBarConf.navbarItems[index];

          if (item.scrollToTop) {
            await controller.scrollTo(x: 0, y: 0);
          }

          if ((item.url ?? "").isNotEmpty) {
            if (item.url!.isInAppScheme) {
              item.url!.toLinkRedirector!.redirect();
            } else if (item.url!.isExternalLink) {
              AppHelper.launchURL(context, item.url!);
            } else {
              var redirector = item.url!.toLinkRedirector;
              redirector?.redirect();
            }
            return;
          }

          if ((item.javascript ?? "").isNotEmpty) {
            controller.evaluateJavascript(source: item.javascript!);
            return;
          }
        },
        itemAnimationProperties: const ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
      ),
      navBarStyle: bottomNavBarConf.style,
    );
  }

  List<PersistentBottomNavBarItem> get _navbarItems {
    return bottomNavBarConf.navbarItems
        .map((item) => PersistentBottomNavBarItem(
              icon: Icon(
                item.iconData,
                size: item.size,
                color: item.iconColor,
              ),
              title: tr(item.title ?? ""),
              activeColorPrimary: item.activeColorPrimary,
              activeColorSecondary: item.activeColorSecondary,
              inactiveColorPrimary: item.inactiveColorPrimary,
              inactiveColorSecondary: item.inactiveColorSecondary,
            ))
        .toList();
  }

  void setBottomNavigationBarVisibilty(String url) {
    setState(() {
      hideNavBar = Globals
          .configuration.bottomNavigationBarProps.hideOnThisLinks
          .any((element) => url.startsWith(element));
    });
  }

  void setBottomNavigationBarIndex(String url) {
    bool bottomBarIsSet = false;

    for (var item in bottomNavBarConf.navbarItems) {
      int index = bottomNavBarConf.navbarItems.indexOf(item);
      if (item.url != null && url.startsWith(item.url!)) {
        setState(() {
          bottomBarIsSet = true;
          bottomNavBarSelectedIndex = index;
          bottomNavigationActiveColor = Globals.configuration.primaryColor;
        });
      }
    }

    if (!bottomBarIsSet) {
      setState(() {
        bottomNavBarSelectedIndex = 0;
        bottomNavigationActiveColor = Colors.grey;
      });
    }
  }
}

import 'package:flutter/material.dart';

import '../../consts.dart';
import '../../globals.dart';
import 'link_redirector.dart';

class RouteLinkRedirect extends LinkRedirector {
  Map<String, String> linksToRoute = {
    "splash": AppConsts.splashRoute,
    "landing": AppConsts.landingRoute,
    "onboarding": AppConsts.onboardingRoute,
    "login": AppConsts.loginRoute,
    "home": AppConsts.homeRoute,
    "home-webview": AppConsts.homeWebviewRoute,
    "not-online": AppConsts.notOnlineRoute,
    "page-not-found": AppConsts.pageNotFoundRoute,
    "error": AppConsts.errorRoute,
    "shopping": AppConsts.shoppingRoute,
  };
  RouteLinkRedirect(super.link);

  @override
  void redirect() async {
    await super.readyToRedirect;
    await Future.delayed(super.duration);
    var uri = Uri.parse(link);
    var route = linksToRoute[uri.host];
    if (route == null) return;
    Navigator.of(await Globals.waitForBuildContext).pushReplacementNamed(route);
  }
}

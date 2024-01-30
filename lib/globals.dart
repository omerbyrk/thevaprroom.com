import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'core/remote_configuration/configuration.dart';

class Globals {
  static String firebaseToken = "not_integrated_yet";
  static String userId = "not_integrated_yet";

  static late Configuration configuration;
  static Completer<InAppWebViewController> inAppWebViewController =
      Completer<InAppWebViewController>();

  static Completer<Function()> goBackFunction = Completer<Function()>();
  static BuildContext? buildContext;

  static Future<BuildContext> get waitForBuildContext async {
    while (buildContext == null) {
      await Future.delayed(const Duration(milliseconds: 50));
    }
    return Future.value(buildContext);
  }
}

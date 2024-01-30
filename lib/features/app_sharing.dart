import 'dart:io';

import 'package:flutter_share/flutter_share.dart';

import '../core/remote_configuration/models/app_sharing.dart';
import '../globals.dart';
import 'feature.dart';

class AppSharingFeature extends Feature {
  AppSharingModel get sharingConf => Globals.configuration.appSharing;
  @override
  void trigger() async {
    var sharingText = Platform.isAndroid
        ? sharingConf.androidShareText
        : sharingConf.iOSShareText;
    var sharingTitle = "Share It!";
    if (sharingText.contains("{current_url}")) {
      final controller = await Globals.inAppWebViewController.future;
      final currentUrl = (await controller.getUrl()).toString();
      sharingText = sharingText.replaceAll("{current_url}", currentUrl);
    }

    if (parameters.containsKey("text")) {
      sharingText = parameters["text"]!;
    }

    if (parameters.containsKey("title")) {
      sharingTitle = parameters["title"]!;
    }

    await FlutterShare.share(title: sharingTitle, text: sharingText);
  }
}

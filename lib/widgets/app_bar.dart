import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../globals.dart';
import '../core/remote_configuration/models/app_bar.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  State<AppBarWidget> createState() => _AppBarWidgetState();

  @override
  Size get preferredSize => Globals.configuration.appBar.active
      ? AppBar().preferredSize
      : const Size(0.0, 0.0);
}

class _AppBarWidgetState extends State<AppBarWidget> {
  late Timer timer;
  AppBarModel get appBarProps => Globals.configuration.appBar;
  bool get isWebviewListening => appBarProps.active && !appBarProps.keepDefault;

  late String title = appBarProps.defaultTitle;

  @override
  void initState() {
    if (isWebviewListening) {
      listenWebviewTitle();
    }
    super.initState();
  }

  @override
  void dispose() {
    if (isWebviewListening) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return appBarProps.active
        ? AppBar(
            leading: InkWell(
              onTap: () async {
                (await Globals.goBackFunction.future)();
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: appBarProps.foregroundColor,
                size: 30,
              ),
            ),
            title: Text(
              tr(title),
              style: TextStyle(
                color: appBarProps.foregroundColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: appBarProps.centerTitle,
            backgroundColor: appBarProps.backgroundColor,
            elevation: appBarProps.elevation.toDouble(),
          )
        : Container(
            color: Globals.configuration.statusBarColor,
          );
  }

  void listenWebviewTitle() async {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      var controller = await Globals.inAppWebViewController.future;
      String? webTitle = await controller.getTitle();
      setState(() {
        title = webTitle == null || webTitle.isEmpty || appBarProps.keepDefault
            ? appBarProps.defaultTitle
            : webTitle;
      });
    });
  }
}

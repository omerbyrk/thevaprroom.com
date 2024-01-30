import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../widgets/double_back_to_close_app.dart';
import '../core/app_helper.dart';
import 'screen_base.dart';
import '../consts.dart';
import '../extensions.dart';
import '../globals.dart';
import '../core/connection_status_listener.dart';
import '../core/remote_configuration/models/home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with ScreenBase {
  final ConnectionStatusListener _connectionStatus =
      ConnectionStatusListener.getInstance();
  late StreamSubscription<bool> connectionListener;
  HomeScreenModel get homeProps => Globals.configuration.homeScreen;
  @override
  void initState() {
    configure(context: context, fullscreen: !homeProps.statusBar);
    AppHelper.checkForcedPermission();

    connectionListener =
        _connectionStatus.connectionChange.listen((isConnectedToInternet) {
      if (!isConnectedToInternet) {
        Navigator.of(context).pushReplacementNamed(AppConsts.notOnlineRoute);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    connectionListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: DoubleBackToCloseAppWidget(
        snackBar: SnackBar(
          content: Text(tr("tap_to_exit")),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image(
              image: homeProps.backgroundUrl.toImageProvider,
              fit: BoxFit.cover,
            ),
            Align(
              alignment: homeProps.logoField.location.toAlignment,
              child: Padding(
                padding: homeProps.logoField.padding,
                child: SizedBox(
                  height: homeProps.logoField.size.height,
                  width: homeProps.logoField.size.width,
                  child: Image(
                    image: homeProps.logoField.url.toImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Align(
              alignment: homeProps.buttonField.location.toAlignment,
              child: Padding(
                padding: homeProps.buttonField.padding,
                child: SizedBox(
                  height: homeProps.buttonField.size.height,
                  width: homeProps.buttonField.size.width,
                  child: GridView.count(
                    crossAxisCount: homeProps.buttonField.horizontalButtonCount,
                    crossAxisSpacing:
                        homeProps.buttonField.horizontalButtonSpacing,
                    mainAxisSpacing:
                        homeProps.buttonField.verticalButtonSpacing,
                    childAspectRatio: homeProps.buttonField.buttonAspectRatio,
                    children: homeProps.buttonField.buttons
                        .map(
                          (button) => TextButton.icon(
                            onPressed: () {
                              button.url.toLinkRedirector?.redirect();
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  button.backgroundColor),
                              foregroundColor: MaterialStateProperty.all(
                                  button.foregroundColor),
                            ),
                            icon: Icon(button.iconData),
                            label: Padding(
                                padding:
                                    EdgeInsets.only(left: button.iconSpacing),
                                child: Text(tr(button.title))),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

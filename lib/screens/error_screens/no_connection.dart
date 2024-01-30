import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/app_helper.dart';
import '../../core/connection_status_listener.dart';
import '../../extensions.dart';
import '../../globals.dart';
import '../../main.dart';
import '../screen_base.dart';

class NoConnectionScreen extends StatefulWidget {
  const NoConnectionScreen({Key? key}) : super(key: key);

  @override
  NoConnectionScreenState createState() => NoConnectionScreenState();
}

class NoConnectionScreenState extends State<NoConnectionScreen>
    with ScreenBase {
  final ConnectionStatusListener _connectionStatus =
      ConnectionStatusListener.getInstance();
  late StreamSubscription<bool> connectionListener;

  @override
  void initState() {
    configure(context: context, fullscreen: true);

    connectionListener = _connectionStatus.connectionChange
        .listen((isConnectedToInternet) async {
      if (isConnectedToInternet) {
        runRemoteConfigDependencies().then((value) {
          AppHelper.goLandingScreen();
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    connectionListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/error_screens/no_connection.png",
            fit: BoxFit.cover,
            color: Globals.configuration.primaryColor.withOpacity(.15),
            colorBlendMode: BlendMode.lighten,
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.20,
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.15,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  tr("no_connection_screen_title"),
                  style: const TextStyle(
                    color: Color(0xff010022),
                    fontSize: 28,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  tr("no_connection_screen_body"),
                  style: const TextStyle(
                    color: Color(0xff9797A5),
                    fontSize: 18,
                    height: 1.3,
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.11,
            left: MediaQuery.of(context).size.width * 0.065,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 5),
                    blurRadius: 25,
                    color: Globals.configuration.primaryColor.withOpacity(0.17),
                  ),
                ],
              ),
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Globals.configuration.primaryColor),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                onPressed: () async {
                  _connectionStatus
                      .checkConnection()
                      .then((isConnectedToInternet) {
                    if (isConnectedToInternet) {
                      AppHelper.goLandingScreen();
                      return;
                    }

                    ScaffoldMessenger.of(context)
                        .showSnackBar(notOnlineSnackBar.toStandart);
                  });
                },
                child: Text(
                  tr("retry"),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  final notOnlineSnackBar = SnackBar(
    content: Text(
      tr(
        "network_connection_is_failed",
      ),
    ),
  );
}
/*
                  var isConnectedToInternet =
                      await _connectionStatus.checkConnection();
                  await Future.delayed(Duration(seconds: 1));
                  if (isConnectedToInternet) {
                    setState(() {
                      buttonState = ButtonState.success;
                    });
                    await Future.delayed(Duration(milliseconds: 900));
                    
 */
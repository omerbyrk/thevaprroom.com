import 'package:flutter/material.dart';

import '../../core/app_helper.dart';
import '../../core/remote_configuration/models/home.dart';
import '../../globals.dart';
import 'float_button_base.dart';

class GoHomeFloatButton extends StatelessWidget with FloatButtonBase {
  const GoHomeFloatButton({super.key});
  HomeScreenModel get homeConf => Globals.configuration.homeScreen;

  @override
  bool isActive() {
    return homeConf.active && homeConf.goHomeFloatButton;
  }

  @override
  Widget build(BuildContext context) {
    return isActive()
        ? FloatingActionButton.small(
            heroTag: "go_home",
            backgroundColor: Globals.configuration.backgroundColor,
            onPressed: () {
              AppHelper.goLandingScreen(context: context);
            },
            child: Icon(
              Icons.home,
              color: Globals.configuration.primaryColor,
            ),
          )
        : const SizedBox(height: 0, width: 0);
  }
}

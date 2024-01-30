import 'package:flutter/material.dart';

import '../core/app_helper.dart';
import '../globals.dart';

class ScreenBase {
  void configure({
    required BuildContext context,
    bool fullscreen = true,
  }) {
    Globals.buildContext = context;
    if (fullscreen) {
      AppHelper.fullscreen();
    } else {
      AppHelper.notFullscreen();
    }
  }
}

import 'package:flutter/material.dart';

import '../../features/app_sharing.dart';
import '../../globals.dart';
import 'float_button_base.dart';

class AppSharingFloatButton extends StatelessWidget with FloatButtonBase {
  const AppSharingFloatButton({super.key});

  @override
  bool isActive() {
    return Globals.configuration.appSharing.active;
  }

  @override
  Widget build(BuildContext context) {
    return isActive()
        ? FloatingActionButton.small(
            heroTag: "appSharingButton",
            backgroundColor: Globals.configuration.backgroundColor,
            onPressed: () async {
              AppSharingFeature().trigger();
            },
            child: Icon(
              Icons.share,
              color: Globals.configuration.primaryColor,
            ),
          )
        : const SizedBox(height: 0, width: 0);
  }
}

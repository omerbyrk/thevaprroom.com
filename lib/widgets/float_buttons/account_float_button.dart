import 'package:flutter/material.dart';

import '../../consts.dart';
import '../../core/remote_configuration/models/login.dart';
import '../../globals.dart';
import 'float_button_base.dart';

class AccountFloatButton extends StatelessWidget with FloatButtonBase {
  const AccountFloatButton({super.key});

  LoginScreenModel get loginConf => Globals.configuration.loginScreen;

  @override
  bool isActive() {
    return loginConf.active && loginConf.accountFloatButton;
  }

  @override
  Widget build(BuildContext context) {
    return isActive()
        ? FloatingActionButton.small(
            heroTag: "loginButton",
            backgroundColor: Globals.configuration.backgroundColor,
            onPressed: () async {
              Navigator.of(context).pushReplacementNamed(AppConsts.loginRoute);
            },
            child: Icon(
              Icons.person,
              color: Globals.configuration.primaryColor,
            ),
          )
        : const SizedBox(height: 0, width: 0);
  }
}

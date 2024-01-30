import 'package:flutter/material.dart';

import '../../../extensions.dart';
import '../defaults.dart';

class LoginScreenModel {
  final bool active;
  final bool forceToLogin;
  final bool accountFloatButton;
  final bool disableRegister;
  final bool disableGoHomeButton;
  final Brightness brightness;
  final Color backgroundColor;
  final Color linkColor;
  final LoginLogoField logoField;

  const LoginScreenModel(
      {required this.active,
      required this.forceToLogin,
      required this.accountFloatButton,
      required this.disableRegister,
      required this.disableGoHomeButton,
      required this.brightness,
      required this.backgroundColor,
      required this.linkColor,
      required this.logoField});

  factory LoginScreenModel.fromMap(Map map) {
    return LoginScreenModel(
      active: map["active"] ?? Defaults.loginModel.active,
      forceToLogin: map["force_to_login"] ?? Defaults.loginModel.forceToLogin,
      accountFloatButton:
          map["account_float_button"] ?? Defaults.loginModel.accountFloatButton,
      disableRegister:
          map["disable_register"] ?? Defaults.loginModel.disableRegister,
      disableGoHomeButton:
          map["disable_go_home_button"] ?? Defaults.loginModel.disableRegister,
      brightness: (map["brightness"] ??
              (Defaults.loginModel.brightness == Brightness.light))
          ? Brightness.light
          : Brightness.dark,
      backgroundColor:
          (map["background_color"] ?? Defaults.loginModel.backgroundColor)
              .toString()
              .toColor,
      linkColor: (map["link_color"] ?? Defaults.loginModel.linkColor)
          .toString()
          .toColor,
      logoField: map["logo"] == null
          ? Defaults.loginModel.logoField
          : LoginLogoField.fromMap(map["logo"]),
    );
  }

  Map<String, dynamic> toMap() => {
        "active": active,
        "force_to_login": forceToLogin,
        "account_float_button": accountFloatButton,
        "disable_register": disableRegister,
        "disable_go_home_button": disableGoHomeButton,
        "background_color": backgroundColor.getString(),
        "link_color": linkColor.getString(),
        "brightness": brightness == Brightness.light,
        "logo": logoField.toMap()
      };
}

class LoginLogoField {
  final String url;
  final double width;
  final double height;

  const LoginLogoField({
    required this.url,
    required this.width,
    required this.height,
  });

  factory LoginLogoField.fromMap(Map map) {
    return LoginLogoField(
      url: map["url"] ?? Defaults.loginModel.logoField.url,
      width: double.parse((map["width"]?.toString() ??
          Defaults.loginModel.logoField.width.toString())),
      height: double.parse((map["height"]?.toString() ??
          Defaults.loginModel.logoField.height.toString())),
    );
  }

  Map<String, dynamic> toMap() => {
        "url": url,
        "width": width,
        "height": height,
      };
}

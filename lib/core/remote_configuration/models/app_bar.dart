import 'package:flutter/material.dart';

import '../../../extensions.dart';
import '../defaults.dart';

class AppBarModel {
  final bool active;
  final String defaultTitle;
  final bool keepDefault;
  final Color backgroundColor;
  final Color foregroundColor;
  final int elevation;
  final bool centerTitle;

  const AppBarModel({
    required this.active,
    required this.defaultTitle,
    required this.keepDefault,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.elevation,
    required this.centerTitle,
  });

  factory AppBarModel.fromMap(Map map) {
    return AppBarModel(
      active: map["active"] ?? Defaults.appBar.active,
      defaultTitle: map["default_title"] ?? Defaults.appBar.defaultTitle,
      keepDefault: map["keep_default"] ?? Defaults.appBar.keepDefault,
      backgroundColor:
          (map["background_color"] ?? Defaults.appBar.backgroundColor)
              .toString()
              .toColor,
      foregroundColor:
          (map["foreground_color"] ?? Defaults.appBar.foregroundColor)
              .toString()
              .toColor,
      elevation: map["elevation"] ?? Defaults.appBar.elevation,
      centerTitle: map["center_title"] ?? Defaults.appBar.centerTitle,
    );
  }

  Map<String, dynamic> toMap() => {
        "active": active,
        "default_title": defaultTitle,
        "keep_default": keepDefault,
        "background_color": backgroundColor.getString(),
        "foreground_color": foregroundColor.getString(),
        "elevation": elevation,
        "center_title": centerTitle
      };
}

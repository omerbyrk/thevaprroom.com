import 'package:flutter/material.dart';

import '../../../extensions.dart';
import '../defaults.dart';

class BottomControlBarModel {
  final bool active;
  final Color backgroundColor;
  final Color iconColor;

  const BottomControlBarModel({
    required this.backgroundColor,
    required this.active,
    required this.iconColor,
  });

  factory BottomControlBarModel.fromMap(Map map) {
    return BottomControlBarModel(
      backgroundColor: (map["background_color"] ??
              Defaults.bottomControlBar.backgroundColor.getString())
          .toString()
          .toColor,
      active: map["active"] ?? Defaults.bottomControlBar.active,
      iconColor:
          (map["icon_color"] ?? Defaults.bottomControlBar.iconColor.getString())
              .toString()
              .toColor,
    );
  }

  Map<String, dynamic> toMap() => {
        "background_color": backgroundColor.getString(),
        "active": active,
        "icon_color": iconColor.getString()
      };
}

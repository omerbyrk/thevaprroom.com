import 'package:flutter/material.dart';

import '../defaults.dart';
import '../../../extensions.dart';

class StatusBarModel {
  final Color backgroundColor;
  final Brightness brightness;
  const StatusBarModel(
      {required this.backgroundColor, required this.brightness});

  factory StatusBarModel.fromMap(Map map) {
    return StatusBarModel(
        backgroundColor: (map["background_color"] ??
                Defaults.statusBar.backgroundColor.getString())
            .toString()
            .toColor,
        brightness: (map["brightness"] ??
                (Defaults.statusBar.brightness == Brightness.light))
            ? Brightness.light
            : Brightness.dark);
  }

  Map<String, dynamic> toMap() => {
        "background_color": backgroundColor.getString(),
        "brightness": brightness == Brightness.light
      };
}

import 'package:flutter/material.dart';

import '../../../extensions.dart';
import '../defaults.dart';

class LoadingScreenModel {
  final bool active;
  final String loadingSpinnerUrl;
  final Color color;
  final Color backgroundColor;
  final Color secondaryBackgroundColor;
  final int hideLoadingScreenAt;
  const LoadingScreenModel({
    required this.loadingSpinnerUrl,
    required this.color,
    required this.secondaryBackgroundColor,
    required this.backgroundColor,
    required this.active,
    required this.hideLoadingScreenAt,
  });

  factory LoadingScreenModel.fromMap(Map map) {
    return LoadingScreenModel(
        color: (map["color"] ?? Defaults.loading.color.getString())
            .toString()
            .toColor,
        backgroundColor: (map["background_color"] ??
                Defaults.loading.backgroundColor.getString())
            .toString()
            .toColor,
        loadingSpinnerUrl:
            (map["loading_spinner_url"] ?? Defaults.loading.active),
        active: (map["active"] ?? Defaults.loading.active),
        hideLoadingScreenAt: map["hide_loading_screen_at"] ??
            Defaults.loading.hideLoadingScreenAt,
        secondaryBackgroundColor: (map["secondary_background_color"] ??
                Defaults.loading.secondaryBackgroundColor.getString())
            .toString()
            .toColor);
  }

  Map<String, dynamic> toMap() => {
        "background_color": backgroundColor.getString(),
        "secondary_background_color": secondaryBackgroundColor.getString(),
        "loading_spinner_url": loadingSpinnerUrl,
        "color": color.getString(),
        "active": active,
        "hide_loading_screen_at": hideLoadingScreenAt
      };
}

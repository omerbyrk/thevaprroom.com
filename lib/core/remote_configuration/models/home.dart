import 'package:flutter/material.dart';

import '../../../extensions.dart';
import '../defaults.dart';

class HomeScreenModel {
  final bool active;
  final bool goHomeFloatButton;
  final bool statusBar;
  final String backgroundUrl;
  final LogoField logoField;
  final ButtonField buttonField;

  const HomeScreenModel({
    required this.active,
    required this.goHomeFloatButton,
    required this.statusBar,
    required this.backgroundUrl,
    required this.logoField,
    required this.buttonField,
  });

  factory HomeScreenModel.fromMap(Map<String, dynamic> map) => HomeScreenModel(
        active: map['active'] ?? Defaults.homeActive,
        goHomeFloatButton:
            map['go_home_float_button'] ?? Defaults.homeGoHomeFloatButton,
        statusBar: map['status_bar'] ?? Defaults.homeStatusBar,
        backgroundUrl: map['background_url'] ?? Defaults.backgroundColor,
        logoField: map['logo_field'] != null
            ? LogoField.fromMap(map['logo_field'])
            : Defaults.homeLogoField,
        buttonField: map['botton_field'] != null
            ? ButtonField.fromMap(map['botton_field'])
            : Defaults.homeButtonField,
      );

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data['active'] = active;
    data['go_home_float_button'] = goHomeFloatButton;
    data['status_bar'] = statusBar;
    data['background_url'] = backgroundUrl;
    data['logo_field'] = logoField.toMap();
    data['botton_field'] = buttonField.toMap();
    return data;
  }
}

class LogoField {
  final String location;
  final EdgeInsets padding;
  final Size size;
  final String url;

  const LogoField({
    required this.location,
    required this.padding,
    required this.size,
    required this.url,
  });

  factory LogoField.fromMap(
    Map<String, dynamic> map,
  ) =>
      LogoField(
        location: map['location'] ?? Defaults.homeLogoField.location,
        padding: map["padding"] != null
            ? (map["padding"] as Map).toPadding
            : Defaults.homeLogoField.padding,
        size: map["size"] != null
            ? (map["size"] as Map).toSize
            : Defaults.homeLogoField.size,
        url: map['url'] ?? Defaults.homeLogoField.url,
      );

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data['location'] = location;
    data['padding'] = padding.toMap;
    data['size'] = size.toMap;
    data['url'] = url;
    return data;
  }
}

class ButtonField {
  final String location;
  final EdgeInsets padding;
  final Size size;
  final int horizontalButtonCount;
  final double horizontalButtonSpacing;
  final double verticalButtonSpacing;
  final double buttonAspectRatio;
  final List<HomeButton> buttons;

  const ButtonField({
    required this.location,
    required this.padding,
    required this.size,
    required this.horizontalButtonCount,
    required this.horizontalButtonSpacing,
    required this.verticalButtonSpacing,
    required this.buttonAspectRatio,
    required this.buttons,
  });

  factory ButtonField.fromMap(Map<String, dynamic> map) => ButtonField(
        location: map['location'] ?? Defaults.homeButtonField.location,
        padding: map["padding"] != null
            ? (map["padding"] as Map).toPadding
            : Defaults.homeButtonField.padding,
        size: map["size"] != null
            ? (map["size"] as Map).toSize
            : Defaults.homeButtonField.size,
        horizontalButtonCount: map['horizontal_button_count'] ??
            Defaults.homeButtonField.horizontalButtonCount,
        horizontalButtonSpacing: map['horizontal_button_spacing'] != null
            ? double.parse(map['horizontal_button_spacing'].toString())
            : Defaults.homeButtonField.horizontalButtonSpacing,
        verticalButtonSpacing: map['vertical_button_spacing'] != null
            ? double.parse(map['vertical_button_spacing'].toString())
            : Defaults.homeButtonField.verticalButtonSpacing,
        buttonAspectRatio: map['button_aspect_ratio'] != null
            ? double.parse(map['button_aspect_ratio'].toString())
            : Defaults.homeButtonField.buttonAspectRatio,
        buttons: map['buttons'] != null
            ? (map['buttons'] as List)
                .map((button) => HomeButton.fromMap(button))
                .cast<HomeButton>()
                .toList()
            : Defaults.homeButtonField.buttons,
      );

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data['location'] = location;
    data['padding'] = padding.toMap;
    data['size'] = size.toMap;
    data['horizontal_button_count'] = horizontalButtonCount;
    data['horizontal_button_spacing'] = horizontalButtonSpacing;
    data['vertical_button_spacing'] = verticalButtonSpacing;
    data['button_aspect_ratio'] = buttonAspectRatio;
    data['buttons'] = buttons.map((button) => button.toMap()).toList();
    return data;
  }
}

class HomeButton {
  final String title;
  final Color backgroundColor;
  final Color foregroundColor;
  final double iconSpacing;
  final IconData iconData;
  final String url;

  const HomeButton({
    required this.title,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.iconSpacing,
    required this.iconData,
    required this.url,
  });

  factory HomeButton.fromMap(Map<String, dynamic> map) => HomeButton(
        title: map['title'] ?? Defaults.homeButtonField.buttons[0].title,
        backgroundColor: map['background_color'] != null
            ? (map['background_color']).toString().toColor
            : Defaults.homeButtonField.buttons[0].backgroundColor,
        foregroundColor: map['foreground_color'] != null
            ? (map['foreground_color']).toString().toColor
            : Defaults.homeButtonField.buttons[0].foregroundColor
                .toString()
                .toColor,
        iconSpacing: map['icon_spacing'] != null
            ? double.parse(map['icon_spacing'].toString())
            : Defaults.homeButtonField.buttons[0].iconSpacing,
        iconData: (map["icon"] as Map).toIconData,
        url: map["url"] ?? Defaults.homeButtonField.buttons[0].url,
      );

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {};
    data['title'] = title;
    data['background_color'] = backgroundColor.getString();
    data['foreground_color'] = foregroundColor.getString();
    data['icon_spacing'] = iconSpacing;
    data['icon'] = iconData.toMap;
    data['url'] = url;

    return data;
  }
}

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../../extensions.dart';
import '../defaults.dart';

class BottomNavigationBarModel {
  final bool active;
  final NavBarStyle style;
  final int initialIndex;
  final bool listenWebview;
  final Color backgroundColor;
  final List<String> hideOnThisLinks;
  final List<NavbarItemProps> navbarItems;

  const BottomNavigationBarModel({
    required this.active,
    required this.style,
    required this.initialIndex,
    required this.backgroundColor,
    required this.listenWebview,
    required this.hideOnThisLinks,
    required this.navbarItems,
  });

  factory BottomNavigationBarModel.fromMap(Map map, Color primaryColor) {
    return BottomNavigationBarModel(
      active: map["active"] ?? Defaults.bottomNavigationBar.active,
      style: ((map["style_no"] ?? Defaults.bottomNavigationBar.style.toIndex)
              as int)
          .toNavbarStyle,
      initialIndex: (map["initial_index"] ??
          Defaults.bottomNavigationBar.initialIndex) as int,
      listenWebview:
          map["listen_webview"] ?? Defaults.bottomNavigationBar.listenWebview,
      backgroundColor: (map["background_color"] ??
              Defaults.bottomNavigationBar.backgroundColor.getString())
          .toString()
          .toColor,
      hideOnThisLinks: ((map["hide_on_this_urls"] ??
              Defaults.bottomNavigationBar.hideOnThisLinks) as List<dynamic>)
          .cast<String>(),
      navbarItems: ((map["navbar_items"] ?? []) as List<dynamic>)
          .map<NavbarItemProps>((item) {
        return NavbarItemProps.fromMap(item["item"], primaryColor);
      }).toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        "active": active,
        "style_no": style.toIndex,
        "initial_index": initialIndex,
        "listen_webview": listenWebview,
        "hide_on_this_urls": hideOnThisLinks,
        "navbar_items":
            navbarItems.map((item) => {"item": item.toMap()}).toList(),
      };
}

class NavbarItemProps {
  final String? title;
  final bool scrollToTop;
  final double? size;
  final String? url;
  final String? javascript;
  final IconData iconData;
  final Color? iconColor;
  final Color activeColorPrimary;
  final Color activeColorSecondary;
  final Color inactiveColorPrimary;
  final Color inactiveColorSecondary;

  const NavbarItemProps({
    required this.activeColorPrimary,
    required this.activeColorSecondary,
    required this.inactiveColorPrimary,
    required this.inactiveColorSecondary,
    required this.iconData,
    required this.scrollToTop,
    this.size,
    this.url,
    this.javascript,
    this.iconColor,
    this.title,
  });

  factory NavbarItemProps.fromMap(Map map, Color primaryColor) {
    return NavbarItemProps(
      title: map["title"] ?? Defaults.bottomNavigationBar.navbarItems[0].title,
      size: map["size"] != null ? (map["size"] as int).toDouble() : null,
      activeColorPrimary:
          map["active_color_primary"]?.toString().toColor ?? primaryColor,
      activeColorSecondary:
          map["active_color_secondary"]?.toString().toColor ?? primaryColor,
      inactiveColorPrimary: (map["inactive_color_primary"] ??
              Defaults.bottomNavigationBar.navbarItems[0].inactiveColorPrimary
                  .getString())
          .toString()
          .toColor,
      inactiveColorSecondary: (map["inactive_color_secondary"] ??
              Defaults.bottomNavigationBar.navbarItems[0].inactiveColorPrimary
                  .getString())
          .toString()
          .toColor,
      url: map["url"],
      javascript: map["javascript"] ??
          Defaults.bottomNavigationBar.navbarItems[0].javascript,
      scrollToTop: map["scroll_to_top"] ??
          Defaults.bottomNavigationBar.navbarItems[0].scrollToTop,
      iconColor: (map["icon"]?["color"])?.toString().toColor,
      iconData: (map["icon"] as Map).toIconData,
    );
  }

  Map<String, dynamic> toMap() => {
        "title": title,
        "size": size?.toInt(),
        "active_color_primary": activeColorPrimary.getString(),
        "active_color_secondary": activeColorSecondary.getString(),
        "inactive_color_primary": inactiveColorPrimary.getString(),
        "inactive_color_secondary": inactiveColorSecondary.getString(),
        "url": url,
        "javascript": javascript,
        "scroll_to_top": scrollToTop,
        "icon": {...iconData.toMap, "color": iconColor?.getString()},
      };
}

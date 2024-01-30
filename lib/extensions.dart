import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'core/remote_configuration/defaults.dart';
import 'core/remote_configuration/models/app_url_rules.dart';

import 'core/link_redirection/index.dart';
import 'globals.dart';
import 'core/remote_configuration/models/mobile_ads.dart';

extension StringExt on String {
  bool get isDeepLink {
    if (isInAppScheme) return false;

    var uri = Uri.parse(toString());

    return !["http", "https", "file", "chrome", "data", "javascript", "about"]
        .contains(uri.scheme);
  }

  bool get isInAppScheme {
    var uri = Uri.parse(toString());
    return ["feature", "route"].contains(uri.scheme);
  }

  AppURLRule get _toUrlRule {
    return Globals.configuration.urlRules.firstWhere(
      (urlRule) {
        RegExp regExp = RegExp(
          urlRule.url,
          caseSensitive: false,
          multiLine: false,
        );

        return regExp.hasMatch(toString());
      },
      orElse: () {
        return Defaults.urlRule;
      },
    );
  }

  bool get isInAppLink {
    debugPrint(
        'isInAppLink url: ${toString()}, rule: ${_toUrlRule.toMap().toString()}');
    return _toUrlRule.rule == "in";
  }

  bool get isExternalLink {
    return (isDeepLink || !isInAppLink);
  }

  URLRequest get toUrlRequest {
    return URLRequest(url: WebUri.uri(Uri.parse(toString())), headers: {
      "Firebase-Token": Globals.firebaseToken,
      "Login-User-ID": Globals.userId
    });
  }

  Color get toColor {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) buffer.write('ff');
    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  BannerAdLocation get toBannerAdLocation {
    switch (this) {
      case "top":
        return BannerAdLocation.top;
      case "bottom":
        return BannerAdLocation.bottom;
      case "both":
        return BannerAdLocation.both;
      default:
        return BannerAdLocation.none;
    }
  }

  bool get isURL {
    return startsWith("https") || startsWith("http");
  }

  bool get isFeature {
    return startsWith("feature");
  }

  bool get isRoute {
    return startsWith("route");
  }

  ImageProvider get toImageProvider {
    return (tr(this).isURL
        ? CachedNetworkImageProvider(tr(this))
        : AssetImage(tr(this))) as ImageProvider;
  }

  Alignment get toAlignment {
    switch (this) {
      case "top_left":
        return Alignment.topLeft;
      case "top_center":
        return Alignment.topCenter;
      case "top_right":
        return Alignment.topRight;
      case "center_left":
        return Alignment.centerLeft;
      case "center":
        return Alignment.center;
      case "center_right":
        return Alignment.centerRight;
      case "bottom_left":
        return Alignment.bottomLeft;
      case "bottom_center":
        return Alignment.bottomCenter;
      case "bottom_right":
        return Alignment.bottomRight;
      default:
        return Alignment.center;
    }
  }

  LinkRedirector? get toLinkRedirector {
    // link: https://google.com, feature://app_rating, route://login
    if (isFeature) {
      return FeatureLinkRedirect(this);
    } else if (isRoute) {
      return RouteLinkRedirect(this);
    } else if (isURL) {
      return URLLinkRedirect(this);
    }
    return null;
  }
}

extension AlignmentExt on Alignment {
  String getString() {
    if (this == Alignment.topLeft) {
      return "top_left";
    } else if (this == Alignment.topCenter) {
      return "top_center";
    } else if (this == Alignment.topRight) {
      return "top_right";
    } else if (this == Alignment.centerLeft) {
      return "center_left";
    } else if (this == Alignment.center) {
      return "center";
    } else if (this == Alignment.centerRight) {
      return "center_right";
    } else if (this == Alignment.bottomLeft) {
      return "bottom_left";
    } else if (this == Alignment.bottomCenter) {
      return "bottom_center";
    } else if (this == Alignment.bottomRight) {
      return "bottom_right";
    } else {
      return "center";
    }
  }
}

extension BannerAdLocationExt on BannerAdLocation {
  String getString() {
    switch (this) {
      case BannerAdLocation.top:
        return "top";
      case BannerAdLocation.bottom:
        return "bottom";
      case BannerAdLocation.both:
        return "both";
      default:
        return "none";
    }
  }
}

extension ColorExt on Color {
  String getString() {
    String valueString = toString().split('(0x')[1].split(')')[0];
    return "#${valueString.substring(2)}";
  }
}

extension NavBarStyleExt on NavBarStyle {
  int get toIndex {
    switch (this) {
      case NavBarStyle.style1:
        return 1;
      case NavBarStyle.style2:
        return 2;
      case NavBarStyle.style3:
        return 3;
      case NavBarStyle.style4:
        return 4;
      case NavBarStyle.style5:
        return 5;
      case NavBarStyle.style6:
        return 6;
      case NavBarStyle.style7:
        return 7;
      case NavBarStyle.style8:
        return 8;
      case NavBarStyle.style9:
        return 9;
      case NavBarStyle.style10:
        return 10;
      case NavBarStyle.style11:
        return 11;
      case NavBarStyle.style12:
        return 12;
      case NavBarStyle.style13:
        return 13;
      case NavBarStyle.style14:
        return 14;
      case NavBarStyle.style15:
        return 15;
      case NavBarStyle.style16:
        return 16;
      case NavBarStyle.style17:
        return 17;
      case NavBarStyle.style18:
        return 18;
      case NavBarStyle.neumorphic:
        return 19;
      case NavBarStyle.simple:
        return 20;

      default:
        return 20;
    }
  }
}

extension IntExt on int {
  NavBarStyle get toNavbarStyle {
    switch (this) {
      case 1:
        return NavBarStyle.style1;
      case 2:
        return NavBarStyle.style2;
      case 3:
        return NavBarStyle.style3;
      case 4:
        return NavBarStyle.style4;
      case 5:
        return NavBarStyle.style5;
      case 6:
        return NavBarStyle.style6;
      case 7:
        return NavBarStyle.style7;
      case 8:
        return NavBarStyle.style8;
      case 9:
        return NavBarStyle.style9;
      case 10:
        return NavBarStyle.style10;
      case 11:
        return NavBarStyle.style11;
      case 12:
        return NavBarStyle.style12;
      case 13:
        return NavBarStyle.style13;
      case 14:
        return NavBarStyle.style14;
      case 15:
        return NavBarStyle.style15;
      case 16:
        return NavBarStyle.style16;
      case 17:
        return NavBarStyle.style17;
      case 18:
        return NavBarStyle.style18;
      case 19:
        return NavBarStyle.neumorphic;
      case 20:
        return NavBarStyle.simple;

      default:
        return NavBarStyle.simple;
    }
  }
}

extension IconDataExt on IconData {
  IconData get returnDefaultIfNotValid {
    if (fontFamily == null) {
      return Icons.error;
    }

    return this;
  }

  Map<String, dynamic> get toMap => {
        "icon_code": codePoint,
        "font_family": fontFamily,
      };
}

extension MapExt on Map {
  String? findValue(String key) {
    if (isEmpty) {
      return null;
    }

    if (keys.contains(key)) {
      return this[key].toString();
    }

    for (var i = 0; i < values.length; i++) {
      dynamic value = values.toList()[i];
      if (value is Map) {
        dynamic keyValue = value.findValue(key);
        if (keyValue != null) return keyValue;
      }
    }

    return null;
  }

  EdgeInsets get toPadding => EdgeInsets.only(
        top: double.parse(this["top"].toString()),
        bottom: double.parse(this["bottom"].toString()),
        left: double.parse(this["left"].toString()),
        right: double.parse(this["right"].toString()),
      );

  Size get toSize => Size(double.parse(this["width"].toString()),
      double.parse(this["height"].toString()));

  IconData get toIconData => IconData(this["icon_code"],
          fontFamily: this["font_family"], fontPackage: "flutter_font_icons")
      .returnDefaultIfNotValid;
}

extension EdgeInsetsExt on EdgeInsets {
  Map<String, double> get toMap =>
      {"top": top, "bottom": bottom, "left": left, "right": right};
}

extension SizeExt on Size {
  Map<String, double> get toMap => {"width": width, "height": height};
}

extension SnackbarExt on SnackBar {
  SnackBar get toStandart {
    final snackBar = SnackBar(
      content: content,
      behavior: SnackBarBehavior.fixed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      dismissDirection: DismissDirection.down,
      duration: const Duration(seconds: 3),
    );
    return snackBar;
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../consts.dart';
import '../globals.dart';

bool isCookieSyncedFromLocal = false;

class AppCookieManager {
  final CookieManager _cookieManager = CookieManager.instance();

  List<String> get cookieToBeSynced => Globals.configuration.cookies;
  bool get _isActive => cookieToBeSynced.isNotEmpty;

  void saveToLocal() async {
    if (!_isActive) return;

    var cont = await Globals.inAppWebViewController.future;

    var webCookies = (await _cookieManager.getCookies(
            url: WebUri.uri(Globals.configuration.initialUri),
            webViewController: cont))
        .where((element) => cookieToBeSynced.contains(element.name))
        .toList();
    if (webCookies.isEmpty) return;
    var preference = await SharedPreferences.getInstance();

    var cookiesJson = jsonEncode(webCookies.map((e) => e.toJson()).toList());
    preference.setString(AppConsts.cookieKey, cookiesJson);
  }

  void syncWithLocal() async {
    var preference = await SharedPreferences.getInstance();

    if (!_isActive) {
      preference.remove(AppConsts.cookieKey);
      return;
    }

    var controller = await Globals.inAppWebViewController.future;

    if (!isCookieSyncedFromLocal) {
      var cookies = preference.getString(AppConsts.cookieKey);
      if (cookies != null) {
        var cookiesJson =
            (jsonDecode(cookies) as List<dynamic>).cast<Map<String, dynamic>>();

        for (var cookieJson in cookiesJson) {
          var cookie = Cookie.fromMap(cookieJson);
          if (cookie == null) continue;
          _cookieManager.setCookie(
            url: WebUri.uri(Globals.configuration.initialUri),
            name: cookie.name,
            value: cookie.value,
            isHttpOnly: cookie.isHttpOnly,
            isSecure: cookie.isSecure,
            domain: cookie.domain!,
          );
        }

        controller.reload();
      }
      isCookieSyncedFromLocal = true;
    }
  }

  void setEssentialCookies() async {
    await Globals.inAppWebViewController.future;
    _cookieManager.setCookie(
      url: WebUri.uri(Globals.configuration.initialUri),
      name: 'firebase-token',
      value: Globals.firebaseToken,
    );
    _cookieManager.setCookie(
      url: WebUri.uri(Globals.configuration.initialUri),
      name: "os",
      value: Platform.isAndroid ? "android" : "ios",
    );
  }
}

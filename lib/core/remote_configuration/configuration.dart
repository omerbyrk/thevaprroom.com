import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'models/app_url_rules.dart';
import 'models/shopping.dart';
import "package:yaml/yaml.dart";

import '../../consts.dart';
import 'defaults.dart';
import '../../extensions.dart';
import '../../globals.dart';
import 'fetch_remote_config.dart';
import 'models/app_bar.dart';
import 'models/app_rating.dart';
import 'models/app_sharing.dart';
import 'models/bottom_control_bar.dart';
import 'models/bottom_navigation_bar.dart';
import 'models/home.dart';
import 'models/loading_screen.dart';
import 'models/localization.dart';
import 'models/login.dart';
import 'models/login_auto_fill.dart';
import 'models/mobile_ads.dart';
import 'models/onboarding_screen.dart';
import 'models/preferences.dart';
import 'models/qr_code.dart';
import 'models/status_bar.dart';
import 'models/user_agent.dart';

class Configuration {
  late final bool useLocal;
  late final String configurationKey;

  late final int websiteVersion;
  late final int configFetchInterval;
  late final String _initialLink;
  late final Color _primaryColor;
  late final Color backgroundColor;
  late final List<String> _inAppLinks;
  late final StatusBarModel _statusbar;
  late final LoadingScreenModel _loadingScreen;
  late final UserAgentModel _userAgent;
  late final LoginAutoFillModel _loginAutoFill;
  late final AppRatingModel _appRating;
  late final QRCodeModel _qrCode;
  late final BottomControlBarModel _bottomControlBar;
  late final AppBarModel _appBar;
  late final PreferencesModel preferences;
  late final OnboardingScreenModel _onboardingScreen;
  late final BottomNavigationBarModel bottomNavigationBarProps;
  late final MobileAds mobileAds;
  late final Localization localization;
  late final HomeScreenModel homeScreen;
  late final LoginScreenModel loginScreen;
  late final AppSharingModel appSharing;
  late final ShoppingModel shopping;
  late final List<AppURLRule> _urlRules;
  late final List<String> cookies;

  final List<AppURLRule> _computedAppRules = [];

  Color get primaryColor => _primaryColor;

  LoadingScreenModel get loadingScreenModel => _loadingScreen;

  OnboardingScreenModel get onboardingScreenModel => _onboardingScreen;

  AppRatingModel get appRatingModel => _appRating;

  BottomControlBarModel get bottomControlBarModel => _bottomControlBar;

  AppBarModel get appBar => _appBar;

  QRCodeModel get qrCodeModel => _qrCode;

  String get userAgent =>
      Platform.isAndroid ? _userAgent.android : _userAgent.iOS;

  String get doomUsername =>
      "input[name='${_loginAutoFill.usernameInputName}']";
  String get doomPassword =>
      "input[name='${_loginAutoFill.passwordInputName}']";
  bool get autoFillActive => _loginAutoFill.active;

  Uri get initialUri => Uri.parse(_initialLink);

  String get initialLinkWithParameters {
    Uri uri = Uri.parse(_initialLink);

    Map<String, String> parameters = {};

    for (var key in uri.queryParameters.keys) {
      parameters[key] = uri.queryParameters[key]!;
    }

    if (preferences.addFirebaseTokenToInitialLink) {
      parameters["firebase_token"] = Globals.firebaseToken;
    }

    if (preferences.addLoginUserIdInitialLink) {
      parameters["login_user_id"] = Globals.userId;
    }

    final initialUri = Uri(
        scheme: uri.scheme,
        port: uri.port,
        userInfo: uri.userInfo,
        fragment: uri.fragment,
        host: uri.host,
        path: uri.path,
        queryParameters: parameters);

    var initialURL = initialUri.toString().replaceAll("#", "");

    if (initialURL.endsWith("?")) {
      initialURL = initialURL.substring(0, initialURL.length - 1);
    }

    return initialURL;
  }

  Color get statusBarColor => _statusbar.backgroundColor;
  Brightness get statusBarBrigtness => _statusbar.brightness;

  List<AppURLRule> get urlRules {
    if (_computedAppRules.isEmpty) {
      String hostname = Uri.parse(_initialLink).host;
      if (hostname.startsWith("www.")) {
        hostname = hostname.substring(4);
      }

      _computedAppRules
          .add(AppURLRule(url: "^https://$hostname", rule: "in", index: 1));
      _computedAppRules
          .add(AppURLRule(url: "^https://www.$hostname", rule: "in", index: 1));
      _computedAppRules
          .add(AppURLRule(url: "^http://$hostname", rule: "in", index: 1));
      _computedAppRules
          .add(AppURLRule(url: "^http://www.$hostname", rule: "in", index: 1));
      _computedAppRules.addAll(
          _inAppLinks.map((url) => AppURLRule(url: url, rule: "in", index: 2)));

      _computedAppRules.addAll(_urlRules);
      _computedAppRules.sort(((a, b) => a.index > b.index ? 1 : 0));
    }

    return _computedAppRules;
  }

  Configuration._();

  factory Configuration._fromMap(Map<String, dynamic> map,
      {bool useLocal = true, String configurationKey = "configuration"}) {
    Color primaryColor =
        (map["primary_color"] ?? Defaults.primaryColor).toString().toColor;
    return Configuration._()
      ..useLocal = useLocal
      ..configurationKey = configurationKey
      ..websiteVersion = map["website_version"]
      ..configFetchInterval = map["config_fetch_interval"]
      .._initialLink = map["initial_link"] ?? Defaults.initialLink
      .._primaryColor = primaryColor
      ..backgroundColor = (map["background_color"] ?? Defaults.backgroundColor)
          .toString()
          .toColor
      .._inAppLinks =
          ((map["in_app_links"] ?? Defaults.inAppLinks) as List<dynamic>)
              .cast<String>()
      ..cookies =
          ((map["cookies"] ?? Defaults.cookies) as List<dynamic>).cast<String>()
      .._statusbar = StatusBarModel.fromMap(map["status_bar"])
      .._loadingScreen = LoadingScreenModel.fromMap(map["loading_screen"])
      .._userAgent = UserAgentModel.fromMap(map["user_agent"])
      .._loginAutoFill = LoginAutoFillModel.fromMap(map["login_auto_fill"])
      .._appRating = AppRatingModel.fromMap(map["app_rating"])
      .._qrCode = QRCodeModel.fromMap(map["qr_code"])
      .._appBar = AppBarModel.fromMap(map["app_bar"])
      .._bottomControlBar =
          BottomControlBarModel.fromMap(map["bottom_control_bar"])
      ..preferences = PreferencesModel.fromMap(map["preferences"])
      .._onboardingScreen =
          OnboardingScreenModel.fromMap(map["onboarding_screen"])
      ..bottomNavigationBarProps = BottomNavigationBarModel.fromMap(
          map["bottom_navigation_bar"], primaryColor)
      ..mobileAds = MobileAds.fromMap(map["mobile_ads"])
      ..localization = Localization.fromMap(map["localization"])
      ..homeScreen = HomeScreenModel.fromMap(map["home_screen"])
      ..loginScreen = LoginScreenModel.fromMap(map["login_screen"])
      ..appSharing = AppSharingModel.fromMap(map["app_sharing"])
      ..shopping = ShoppingModel.fromMap(map["shopping"])
      .._urlRules = ((map["app_url_rules"] ?? []) as List<dynamic>)
          .map<AppURLRule>((item) {
        return AppURLRule.fromMap(item);
      }).toList();
  }

  Map<String, dynamic> toMap() => {
        "primary_color": _primaryColor.getString(),
        "website_version": websiteVersion,
        "config_fetch_interval": configFetchInterval,
        "initial_link": _initialLink,
        "in_app_links": _inAppLinks,
        "cookies": cookies,
        "status_bar": _statusbar.toMap(),
        "loading_screen": _loadingScreen.toMap(),
        "user_agent": _userAgent.toMap(),
        "login_auto_fill": _loginAutoFill.toMap(),
        "app_rating": _appRating.toMap(),
        "qr_code": _qrCode.toMap(),
        "bottom_control_bar": _bottomControlBar.toMap(),
        "app_bar": _appBar.toMap(),
        "preferences": preferences.toMap(),
        "onboarding_screen": _onboardingScreen.toMap(),
        "bottom_navigation_bar": bottomNavigationBarProps.toMap(),
        "mobile_ads": mobileAds.toMap(),
        "localization": localization.toMap(),
        "home_screen": homeScreen.toMap(),
        "login_screen": loginScreen.toMap(),
        "app_sharing": appSharing.toMap(),
        "shopping": shopping.toMap(),
        "app_url_rules": _urlRules.map((rule) => rule.toMap()).toList(),
      };

  static Future<Configuration> getInstanceFromFirebase() async {
    await FetchRemoteConfig.getInstance().fetchFromFirebase();
    String configuration = FetchRemoteConfig.getInstance().configuration;
    var buildConfiguration = await _buildConfiguration;
    return Configuration._fromMap(
      json.decode(configuration),
      useLocal: buildConfiguration["use_local"] as bool,
      configurationKey:
          buildConfiguration["firebase_configuration_key"] as String,
    );
  }

  static Future<Configuration> getInstanceFromLocal() async {
    Map<String, dynamic> map = await _localConfiguration;
    var buildConfiguration = await _buildConfiguration;
    return Configuration._fromMap(
      map,
      useLocal: buildConfiguration["use_local"] as bool,
      configurationKey:
          buildConfiguration["firebase_configuration_key"] as String,
    );
  }

  static Future<Map<String, dynamic>> get _localConfiguration async {
    var jsonText =
        await rootBundle.loadString(AppConsts.runtimeConfigurationPath);
    Map<String, dynamic> map =
        (json.decode(jsonText) as Map).cast<String, dynamic>();

    return map;
  }

  static Future<Map<String, dynamic>> get _buildConfiguration async {
    var yamlText =
        await rootBundle.loadString(AppConsts.buildConfigurationPath);

    return (loadYaml(yamlText) as YamlMap).cast<String, dynamic>();
  }
}

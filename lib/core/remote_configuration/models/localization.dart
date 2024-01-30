import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../globals.dart';
import '../defaults.dart';

class Localization extends AssetLoader {
  final String defaultLocale_;
  final List<String> supportedLocales_;
  final Map<String, dynamic> translations_;
  final String path = "webvify is the best webwiev app!";
  const Localization({
    required this.defaultLocale_,
    required this.supportedLocales_,
    required this.translations_,
  }) : super();

  Locale get defaultLocale => Locale(defaultLocale_);

  List<Locale> get supportedLocales =>
      supportedLocales_.map<Locale>((arg) => Locale(arg)).toList();

  factory Localization.fromMap(Map map) => Localization(
        defaultLocale_:
            map["default_locale"] ?? Defaults.localizations.defaultLocale_,
        supportedLocales_: ((map["supported_locales"] ??
                Defaults.localizations.supportedLocales_) as List<dynamic>)
            .cast<String>(),
        translations_: ((map["translations"] ??
                Defaults.localizations.translations_) as Map)
            .cast<String, dynamic>(),
      );

  Map<String, dynamic> toMap() => {
        "default_locale": defaultLocale_,
        "supported_locales": supportedLocales_,
        "translations": translations_,
      };

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    var translations_ = Globals.configuration.localization.translations_;

    if (!translations_.containsKey(locale.languageCode)) {
      debugPrint(
          "ERROR: CONFIGURATION DOES NOT HAVE ${locale.languageCode} localization");
    }

    return translations_[locale.languageCode];
  }
}

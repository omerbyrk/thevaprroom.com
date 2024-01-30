import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../defaults.dart';
import '../../../extensions.dart';

enum BannerAdLocation { top, bottom, both, none }

class MobileAds {
  final bool active;
  final List<String> keywords;
  final bool nonPersonalizedAds;
  final AppOpenAds appOpenAds;
  final BannerAds bannerAds;
  final InterstitialAds interstitialAds;

  const MobileAds({
    required this.active,
    required this.keywords,
    required this.nonPersonalizedAds,
    required this.appOpenAds,
    required this.bannerAds,
    required this.interstitialAds,
  });

  factory MobileAds.fromMap(Map<String, dynamic> json) {
    final active = json['active'] ?? Defaults.mobileAds.active;
    return MobileAds(
      active: active,
      keywords:
          ((json["keywords"] ?? Defaults.mobileAds.keywords) as List<dynamic>)
              .cast<String>(),
      appOpenAds: json['app_open_ads'] != null
          ? AppOpenAds.fromMap(json['app_open_ads'], active)
          : Defaults.mobileAds.appOpenAds,
      bannerAds: json['banner_ads'] != null
          ? BannerAds.fromMap(json['banner_ads'], active)
          : Defaults.mobileAds.bannerAds,
      interstitialAds: json['interstitial_ads'] != null
          ? InterstitialAds.fromMap(json['interstitial_ads'], active)
          : Defaults.mobileAds.interstitialAds,
      nonPersonalizedAds:
          json['non_personalized_ads'] ?? Defaults.mobileAds.nonPersonalizedAds,
    );
  }

  Map<String, dynamic> toMap() {
    final data = <String, dynamic>{};
    data['active'] = active;
    data['app_open_ads'] = appOpenAds.toMap();
    data['banner_ads'] = bannerAds.toMap();
    data['interstitial_ads'] = interstitialAds.toMap();
    data['keywords'] = keywords;
    data['non_personalized_ads'] = nonPersonalizedAds;
    return data;
  }

  get adRequest =>
      AdRequest(keywords: keywords, nonPersonalizedAds: nonPersonalizedAds);
}

class Ads {
  final bool active;
  final String iOSAdId;
  final String androidAdId;

  const Ads({
    this.active = false,
    this.iOSAdId = "",
    this.androidAdId = "",
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['active'] = active;
    data['iOS_ad_id'] = iOSAdId;
    data['android_ad_id'] = androidAdId;
    return data;
  }
}

class AppOpenAds extends Ads {
  final int maxCacheDuration;
  const AppOpenAds({
    required bool active,
    required String iOSAddId,
    required String androidAddId,
    required this.maxCacheDuration,
  }) : super(active: active, iOSAdId: iOSAddId, androidAdId: androidAddId);

  factory AppOpenAds.fromMap(Map<String, dynamic> json, bool argActive) =>
      AppOpenAds(
          active: argActive &&
              (json['active'] ?? Defaults.mobileAds.appOpenAds.active),
          iOSAddId: json['iOS_ad_id'] ?? Defaults.mobileAds.appOpenAds.iOSAdId,
          androidAddId: json['android_ad_id'] ??
              Defaults.mobileAds.appOpenAds.androidAdId,
          maxCacheDuration: json["max_cache_duration"] ??
              Defaults.mobileAds.appOpenAds.maxCacheDuration);

  @override
  Map<String, dynamic> toMap() {
    var data = super.toMap();
    data["max_cache_duration"] = maxCacheDuration;
    return data;
  }

  get appOpenId => Platform.isAndroid ? androidAdId : iOSAdId;
}

class BannerAds extends Ads {
  final BannerAdLocation location;
  const BannerAds({
    required bool active,
    required String iOSAddId,
    required String androidAddId,
    required this.location,
  }) : super(active: active, iOSAdId: iOSAddId, androidAdId: androidAddId);
  factory BannerAds.fromMap(Map<String, dynamic> json, bool argActive) =>
      BannerAds(
          active:
              argActive &&
                  (json['active'] ?? Defaults.mobileAds.bannerAds.active),
          iOSAddId: json['iOS_ad_id'] ?? Defaults.mobileAds.bannerAds.iOSAdId,
          androidAddId:
              json['android_ad_id'] ?? Defaults.mobileAds.bannerAds.androidAdId,
          location: (json['location'] ??
                  Defaults.mobileAds.bannerAds.location.getString())
              .toString()
              .toBannerAdLocation);

  @override
  Map<String, dynamic> toMap() {
    var data = super.toMap();
    data["location"] = location.getString();
    return data;
  }

  bool isLocationActive(BannerAdLocation argLocation) {
    // top, bottom
    if (!active || location == BannerAdLocation.none) {
      return false;
    }

    if (location == BannerAdLocation.both || location == argLocation) {
      return true;
    }

    return false;
  }

  get bannerId => Platform.isAndroid ? androidAdId : iOSAdId;
}

class InterstitialAds extends Ads {
  final int intervalDuration;
  final bool showClickOnBottomNavBar;

  const InterstitialAds({
    required bool active,
    required String iOSAddId,
    required String androidAddId,
    required this.intervalDuration,
    required this.showClickOnBottomNavBar,
  }) : super(active: active, iOSAdId: iOSAddId, androidAdId: androidAddId);
  factory InterstitialAds.fromMap(
          Map<String, dynamic> json, bool argActive) =>
      InterstitialAds(
          active:
              argActive &&
                  (json['active'] ?? Defaults.mobileAds.interstitialAds.active),
          iOSAddId:
              json['iOS_ad_id'] ?? Defaults.mobileAds.interstitialAds.iOSAdId,
          androidAddId: json['android_ad_id'] ??
              Defaults.mobileAds.interstitialAds.androidAdId,
          intervalDuration: json['interval_duration'] ??
              Defaults.mobileAds.interstitialAds.intervalDuration,
          showClickOnBottomNavBar: json['show_click_on_bottom_nav_bar'] ??
              Defaults.mobileAds.interstitialAds.showClickOnBottomNavBar);

  @override
  Map<String, dynamic> toMap() {
    var data = super.toMap();
    data["interval_duration"] = intervalDuration;
    data["show_click_on_bottom_nav_bar"] = showClickOnBottomNavBar;
    return data;
  }

  get interstitialId => Platform.isAndroid ? androidAdId : iOSAdId;
}

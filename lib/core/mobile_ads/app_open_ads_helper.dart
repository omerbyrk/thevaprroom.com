import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../globals.dart';
import '../app_helper.dart';
import '../remote_configuration/models/mobile_ads.dart';

class AppOpenAdsHelper {
  static AppOpenAds openAppAds = Globals.configuration.mobileAds.appOpenAds;

  static AppOpenAd? _appOpenAd;
  static bool _appStartShowed = false;

  /// Maximum duration allowed between loading and showing the ad.
  static Duration get _maxCacheDuration => Duration(
      seconds: Globals.configuration.mobileAds.appOpenAds.maxCacheDuration);

  /// Keep track of load time so we don't show an expired ad.
  static DateTime? _appOpenLoadTime;

  static void _loadAd() {
    if (!openAppAds.active) return;
    AppOpenAd.load(
      adUnitId: openAppAds.appOpenId,
      orientation: AppOpenAd.orientationPortrait,
      request: Globals.configuration.mobileAds.adRequest,
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) async {
          _appOpenLoadTime = DateTime.now();
          _appOpenAd = ad;
          _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint(error.toString());
              AppHelper.alertError(error, null);
              _dispose();
            },
            onAdDismissedFullScreenContent: (ad) {
              _dispose();
            },
          );
          await _appOpenAd!.show();
        },
        onAdFailedToLoad: (error) {
          debugPrint(error.toString());
          AppHelper.alertError(error, null);
          // Handle the error.
        },
      ),
    );
  }

  static void _dispose() {
    _appOpenAd?.dispose();
    _appOpenAd = null;
  }

  static void showOnAppOpen() async {
    await Future.delayed(const Duration(seconds: 1));

    if (_appStartShowed) {
      return;
    }

    _appStartShowed = true;
    _loadAd();
  }

  static void showOnAppResumed() async {
    await Future.delayed(const Duration(seconds: 1));

    if (_appOpenLoadTime != null &&
        DateTime.now().subtract(_maxCacheDuration).isAfter(_appOpenLoadTime!)) {
      debugPrint('Maximum cache duration exceeded. Loading another ad.');
      _loadAd();
      return;
    }
  }
}

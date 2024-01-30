import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../globals.dart';
import '../remote_configuration/models/mobile_ads.dart';
import '../app_helper.dart';

class InterstitialAdsHelper {
  static InterstitialAds get _interstitialAds =>
      Globals.configuration.mobileAds.interstitialAds;

  static InterstitialAd? _interstitialAd;
  static bool _isShowingAd = false;
  static Timer? _interstitialTimer;

  static void _loadAd() {
    InterstitialAd.load(
      adUnitId: _interstitialAds.interstitialId,
      request: Globals.configuration.mobileAds.adRequest,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) async {
          _interstitialAd = ad;
          _isShowingAd = true;

          // Set the fullScreenContentCallback and show the ad.
          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              dispose();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              AppHelper.alertError(
                error,
                null,
              );
              dispose();
            },
          );
          await _interstitialAd!.show();
        },
        onAdFailedToLoad: (LoadAdError error) {
          AppHelper.alertError(error, null);
        },
      ),
    );
  }

  static void dispose({bool timer = false}) {
    _isShowingAd = false;
    _interstitialAd = null;
    _interstitialAd?.dispose();
    if (timer) {
      _interstitialTimer?.cancel();
    }
  }

  static void showAdIfAvailable() async {
    if (!_interstitialAds.active) return;
    await Future.delayed(const Duration(seconds: 1));
    if (!_isAdAvailable) {
      _loadAd();
      return;
    }
    if (_isShowingAd) {
      return;
    }
  }

  static void onBottomNavBarClicked() {
    if (_interstitialAds.showClickOnBottomNavBar) {
      showAdIfAvailable();
    }
  }

  static void startInterval() async {
    if (_interstitialAds.active && _interstitialAds.intervalDuration <= 0) {
      return;
    }

    _interstitialTimer = Timer.periodic(
        Duration(seconds: _interstitialAds.intervalDuration), (timer) {
      showAdIfAvailable();
    });
  }

  static bool get _isAdAvailable {
    return _interstitialAd != null;
  }
}

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../core/app_helper.dart';
import '../core/remote_configuration/models/mobile_ads.dart';
import '../globals.dart';

class BannerAdWidget extends StatefulWidget {
  final BannerAdLocation location;

  const BannerAdWidget({Key? key, required this.location}) : super(key: key);

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  static BannerAds get _bannerAds => Globals.configuration.mobileAds.bannerAds;

  BannerAd? _anchoredAdaptiveAd;
  bool _isLoaded = false;

  @override
  void dispose() {
    super.dispose();
    _anchoredAdaptiveAd?.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) {
      _loadAd();
    }
  }

  bool get isActive =>
      _bannerAds.active &&
      _bannerAds.isLocationActive(widget.location) &&
      _anchoredAdaptiveAd != null &&
      _isLoaded;

  @override
  Widget build(BuildContext context) {
    return isActive
        ? Container(
            color: Colors.green,
            width: _anchoredAdaptiveAd!.size.width.toDouble(),
            height: _anchoredAdaptiveAd!.size.height.toDouble(),
            child: AdWidget(ad: _anchoredAdaptiveAd!),
          )
        : const SizedBox();
  }

  Future<void> _loadAd() async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      debugPrint('Unable to get height of anchored banner.');
      return;
    }

    _anchoredAdaptiveAd = BannerAd(
      adUnitId: _bannerAds.bannerId,
      size: size,
      request: Globals.configuration.mobileAds.adRequest,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('$ad loaded: ${ad.responseInfo}');
          setState(() {
            // When the ad is loaded, get the ad size and use it to set
            // the height of the ad container.
            _anchoredAdaptiveAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          AppHelper.alertError(
            error,
            null,
          );

          ad.dispose();
        },
      ),
    );
    return _anchoredAdaptiveAd!.load();
  }
}

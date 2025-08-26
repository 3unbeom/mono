import 'dart:async';
import 'dart:io';

import 'package:ads/src/models/ads_config.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared/shared.dart';

class AdsManager {
  AppOpenAd? _appOpenAd;
  final Map<String, InterstitialAd?> _interstitialAds = {};
  final AdsConfig config;

  AdsManager(this.config);

  Future<void> initialize() async {
    if (Platform.isIOS) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
    await MobileAds.instance.initialize();
  }

  Future<void> loadAppOpenAd({void Function()? onAdLoaded}) async {
    if (config.appOpenAdId == null) return;

    await AppOpenAd.load(
      adUnitId: config.appOpenAdId!,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          onAdLoaded?.call();
        },
        onAdFailedToLoad: (error) {
          Log.e('앱 오프닝 광고 로드 실패: ${error.message}');
          _appOpenAd = null;
        },
      ),
    );
  }

  Future<void> showAppOpenAd() async {
    if (_appOpenAd != null) {
      try {
        await _appOpenAd!.show();
      } catch (e) {
        Log.e('앱 오프닝 광고 표시 실패: $e');
      } finally {
        _appOpenAd = null;
      }
    }
  }

  bool get isAppOpenAdReady => _appOpenAd != null;

  Future<void> loadInterstitialAd(String adId) async {
    if (_interstitialAds[adId] != null) return;

    await InterstitialAd.load(
      adUnitId: adId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAds[adId] = ad,
        onAdFailedToLoad: (_) => _interstitialAds[adId] = null,
      ),
    );
  }

  Future<void> showInterstitialAd(String adId) async {
    if (_interstitialAds[adId] != null) {
      try {
        await _interstitialAds[adId]!.show();
      } catch (e) {
        Log.e('전면 광고 표시 실패 ($adId): $e');
      } finally {
        _interstitialAds[adId] = null;
      }
    }
  }

  void preloadInterstitialAds(List<String> adIds) {
    for (final adId in adIds) {
      loadInterstitialAd(adId);
    }
  }

  void dispose() {
    _appOpenAd?.dispose();
    for (final ad in _interstitialAds.values) {
      ad?.dispose();
    }
    _interstitialAds.clear();
  }
}

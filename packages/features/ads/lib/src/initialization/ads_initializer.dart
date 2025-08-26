import 'package:ads/ads.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

class AdsInitializer extends FeatureInitializer<AdsManager> {
  final AdsConfig adsConfig;
  
  AdsInitializer({
    required this.adsConfig,
  });
  
  @override
  Future<AdsManager> initialize() async {
    final manager = AdsManager(adsConfig);
    await manager.initialize();
    
    if (adsConfig.appOpenAdId != null && !kDebugMode) {
      manager.loadAppOpenAd(onAdLoaded: manager.showAppOpenAd);
    }
    
    return manager;
  }
}
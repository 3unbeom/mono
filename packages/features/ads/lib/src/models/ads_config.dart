class AdsConfig {
  final String? appOpenAdId;
  final Map<String, String> interstitialAdIds;

  const AdsConfig({this.appOpenAdId, this.interstitialAdIds = const {}});
}

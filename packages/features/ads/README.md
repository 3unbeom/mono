# Ads Feature

Google Mobile Ads를 사용한 광고 기능 패키지입니다.

## 기능

- 앱 오프닝 광고 (App Open Ad)
- 전면 광고 (Interstitial Ad)
- iOS App Tracking Transparency 자동 처리
- 광고 사전 로드 지원

## 사용법

### 1. 초기화

```dart
final adsManager = ref.read(adsManagerProvider);
await adsManager.initialize();
```

### 2. 앱 오프닝 광고

```dart
// 광고 로드
await adsManager.loadAppOpenAd('ca-app-pub-xxx/yyy');

// 광고 표시
await adsManager.showAppOpenAd();
```

### 3. 전면 광고

```dart
// 단일 광고 로드
await adsManager.loadInterstitialAd('ca-app-pub-xxx/yyy');

// 여러 광고 사전 로드
adsManager.preloadInterstitialAds([
  'ca-app-pub-xxx/yyy1',
  'ca-app-pub-xxx/yyy2',
]);

// 광고 표시
await adsManager.showInterstitialAd('ca-app-pub-xxx/yyy');
```

### 4. 리소스 정리

```dart
adsManager.dispose();
```

## 설정

### Android

`android/app/src/main/AndroidManifest.xml`:

```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-xxx~yyy"/>
```

### iOS

`ios/Runner/Info.plist`:

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-xxx~yyy</string>
<key>NSUserTrackingUsageDescription</key>
<string>This identifier will be used to deliver personalized ads to you.</string>
```

## 주의사항

- 광고 ID는 플랫폼별로 다르므로 적절한 ID를 사용해야 합니다
- iOS에서는 App Tracking Transparency 권한이 자동으로 요청됩니다
- 광고는 표시 후 자동으로 dispose되므로 재사용하려면 다시 로드해야 합니다
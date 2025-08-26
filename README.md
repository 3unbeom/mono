# Mono Repository Structure

이 문서는 mono 리포지토리의 패키지 구조와 각 패키지의 역할을 설명합니다.

## 아키텍처 개요

이 리포지토리는 Flutter 기반의 모노레포로, 공유 패키지와 여러 앱을 포함하고 있습니다.

- **상태 관리**: flutter_riverpod ^2.6.1
- **백엔드**: Supabase
- **패키지 관리**: Melos

## 패키지 구조

### Core Packages

#### 1. `packages/core`
- **목적**: 앱 초기화 및 핵심 기능 제공
- **주요 기능**:
  - 앱 초기화 (AppInitializer)
  - Supabase 클라이언트 관리
  - 사용자 인증 상태 관리
- **주요 의존성**:
  - flutter_riverpod: ^2.6.1
  - supabase_flutter: ^2.9.0

#### 2. `packages/shared`
- **목적**: 공통 UI 컴포넌트 및 유틸리티
- **주요 기능**:
  - 바텀시트 유틸리티
  - 사진 선택 바텀시트
  - 로거 유틸리티
  - 스낵바 유틸리티
- **주요 의존성**:
  - logger: ^2.6.1
  - image_picker: ^1.1.2

### Feature Packages

#### 1. `packages/features/activity`
- **목적**: 활동(운동) 기록 관리
- **주요 기능**:
  - Garmin 연동 (OAuth)
  - 활동 데이터 동기화
  - 활동 목록 표시
- **Supabase Functions**:
  - garmin-oauth-start
  - garmin-oauth-callback
  - garmin-push
  - garmin-deregistrations

#### 2. `packages/features/ads`
- **목적**: 광고 관리
- **주요 기능**:
  - Google AdMob 통합
  - 광고 표시 관리
  - 앱 추적 투명성
- **주요 의존성**:
  - google_mobile_ads: ^6.0.0
  - app_tracking_transparency: ^2.0.6+1

#### 3. `packages/features/auth`
- **목적**: 사용자 인증
- **주요 기능**:
  - Apple 로그인
  - 로그인/로그아웃 관리
  - 계정 삭제
- **주요 의존성**:
  - sign_in_with_apple: ^7.0.1
  - crypto: ^3.0.6

#### 4. `packages/features/iap`
- **목적**: 인앱 구매 관리
- **버전**: 0.0.1
- **주요 기능**:
  - RevenueCat 통합
  - 구독 관리
  - 프리미엄 상태 관리
- **주요 의존성**:
  - purchases_flutter: ^9.1.0

#### 5. `packages/features/notification`
- **목적**: 로컬 알림 관리
- **버전**: 1.0.0
- **주요 기능**:
  - 주기적 알림 설정
  - 타임존 기반 알림
- **주요 의존성**:
  - flutter_local_notifications: ^19.4.0
  - timezone: ^0.10.1

#### 6. `packages/features/profile`
- **목적**: 사용자 프로필 관리
- **주요 기능**:
  - 프로필 이미지 업로드
  - 닉네임 변경
  - 프로필 데이터 관리
- **주요 의존성**:
  - freezed_annotation: ^3.1.0
  - json_annotation: ^4.9.0

## 개발 가이드

### 패키지 의존성
모든 패키지는 다음 버전을 사용합니다:
- flutter_riverpod: ^2.6.1
- supabase_flutter: ^2.9.0 이상

### 코드 구조
- 각 feature 패키지는 독립적으로 작동
- core와 shared 패키지는 공통 기능 제공
- 앱은 필요한 feature 패키지를 선택적으로 사용

### Supabase 통합
- 각 feature 패키지는 필요한 경우 자체 Supabase 마이그레이션과 함수를 포함
- core 패키지가 Supabase 클라이언트 초기화를 관리

## 사용 가능한 Providers와 Widgets

### Core Package (`packages/core`)

#### Initializers
- **AppInitializer**: 범용 feature 초기화 도구
  - `initializeFeature<T>()`: feature 초기화 및 provider override 설정
  - `addOverride()`: provider override 추가
- **FeatureInitializer<T>**: feature 초기화 인터페이스
- **SupabaseInitializer**: Supabase 클라이언트 초기화

#### Providers
- **supabaseClientProvider**: `Provider<SupabaseClient>` - Supabase 클라이언트 인스턴스 제공
- **authStateChangeProvider**: `StreamProvider<AuthState>` - 인증 상태 변경 스트림
- **currentUserProvider**: `Provider<User?>` - 현재 인증된 사용자 정보
- **isSignedInProvider**: `Provider<bool>` - 로그인 상태 확인

### Shared Package (`packages/shared`)

#### Utility Functions
- **showStandardBottomSheet**: 표준화된 바텀시트를 표시하는 유틸리티 함수
  - 일관된 디자인 (둥근 모서리, SafeArea, 키보드 대응)
  - 커스터마이징 가능한 옵션들 제공

#### Utility Classes
- **BottomSheetButtonStyles**: 바텀시트용 표준 버튼 스타일
  - `primaryButton()`: Primary 액션 버튼 (ElevatedButton)
  - `secondaryButton()`: Secondary 액션 버튼 (OutlinedButton)
  - `dangerButton()`: 위험한 액션 버튼 (삭제 등)
  - `textButton()`: 텍스트 버튼 (취소 등)
- **Log**: 로깅 유틸리티 (릴리즈 모드에서 자동 비활성화)
  - `d()`: Debug 로그
  - `i()`: Info 로그
  - `w()`: Warning 로그
  - `e()`: Error 로그
  - `t()`: Trace 로그
- **SnackBarUtils**: 스낵바 표시 유틸리티
  - `showSnackBar()`: 기본 스낵바
  - `showErrorSnackBar()`: 에러 테마 스낵바
  - `showSuccessSnackBar()`: 성공 테마 스낵바

#### Widgets
- **PhotoSelectionBottomSheet**: 카메라 또는 갤러리에서 사진 선택하는 재사용 가능한 바텀시트
  - 단일/다중 이미지 선택 지원
  - 이미지 품질 및 크기 설정 가능

### Activity Package (`packages/features/activity`)

#### Models
- **Activity**: 활동 데이터 엔티티 (40+ 속성)
  - 기본 정보: id, startTime, endTime, type, distance, name
  - 피트니스 메트릭: calories, steps, heartRate 등
  - 디바이스 정보: deviceName, source, isWebUpload
  - JSONB 데이터: samples, laps, heartRateSamples, rawData

#### Services
- **OAuthService**: OAuth 서비스 인터페이스
  - `getAuthUrl()`: OAuth URL 생성
  - `isConnected()`: 연결 상태 확인
  - `disconnect()`: 연결 해제

#### Providers
- **garminOAuthServiceProvider**: `Provider<OAuthService>` - Garmin OAuth 서비스
- **activityRepositoryProvider**: `Provider<ActivityRepository>` - 활동 데이터 저장소
- **recentActivitiesProvider**: `FutureProvider.family<List<Activity>, int>` - 최근 활동 목록 조회
- **healthServiceOAuthProvider**: `Provider.family<OAuthService, HealthServiceType>` - 다양한 건강 서비스 OAuth 지원

#### Widgets
- **ActivityListScreen**: 최근 활동 목록을 표시하는 화면
- **GarminCallbackScreen**: Garmin OAuth 콜백 결과 화면
- **GarminConnectBottomSheet**: Garmin 연결을 시작하는 바텀시트

### Ads Package (`packages/features/ads`)

#### Models
- **AdsConfig**: 광고 설정
  - `appOpenAdId`: 앱 오픈 광고 ID
  - `interstitialAdIds`: 전면 광고 ID 목록

#### Managers
- **AdsManager**: 광고 관리자
  - 앱 오픈 광고: `loadAppOpenAd()`, `showAppOpenAd()`, `isAppOpenAdReady`
  - 전면 광고: `loadInterstitialAd()`, `showInterstitialAd()`, `preloadInterstitialAds()`
  - 라이프사이클: `initialize()`, `dispose()`

#### Initializers
- **AdsInitializer**: 광고 시스템 초기화
  - 앱 추적 투명성 처리
  - 앱 오픈 광고 자동 표시

#### Providers
- **adsManagerProvider**: `Provider<AdsManager>` - 광고 매니저 인스턴스 (앱에서 override 필요)

### Auth Package (`packages/features/auth`)

#### Models
- **LoginConfig**: 로그인 설정
  - `showKakaoLogin`: Kakao 로그인 표시 여부
  - `showAppleLogin`: Apple 로그인 표시 여부
  - `showTestLogin`: 테스트 로그인 표시 여부

#### Providers
- **authRepositoryProvider**: `Provider<AuthRepository>` - 인증 저장소 구현체
- **loginConfigProvider**: `Provider<LoginConfig>` - 로그인 설정 (앱별 override 필요)

#### Widgets
- **LoginBottomSheet**: Kakao 로그인 처리 바텀시트
- **LogoutBottomSheet**: 로그아웃 확인 및 처리 바텀시트
- **DeleteAccountBottomSheet**: 계정 삭제 확인 및 처리 바텀시트

### IAP Package (`packages/features/iap`)

#### Notifiers
- **CustomerInfoNotifier**: RevenueCat 고객 정보 관리
  - `purchasePackage()`: 패키지 구매
  - `restorePurchases()`: 구매 복원
  - 고객 정보 변경 시 자동 업데이트

#### Providers
- **customerInfoProvider**: `AutoDisposeAsyncNotifierProvider<CustomerInfoNotifier, CustomerInfo>` - 구매 정보 및 구매 작업 관리
- **currentOfferingPackagesProvider**: `FutureProvider.autoDispose<List<Package>>` - 구매 가능한 패키지 목록
- **isPremiumProvider**: `Provider.autoDispose<bool>` - 프리미엄 구독 상태
- **premiumExpirationDateProvider**: `Provider.autoDispose<DateTime?>` - 프리미엄 만료일

### Notification Package (`packages/features/notification`)

#### Managers
- **NotificationManager**: 로컬 알림 관리
  - 설정: `initialize()`, `requestPermissions()`
  - 스케줄링: `schedulePeriodicNotification()`, `scheduleDailyNotification()`, `scheduleWeeklyNotification()`
  - 관리: `showNotification()`, `cancelNotification()`, `cancelAllNotifications()`, `getPendingNotifications()`

#### Providers
- **notificationManagerProvider**: `Provider<NotificationManager>` - 알림 매니저 인스턴스
- **notificationInitializationProvider**: `FutureProvider.autoDispose<void>` - 알림 시스템 초기화
- **notificationPermissionProvider**: `FutureProvider.autoDispose<bool>` - 알림 권한 관리
- **pendingNotificationsProvider**: `FutureProvider.autoDispose<List<PendingNotificationRequest>>` - 대기 중인 알림 조회
- **notificationScheduleProvider**: `AutoDisposeAsyncNotifierProvider<NotificationScheduleNotifier, void>` - 알림 스케줄링 작업

### Profile Package (`packages/features/profile`)

#### Models
- **Profile**: 프로필 데이터 (Freezed)
  - `id`: 사용자 ID
  - `nickname`: 닉네임
  - `avatarUrl`: 아바타 이미지 URL
  - JSON 직렬화 지원

#### Providers
- **profileRepositoryProvider**: `Provider<ProfileRepository>` - 프로필 데이터 저장소
- **currentProfileProvider**: `FutureProvider<Profile>` - 현재 사용자 프로필 조회

#### Widgets
- **NicknameBottomSheet**: 닉네임 변경 바텀시트
- **ProfileImageBottomSheet**: 프로필 이미지 변경 바텀시트

## Provider 사용 예시

```dart
// 로그인 상태 확인
final isSignedIn = ref.watch(isSignedInProvider);

// 현재 사용자 정보 가져오기
final user = ref.watch(currentUserProvider);

// 최근 활동 10개 가져오기
final activities = await ref.read(recentActivitiesProvider(10).future);

// 프리미엄 상태 확인
final isPremium = ref.watch(isPremiumProvider);

// 알림 권한 확인
final hasPermission = await ref.read(notificationPermissionProvider.future);
```

## Widget 사용 예시

```dart
// 표준 바텀시트로 로그인 바텀시트 표시
await showStandardBottomSheet(
  context: context,
  builder: (context) => LoginBottomSheet(),
);

// 사진 선택 바텀시트 표시
final XFile? photo = await showStandardBottomSheet<XFile?>(
  context: context,
  builder: (context) => PhotoSelectionBottomSheet(),
);

// 바텀시트 내에서 표준 버튼 스타일 사용
ElevatedButton(
  style: BottomSheetButtonStyles.primaryButton(context),
  onPressed: () => Navigator.pop(context),
  child: Text('확인'),
);

OutlinedButton(
  style: BottomSheetButtonStyles.secondaryButton(context),
  onPressed: () => Navigator.pop(context),
  child: Text('취소'),
);

// 활동 목록 화면으로 이동
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => ActivityListScreen()),
);

// 로그 사용 예시
Log.d('Debug message');
Log.e('Error occurred', error: exception, stackTrace: stackTrace);

// 스낵바 사용 예시
SnackBarUtils.showSnackBar(context, '작업이 완료되었습니다');
SnackBarUtils.showErrorSnackBar(context, '오류가 발생했습니다');
SnackBarUtils.showSuccessSnackBar(context, '성공적으로 저장되었습니다');
```

## 린트 및 타입 체크 명령어
```bash
# Flutter 프로젝트의 경우
flutter analyze
flutter test

# Melos를 사용한 전체 프로젝트 관리
melos analyze
melos test
```
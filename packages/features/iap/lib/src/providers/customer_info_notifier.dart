import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared/shared.dart';

/// 프리미엄 권한 ID 상수
const String premiumEntitlementId = 'premium';

final customerInfoProvider =
    AutoDisposeAsyncNotifierProvider<CustomerInfoNotifier, CustomerInfo>(
      CustomerInfoNotifier.new,
    );

class CustomerInfoNotifier extends AutoDisposeAsyncNotifier<CustomerInfo> {
  void _onCustomerInfoUpdate(CustomerInfo info) {
    state = AsyncData(info);
  }

  @override
  Future<CustomerInfo> build() async {
    try {
      // 리스너 등록
      Purchases.addCustomerInfoUpdateListener(_onCustomerInfoUpdate);

      // 리스너 정리
      ref.onDispose(() {
        Purchases.removeCustomerInfoUpdateListener(_onCustomerInfoUpdate);
      });

      // 초기 고객 정보 로드
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo;
    } catch (e, s) {
      Log.e('Failed to load customer info', error: e, stackTrace: s);
      rethrow;
    }
  }

  /// 패키지 구매 실행
  Future<void> purchasePackage(Package package) async {
    state = const AsyncLoading();
    try {
      await Purchases.purchasePackage(package);
      // 리스너가 자동으로 상태 업데이트 처리
    } catch (e, s) {
      final error = e as PlatformException?;
      if (error?.code == PurchasesErrorCode.purchaseCancelledError.name) {
        Log.i('Purchase cancelled by user');
      } else {
        Log.e(
          'Purchase failed for package: ${package.identifier}',
          error: e,
          stackTrace: s,
        );
      }
      // 에러 발생 시 이전 상태 복원
      try {
        final customerInfo = await Purchases.getCustomerInfo();
        state = AsyncData(customerInfo);
      } catch (_) {
        // 상태 복원 실패 시 무시
      }
      rethrow;
    }
  }

  /// 구매 복원
  Future<void> restorePurchases() async {
    state = const AsyncLoading();
    try {
      final customerInfo = await Purchases.restorePurchases();
      state = AsyncData(customerInfo);
    } catch (e, s) {
      Log.e('Purchase restoration failed', error: e, stackTrace: s);
      // 에러 발생 시 이전 상태 복원
      try {
        final customerInfo = await Purchases.getCustomerInfo();
        state = AsyncData(customerInfo);
      } catch (_) {
        // 상태 복원 실패 시 무시
      }
      rethrow;
    }
  }
}

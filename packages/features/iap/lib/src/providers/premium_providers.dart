import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

import 'customer_info_notifier.dart';

/// 프리미엄 구독 여부를 확인하는 Provider
final isPremiumProvider = Provider.autoDispose<bool>((ref) {
  final customerInfo = ref.watch(customerInfoProvider);
  return customerInfo.maybeWhen(
    data: (info) => info.entitlements.active.containsKey(premiumEntitlementId),
    orElse: () => false,
  );
});

/// 프리미엄 구독 만료일을 반환하는 Provider
/// null: 구독하지 않음
/// DateTime: 구독 만료일
final premiumExpirationDateProvider = Provider.autoDispose<DateTime?>((ref) {
  final customerInfo = ref.watch(customerInfoProvider);
  
  return customerInfo.maybeWhen(
    data: (info) {
      final entitlement = info.entitlements.active[premiumEntitlementId];
      if (entitlement == null) {
        return null; // 구독하지 않음
      }
      
      final expirationDateString = entitlement.expirationDate;
      if (expirationDateString == null) {
        return null;
      }
      
      try {
        return DateTime.parse(expirationDateString);
      } catch (e) {
        Log.e('Failed to parse expiration date: $expirationDateString', error: e);
        return null;
      }
    },
    orElse: () => null,
  );
});
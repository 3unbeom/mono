import 'package:flutter/material.dart';

/// 스낵바 표시를 위한 유틸리티 클래스
class SnackBarUtils {
  /// 기본 스낵바를 표시합니다.
  ///
  /// 새로운 스낵바가 표시되기 전에 현재 표시된 스낵바는 즉시 제거됩니다.
  static void showSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2), // 기본 지속 시간 2초
    SnackBarAction? action,
  }) {
    // 현재 스낵바 제거
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    // 새 스낵바 표시
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
        behavior: SnackBarBehavior.floating,
        // 하단 플로팅 스타일
        margin: const EdgeInsets.all(16),
        // 플로팅 여백
        shape: RoundedRectangleBorder(
          // 모서리 둥글게
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// 오류 메시지 스낵바를 표시합니다. (배경색 강조)
  static void showErrorSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3), // 오류는 약간 더 길게
  }) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Theme.of(context).colorScheme.onError),
        ),
        duration: duration,
        backgroundColor: Theme.of(context).colorScheme.error,
        // 에러 색상 사용
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// 성공 메시지 스낵바를 표시합니다. (배경색 강조)
  static void showSuccessSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        // 예시: 흰색 텍스트
        duration: duration,
        backgroundColor: Colors.green[600],
        // 성공 색상 사용 (예시)
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

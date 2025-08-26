import 'package:flutter/material.dart';

/// 표준화된 BottomSheet를 표시하는 유틸리티 함수
/// 
/// 모든 앱에서 일관된 BottomSheet 디자인을 위해 이 함수를 사용하세요.
/// 
/// Example:
/// ```dart
/// await showStandardBottomSheet(
///   context: context,
///   builder: (context) => YourBottomSheetWidget(),
/// );
/// ```
Future<T?> showStandardBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isDismissible = true,
  bool enableDrag = true,
  bool showDragHandle = false,
  Color? backgroundColor,
  double? elevation,
  ShapeBorder? shape,
  Clip? clipBehavior,
  BoxConstraints? constraints,
  AnimationController? transitionAnimationController,
  RouteSettings? routeSettings,
}) {
  final theme = Theme.of(context);
  
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true, // 키보드 대응
    useRootNavigator: true, // 전역 네비게이터 사용
    useSafeArea: true, // SafeArea 적용
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    showDragHandle: showDragHandle,
    backgroundColor: backgroundColor ?? theme.colorScheme.surface,
    elevation: elevation,
    shape: shape ?? const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    clipBehavior: clipBehavior,
    constraints: constraints,
    transitionAnimationController: transitionAnimationController,
    routeSettings: routeSettings,
    builder: builder,
  );
}

/// 표준 BottomSheet 버튼 스타일을 제공하는 클래스
class BottomSheetButtonStyles {
  BottomSheetButtonStyles._();
  
  /// Primary 액션 버튼 스타일 (ElevatedButton용)
  static ButtonStyle primaryButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ElevatedButton.styleFrom(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      minimumSize: const Size(double.infinity, 56),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
    );
  }
  
  /// Secondary 액션 버튼 스타일 (OutlinedButton용)
  static ButtonStyle secondaryButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return OutlinedButton.styleFrom(
      minimumSize: const Size(double.infinity, 56),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      side: BorderSide(color: colorScheme.outline),
    );
  }
  
  /// 위험한 액션 버튼 스타일 (삭제 등)
  static ButtonStyle dangerButton(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ElevatedButton.styleFrom(
      backgroundColor: colorScheme.error,
      foregroundColor: colorScheme.onError,
      minimumSize: const Size(double.infinity, 56),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
    );
  }
  
  /// 텍스트 버튼 스타일 (취소 등)
  static ButtonStyle textButton(BuildContext context) {
    return TextButton.styleFrom(
      minimumSize: const Size(double.infinity, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
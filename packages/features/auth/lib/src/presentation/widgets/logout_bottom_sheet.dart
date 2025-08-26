import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

/// 로그아웃 바텀시트
class LogoutBottomSheet extends ConsumerStatefulWidget {
  const LogoutBottomSheet({super.key});

  /// 바텀시트 표시
  static Future<void> show({required BuildContext context}) {
    return showStandardBottomSheet(
      context: context,
      builder: (context) => const LogoutBottomSheet(),
    );
  }

  @override
  ConsumerState<LogoutBottomSheet> createState() => _LogoutBottomSheetState();
}

class _LogoutBottomSheetState extends ConsumerState<LogoutBottomSheet> {
  bool _isLoading = false;
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 아이콘
          Icon(Icons.logout_rounded, size: 48, color: colorScheme.primary),
          const SizedBox(height: 16),

          // 제목
          Text(
            '로그아웃',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // 설명
          Text(
            '정말로 로그아웃 하시겠습니까?',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          // 오류 메시지
          if (_errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _errorText!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 32),

          // 버튼 영역
          Row(
            children: [
              // 취소 버튼
              Expanded(
                child: OutlinedButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  style: BottomSheetButtonStyles.secondaryButton(context),
                  child: Text('취소', style: theme.textTheme.labelLarge),
                ),
              ),
              const SizedBox(width: 12),

              // 로그아웃 버튼
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _logout,
                  style: BottomSheetButtonStyles.primaryButton(context),
                  child: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.onPrimary,
                          ),
                        )
                      : Text(
                          '로그아웃',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colorScheme.onPrimary,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 로그아웃 처리
  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.signOut();

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorText = '로그아웃 처리 중 오류가 발생했습니다: $e';
      });
    }
  }
}

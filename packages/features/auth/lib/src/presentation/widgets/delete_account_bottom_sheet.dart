import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

/// 회원 탈퇴 바텀시트
class DeleteAccountBottomSheet extends ConsumerStatefulWidget {
  const DeleteAccountBottomSheet({super.key});

  /// 바텀시트 표시
  static Future<void> show({required BuildContext context}) {
    return showStandardBottomSheet(
      context: context,
      builder: (context) => const DeleteAccountBottomSheet(),
    );
  }

  @override
  ConsumerState<DeleteAccountBottomSheet> createState() =>
      _DeleteAccountBottomSheetState();
}

class _DeleteAccountBottomSheetState
    extends ConsumerState<DeleteAccountBottomSheet> {
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
          // 제목
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: colorScheme.error,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                '회원 탈퇴',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 경고 메시지 박스
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.error.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '정말로 탈퇴하시겠습니까?',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onErrorContainer,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '이 작업은 되돌릴 수 없으며, 모든 데이터가 삭제됩니다.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onErrorContainer,
                  ),
                ),
                const SizedBox(height: 16),
                // 부가 경고
                Text(
                  '• 모든 그룹 및 활동 기록이 삭제됩니다.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onErrorContainer.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '• 탈퇴 후에는 복구할 수 없습니다.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onErrorContainer.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
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

          const SizedBox(height: 24),

          // 버튼 영역
          Row(
            children: [
              // 취소 버튼
              Expanded(
                child: OutlinedButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: colorScheme.outline),
                  ),
                  child: Text('취소', style: theme.textTheme.labelLarge),
                ),
              ),
              const SizedBox(width: 12),

              // 탈퇴 버튼
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _deleteAccount,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onError,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.onError,
                          ),
                        )
                      : Text(
                          '탈퇴하기',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colorScheme.onError,
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

  /// 회원 탈퇴 처리
  Future<void> _deleteAccount() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    try {
      final repository = ref.read(authRepositoryProvider);
      final success = await repository.deleteAccount();

      if (success) {
        if (mounted) {
          Navigator.pop(context);
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorText = '회원 탈퇴 처리에 실패했습니다.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorText = '회원 탈퇴 처리 중 오류가 발생했습니다: $e';
      });
    }
  }
}

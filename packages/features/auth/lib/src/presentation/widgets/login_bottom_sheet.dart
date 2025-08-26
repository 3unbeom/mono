import 'dart:io';

import 'package:auth/auth.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginBottomSheet extends ConsumerStatefulWidget {
  const LoginBottomSheet({super.key});

  // 바텀시트를 표시하는 static 메서드
  static Future<void> show(BuildContext context) {
    return showStandardBottomSheet<void>(
      context: context,
      builder: (_) => const LoginBottomSheet(),
    );
  }

  @override
  ConsumerState<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends ConsumerState<LoginBottomSheet> {
  Future<void> _loginWithKakao() async {
    final repo = ref.read(authRepositoryProvider);
    try {
      await repo.signInWithKakao();
    } catch (e) {
      Log.e('카카오 로그인 실패: $e');
    }
  }

  Future<void> _loginWithApple() async {
    final repo = ref.read(authRepositoryProvider);
    try {
      await repo.signInWithApple();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('애플 로그인 실패: \\${e.toString()}')));
      }
    }
  }

  Future<void> _signInWithTestAccount() async {
    final repo = ref.read(authRepositoryProvider);
    try {
      await repo.signInWithEmail('test@for2w.com', '123456');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('테스트 로그인 중 오류가 발생했습니다: \\${e.toString()}')),
        );
      }
    }
  }

  Widget _buildKakaoLoginButton(LoginConfig config) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: _loginWithKakao,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFEE500),
            foregroundColor: Colors.black87,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.chat_bubble, size: 20),
              const SizedBox(width: 10),
              Text(
                '카카오로 시작하기',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final LoginConfig config = ref.watch(loginConfigProvider);

    ref.listen<AsyncValue<AuthState>>(authStateChangeProvider, (_, next) {
      final event = next.value?.event;
      final session = next.value?.session;

      Log.d('Auth Event: $event, Has Session: ${session != null}');

      if (next.value?.event == AuthChangeEvent.signedIn) {
        closeInAppWebView();
        if (mounted) {
          Navigator.of(context).pop();
        }
      }
    });
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      // 키보드 영역 확보
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 제목
            Text(
              '로그인',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '서비스를 이용하려면 로그인이 필요합니다',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),

            if (config.showKakaoLogin) _buildKakaoLoginButton(config),

            // 애플 로그인 버튼
            if (Platform.isIOS && config.showAppleLogin) ...[
              ElevatedButton(
                onPressed: _loginWithApple,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.onSurface,
                  foregroundColor: colorScheme.surface,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.apple, size: 24, color: colorScheme.surface),
                    const SizedBox(width: 10),
                    Text(
                      'Apple로 시작하기',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.surface,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // 테스트 로그인 버튼 (디버그 모드에서만 표시)
            if (kDebugMode)
              OutlinedButton(
                onPressed: _signInWithTestAccount,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: colorScheme.outline),
                ),
                child: Text('테스트 계정으로 로그인', style: theme.textTheme.labelLarge),
              ),

            // 하단 여백
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

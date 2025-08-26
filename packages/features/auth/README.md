# Auth Feature

이 패키지는 Supabase 기반의 인증(로그인/로그아웃) 기능을 제공하는 Flutter feature 모듈입니다.

- **이메일 로그인** (회원가입 불가)
- **소셜 로그인** (카카오, 구글, 애플 지원)
- **로그아웃**
- **계정 삭제** (Supabase Functions 기반)
- Riverpod 기반 Provider 구조
- 클린 아키텍처 분리(data/domain/presentation)

## 주요 구조

```
lib/
  auth.dart
  src/
    data/
      auth_repository_impl.dart
    domain/
      auth_repository.dart
    presentation/
      auth_provider.dart
      widgets/
        login_with_email_bottom_sheet.dart
        login_with_social_bottom_sheet.dart
        delete_account_bottom_sheet.dart
```

## 예제 사용법

```dart
import 'package:auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../lib/src/presentation/widgets/login_with_email_bottom_sheet.dart';
import '../../lib/src/presentation/widgets/login_with_social_bottom_sheet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final supabase = await Supabase.initialize(
    url: 'https://...supabase.co',
    anonKey: 'your-anon-key',
  );
  runApp(
    ProviderScope(
      overrides: [supabaseClientProvider.overrideWithValue(supabase.client)],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    return Scaffold(
      appBar: AppBar(title: const Text('Auth Feature Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user != null) Text('로그인된 유저: \nID: \\${user.id}'),
            if (user == null) const Text('로그인 필요'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => const LoginWithEmailBottomSheet(),
                );
              },
              child: const Text('이메일 로그인'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => const LoginWithSocialBottomSheet(),
                );
              },
              child: const Text('소셜 로그인'),
            ),
            const SizedBox(height: 24),
            if (user != null)
              ElevatedButton(
                onPressed: () async {
                  final repo = ref.read(authRepositoryProvider);
                  await repo.signOut();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('로그아웃 되었습니다.')),
                    );
                  }
                },
                child: const Text('로그아웃'),
              ),
            if (user != null)
              ElevatedButton(
                onPressed: () {
                  DeleteAccountBottomSheet.show(context: context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('계정 삭제'),
              ),
          ],
        ),
      ),
    );
  }
}
```

## 의존성
- flutter
- flutter_riverpod
- supabase_flutter

## 참고
- Supabase 공식 문서: https://supabase.com/docs
- Riverpod 공식 문서: https://riverpod.dev

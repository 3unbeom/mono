import 'dart:convert';

import 'package:auth/auth.dart';
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient client;

  AuthRepositoryImpl(this.client);

  @override
  Future<bool> signInWithEmail(String email, String password) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user != null;
    } catch (e) {
      throw AuthException('이메일 로그인 중 오류가 발생했습니다: $e');
    }
  }

  @override
  Future<bool> signInWithGoogle() async {
    try {
      final response = await client.auth.signInWithOAuth(OAuthProvider.google);
      return response;
    } catch (e) {
      throw AuthException('구글 로그인 중 오류가 발생했습니다: $e');
    }
  }

  @override
  Future<bool> signInWithKakao() async {
    try {
      final response = await client.auth.signInWithOAuth(OAuthProvider.kakao);
      return response;
    } catch (e) {
      throw AuthException('카카오 로그인 중 오류가 발생했습니다: $e');
    }
  }

  @override
  Future<bool> signInWithApple() async {
    final rawNonce = client.auth.generateRawNonce();
    final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: hashedNonce,
    );
    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthException(
        'Could not find ID Token from generated credential.',
      );
    }
    try {
      final response = await client.auth.signInWithIdToken(
        provider: OAuthProvider.apple,
        idToken: idToken,
        nonce: rawNonce,
      );
      return response.user != null;
    } catch (e) {
      throw AuthException('애플 로그인 중 오류가 발생했습니다: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  @override
  Future<bool> deleteAccount() async {
    try {
      final session = client.auth.currentSession;
      if (session == null) {
        throw AuthException('로그인이 필요합니다');
      }

      final response = await client.functions.invoke(
        'delete-account',
        body: jsonEncode({
          'access_token': session.accessToken,
          'refresh_token': session.refreshToken,
        }),
      );

      if (response.status == 200) {
        // 계정 삭제 성공 시 로그아웃 처리
        await signOut();
        return true;
      } else {
        throw AuthException('계정 삭제에 실패했습니다: ${response.data}');
      }
    } catch (e) {
      throw AuthException('계정 삭제 중 오류가 발생했습니다: $e');
    }
  }
}

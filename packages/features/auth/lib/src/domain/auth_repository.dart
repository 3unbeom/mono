abstract class AuthRepository {
  Future<bool> signInWithEmail(String email, String password);
  Future<bool> signInWithGoogle();
  Future<bool> signInWithKakao();
  Future<bool> signInWithApple();
  Future<void> signOut();
  Future<bool> deleteAccount();
}

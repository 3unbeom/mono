import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_client_provider.dart';

final authStateChangeProvider = StreamProvider<AuthState>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client.auth.onAuthStateChange;
});

final currentUserProvider = Provider<User?>((ref) {
  final asyncAuthState = ref.watch(authStateChangeProvider);
  return asyncAuthState.when(
    data: (authState) => authState.session?.user,
    error: (error, stackTrace) => null,
    loading: () => null,
  );
});

final isSignedInProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});

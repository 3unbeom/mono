import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/profile_repository_impl.dart';
import '../domain/profile_entity.dart';

final currentProfileProvider = FutureProvider<Profile>((ref) {
  final repo = ref.watch(profileRepositoryProvider);
  return repo.getCurrentProfile();
});

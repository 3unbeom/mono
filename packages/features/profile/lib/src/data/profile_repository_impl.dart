import 'dart:io';

import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/profile_entity.dart';
import '../domain/profile_repository.dart';

const removeProfileImageToken = 'REMOVE_PROFILE_IMAGE';

class ProfileRepositoryImpl implements ProfileRepository {
  final SupabaseClient client;
  final Ref ref;

  ProfileRepositoryImpl(this.client, this.ref);

  @override
  Future<Profile> getCurrentProfile() async {
    final user = client.auth.currentUser;
    if (user == null) {
      throw Exception('로그인이 필요합니다.');
    }

    final response = await client
        .from('profiles')
        .select('*')
        .eq('id', user.id)
        .single();
    return Profile.fromJson(response);
  }

  @override
  Future<bool> updateNickname(String nickname) async {
    final user = client.auth.currentUser;
    if (user == null) return false;

    try {
      await client
          .from('profiles')
          .update({'display_name': nickname})
          .eq('id', user.id);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateProfileImage(String imagePath) async {
    final user = client.auth.currentUser;
    if (user == null) return false;

    try {
      if (imagePath == removeProfileImageToken) {
        final profile = await getCurrentProfile();
        final oldAvatarUrl = profile.avatarUrl;
        if (oldAvatarUrl != null) {
          final filePath = oldAvatarUrl.split('/').last;
          try {
            await client.storage.from('avatars').remove([filePath]);
          } catch (_) {}
        }
        await client
            .from('profiles')
            .update({'avatar_url': null})
            .eq('id', user.id);
        return true;
      }

      final file = File(imagePath);
      if (!file.existsSync()) return false;

      final ext = imagePath.split('.').last;
      final fileName =
          '${user.id}_${DateTime.now().millisecondsSinceEpoch}.$ext';

      await client.storage.from('avatars').upload(fileName, file);
      final imageUrl = client.storage.from('avatars').getPublicUrl(fileName);
      await client
          .from('profiles')
          .update({'avatar_url': imageUrl})
          .eq('id', user.id);
      return true;
    } catch (e) {
      return false;
    }
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return ProfileRepositoryImpl(client, ref);
});

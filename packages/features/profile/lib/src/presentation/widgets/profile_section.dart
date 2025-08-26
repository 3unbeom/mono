import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profile/profile.dart';

class ProfileSection extends ConsumerWidget {
  final VoidCallback? onLoginPressed;

  const ProfileSection({
    super.key,
    this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final profileAsync = ref.watch(currentProfileProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 로그인한 경우에만 프로필 섹션 표시
        if (user?.id != null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '프로필',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildProfileAvatar(theme, user, profileAsync),
                    const SizedBox(width: 16),
                    Expanded(child: _buildProfileInfo(theme, user, profileAsync)),
                  ],
                ),
              ],
            ),
          ),
        // 로그인하지 않은 경우 로그인 버튼 표시
        if (user?.id == null && onLoginPressed != null)
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('로그인 / 회원가입'),
            trailing: Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            onTap: onLoginPressed,
          ),
        // 로그인한 경우 프로필 편집 버튼들 표시
        if (user?.id != null) ...[
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('닉네임 변경'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showNicknameBottomSheet(context),
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('사진 변경'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showProfileImageBottomSheet(context),
          ),
        ],
      ],
    );
  }

  Widget _buildProfileAvatar(
    ThemeData theme,
    dynamic user,
    AsyncValue<Profile> profileAsync,
  ) {
    if (user?.id == null) {
      return CircleAvatar(
        radius: 30,
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.person_outline,
          size: 30,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    }

    return profileAsync.when(
      data: (profile) {
        if (profile.avatarUrl != null) {
          return CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(profile.avatarUrl!),
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
          );
        }
        return CircleAvatar(
          radius: 30,
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.person,
            size: 30,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        );
      },
      loading: () => CircleAvatar(
        radius: 30,
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        child: const CircularProgressIndicator(),
      ),
      error: (_, __) => CircleAvatar(
        radius: 30,
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        child: Icon(
          Icons.person,
          size: 30,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  Widget _buildProfileInfo(
    ThemeData theme,
    dynamic user,
    AsyncValue<Profile> profileAsync,
  ) {
    return profileAsync.when(
      data: (profile) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            profile.displayName ?? user?.email ?? '사용자',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      loading: () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '로딩 중...',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '프로필 정보를 불러오는 중입니다',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      error: (_, __) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            user?.email ?? '사용자',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showNicknameBottomSheet(BuildContext context) {
    NicknameBottomSheet.show(context: context);
  }

  void _showProfileImageBottomSheet(BuildContext context) {
    ProfileImageBottomSheet.show(context: context);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared/shared.dart';

import '../../data/profile_repository_impl.dart';
import '../profile_provider.dart';

/// 프로필 이미지 변경을 위한 바텀시트
class ProfileImageBottomSheet extends ConsumerWidget {
  const ProfileImageBottomSheet({super.key});

  static Future<void> show({required BuildContext context}) {
    return showStandardBottomSheet(
      context: context,
      builder: (context) => const ProfileImageBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 제목
          Text(
            '프로필 사진 변경',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // 설명
          Text(
            '새로운 프로필 사진을 선택하거나 현재 사진을 삭제할 수 있습니다.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // 카메라 버튼
          OutlinedButton(
            onPressed: () =>
                _pickAndUpdateImage(context, ref, ImageSource.camera),
            style: BottomSheetButtonStyles.secondaryButton(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.photo_camera, size: 24),
                const SizedBox(width: 12),
                Text(
                  '카메라로 촬영',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 갤러리 버튼
          OutlinedButton(
            onPressed: () =>
                _pickAndUpdateImage(context, ref, ImageSource.gallery),
            style: BottomSheetButtonStyles.secondaryButton(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo_library, size: 24, color: colorScheme.primary),
                const SizedBox(width: 12),
                Text('갤러리에서 선택', style: theme.textTheme.labelLarge),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 프로필 사진 삭제 버튼
          OutlinedButton(
            onPressed: () => _removeProfileImage(context, ref),
            style: BottomSheetButtonStyles.secondaryButton(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.delete_outline, size: 24),
                const SizedBox(width: 12),
                Text(
                  '프로필 사진 삭제',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickAndUpdateImage(
    BuildContext context,
    WidgetRef ref,
    ImageSource source,
  ) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (pickedFile != null && context.mounted) {
        // 프로필 이미지 업데이트
        final repo = ref.read(profileRepositoryProvider);
        final success = await repo.updateProfileImage(pickedFile.path);

        if (context.mounted) {
          Navigator.pop(context);

          if (success) {
            ref.invalidate(currentProfileProvider);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('프로필 사진이 변경되었습니다.')));
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('프로필 사진 변경에 실패했습니다.')));
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이미지를 가져오는 중 오류가 발생했습니다.')),
        );
      }
    }
  }

  Future<void> _removeProfileImage(BuildContext context, WidgetRef ref) async {
    try {
      final repo = ref.read(profileRepositoryProvider);
      final success = await repo.updateProfileImage(removeProfileImageToken);

      if (context.mounted) {
        Navigator.pop(context);

        if (success) {
          ref.invalidate(currentProfileProvider);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('프로필 사진이 삭제되었습니다.')));
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('프로필 사진 삭제에 실패했습니다.')));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('프로필 사진 삭제 중 오류가 발생했습니다.')),
        );
      }
    }
  }
}

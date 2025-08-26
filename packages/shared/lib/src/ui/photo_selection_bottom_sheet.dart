import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared/src/ui/bottom_sheet_utils.dart';

/// 사진 선택 바텀시트
///
/// 카메라 촬영 또는 갤러리에서 이미지를 선택할 수 있는 표준 바텀시트입니다.
///
/// Example:
/// ```dart
/// // 단일 선택 (기본값)
/// final images = await PhotoSelectionBottomSheet.show(context: context);
/// if (images != null && images.isNotEmpty) {
///   final image = images.first;
///   // 선택된 이미지 사용
/// }
///
/// // 해상도 설정과 함께 단일 선택
/// final images = await PhotoSelectionBottomSheet.show(
///   context: context,
///   maxSize: 1280,      // 가로, 세로 최대 크기
///   imageQuality: 70,   // 이미지 품질 (0-100)
/// );
///
/// // 복수 선택
/// final images = await PhotoSelectionBottomSheet.show(
///   context: context,
///   maxImages: 5,       // null이면 단일 선택
///   maxSize: 1920,      // 기본값
///   imageQuality: 85,   // 기본값
/// );
/// ```
class PhotoSelectionBottomSheet extends StatelessWidget {
  const PhotoSelectionBottomSheet({
    super.key,
    this.allowMultiple = false,
    this.maxImages,
    this.maxSize = 1920,
    this.imageQuality = 85,
  });

  final bool allowMultiple;
  final int? maxImages;
  final double maxSize;
  final int imageQuality;

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
          Text(
            '사진 선택',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // 설명
          Text(
            '사진을 추가할 방법을 선택하세요',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // 카메라 버튼
          OutlinedButton(
            onPressed: () async {
              final image = await _pickImage(ImageSource.camera);
              if (context.mounted) {
                // 항상 리스트로 반환
                Navigator.pop(context, image != null ? [image] : null);
              }
            },
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
            onPressed: () async {
              // maxImages가 1인 경우 단일 선택 피커 사용
              if (allowMultiple && maxImages != 1) {
                final images = await _pickMultipleImages();
                if (context.mounted) {
                  Navigator.pop(context, images);
                }
              } else {
                final image = await _pickImage(ImageSource.gallery);
                if (context.mounted) {
                  // 항상 리스트로 반환
                  Navigator.pop(context, image != null ? [image] : null);
                }
              }
            },
            style: BottomSheetButtonStyles.secondaryButton(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo_library, size: 24, color: colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  allowMultiple && maxImages != null
                      ? '갤러리에서 선택 (최대 $maxImages장)'
                      : '갤러리에서 선택',
                  style: theme.textTheme.labelLarge,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 취소 버튼
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: BottomSheetButtonStyles.textButton(context),
            child: Text(
              '취소',
              style: theme.textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<File?> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: maxSize,
        maxHeight: maxSize,
        imageQuality: imageQuality,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image: $e');
      return null;
    }
  }

  Future<List<File>?> _pickMultipleImages() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage(
        maxWidth: maxSize,
        maxHeight: maxSize,
        imageQuality: imageQuality,
        limit: maxImages,
      );

      if (images.isNotEmpty) {
        return images.map((image) => File(image.path)).toList();
      }
      return null;
    } catch (e) {
      debugPrint('Error picking multiple images: $e');
      return null;
    }
  }

  /// 사진 선택 바텀시트를 표시하고 선택된 이미지를 반환합니다.
  /// maxImages가 null이면 단일 선택, 값이 있으면 복수 선택
  static Future<List<File>?> show({
    required BuildContext context,
    int? maxImages,
    double maxSize = 1920,
    int imageQuality = 85,
  }) async {
    return showStandardBottomSheet<List<File>?>(
      context: context,
      builder: (context) => PhotoSelectionBottomSheet(
        allowMultiple: maxImages != null,
        maxImages: maxImages,
        maxSize: maxSize,
        imageQuality: imageQuality,
      ),
    );
  }
}

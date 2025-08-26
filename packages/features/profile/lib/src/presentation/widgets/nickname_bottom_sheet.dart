import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/profile_repository_impl.dart';
import '../profile_provider.dart';

/// 닉네임 변경 바텀시트
class NicknameBottomSheet extends ConsumerStatefulWidget {
  const NicknameBottomSheet({super.key});

  static Future<void> show({required BuildContext context}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      useSafeArea: true,
      builder: (context) => const NicknameBottomSheet(),
    );
  }

  @override
  ConsumerState<NicknameBottomSheet> createState() =>
      _NicknameBottomSheetState();
}

class _NicknameBottomSheetState extends ConsumerState<NicknameBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  String? _errorText;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(currentProfileProvider);

    return profileAsync.when(
      loading: () => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Center(child: Text('프로필을 불러올 수 없습니다: $error')),
      ),
      data: (profile) {
        // 첫 번째 로드 시에만 현재 닉네임 설정
        if (!_isInitialized && profile.displayName != null) {
          _controller.text = profile.displayName!;
          _isInitialized = true;
        }

        return _buildContent(context);
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '닉네임 변경',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '다른 사용자들이 나를 식별할 수 있는 닉네임을 설정하세요.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: '새 닉네임',
              hintText: '새로운 닉네임을 입력하세요',
              errorText: _errorText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.person),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        setState(() {});
                      },
                    )
                  : null,
            ),
            onChanged: (_) => setState(() {}),
            enabled: !_isLoading,
            autofocus: true,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('취소'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isLoading || _controller.text.trim().isEmpty
                      ? null
                      : _updateNickname,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('변경'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _updateNickname() async {
    final newNickname = _controller.text.trim();
    if (newNickname.isEmpty) {
      setState(() => _errorText = '닉네임을 입력해주세요');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });
    try {
      final repo = ref.read(profileRepositoryProvider);
      final result = await repo.updateNickname(newNickname);
      if (result) {
        ref.invalidate(currentProfileProvider);
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('닉네임이 변경되었습니다.')));
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorText = '닉네임 변경에 실패했습니다.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorText = '닉네임 변경 중 오류가 발생했습니다: $e';
      });
    }
  }
}

import 'package:core/src/initialization/feature_initializer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 앱 초기화를 담당하는 클래스
class AppInitializer {
  final List<Override> _overrides = [];
  
  /// Feature 초기화 (제네릭)
  Future<T> initializeFeature<T>({
    required FeatureInitializer<T> initializer,
    required Provider<T> provider,
  }) async {
    final instance = await initializer.initialize();
    _overrides.add(provider.overrideWithValue(instance));
    return instance;
  }
  
  /// 모든 초기화 완료 후 Provider overrides 반환
  List<Override> get overrides => List.unmodifiable(_overrides);
  
  /// 추가 override 수동 추가
  void addOverride(Override override) {
    _overrides.add(override);
  }
}


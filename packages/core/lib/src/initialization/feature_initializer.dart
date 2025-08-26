/// Feature 초기화를 위한 통일된 인터페이스
abstract class FeatureInitializer<T> {
  /// Feature를 초기화하고 초기화된 인스턴스를 반환
  Future<T> initialize();
}
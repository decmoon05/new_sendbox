/// 의존성 주입 컨테이너 (Riverpod 기반)
/// 
/// 주의: Riverpod을 사용하므로 이 파일은 향후 확장용으로 유지됩니다.
/// 대부분의 의존성은 Riverpod Provider로 관리됩니다.

class InjectionContainer {
  InjectionContainer._();

  /// 초기화 (필요시)
  static Future<void> init() async {
    // 향후 필요한 초기화 로직 추가
  }

  /// 리소스 정리 (필요시)
  static Future<void> dispose() async {
    // 향후 필요한 정리 로직 추가
  }
}


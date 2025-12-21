import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../domain/entities/contact_profile.dart';
import '../../../../../domain/repositories/profile_repository.dart';
import '../../../../../core/di/providers.dart';

/// 프로필 검색 상태
class ProfileSearchState {
  final List<ContactProfile> results;
  final bool isSearching;
  final String? error;
  final String query;

  const ProfileSearchState({
    this.results = const [],
    this.isSearching = false,
    this.error,
    this.query = '',
  });

  ProfileSearchState copyWith({
    List<ContactProfile>? results,
    bool? isSearching,
    String? error,
    String? query,
  }) {
    return ProfileSearchState(
      results: results ?? this.results,
      isSearching: isSearching ?? this.isSearching,
      error: error,
      query: query ?? this.query,
    );
  }
}

/// 프로필 검색 Provider
final profileSearchProvider = StateNotifierProvider<ProfileSearchNotifier, ProfileSearchState>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return ProfileSearchNotifier(repository: repository);
});

/// 프로필 검색 Notifier
class ProfileSearchNotifier extends StateNotifier<ProfileSearchState> {
  final ProfileRepository repository;

  ProfileSearchNotifier({
    required this.repository,
  }) : super(const ProfileSearchState());

  /// 검색 실행
  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = state.copyWith(
        results: [],
        query: '',
        isSearching: false,
      );
      return;
    }

    state = state.copyWith(
      isSearching: true,
      query: query.trim(),
      error: null,
    );

    final result = await repository.searchProfiles(query.trim());

    result.fold(
      (failure) => state = state.copyWith(
        isSearching: false,
        error: failure.message,
        results: [],
      ),
      (profiles) => state = state.copyWith(
        isSearching: false,
        results: profiles,
        error: null,
      ),
    );
  }

  /// 검색 초기화
  void clear() {
    state = const ProfileSearchState();
  }
}


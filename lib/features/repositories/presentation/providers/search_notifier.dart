import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/repository.dart';
import 'repository_providers.dart';

class SearchState {
  final List<Repository> repositories;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final String query;
  final int page;
  final bool hasMore;

  const SearchState({
    this.repositories = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.query = '',
    this.page = 1,
    this.hasMore = true,
  });

  SearchState copyWith({
    List<Repository>? repositories,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    String? query,
    int? page,
    bool? hasMore,
  }) {
    return SearchState(
      repositories: repositories ?? this.repositories,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
      query: query ?? this.query,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  final Ref ref;

  SearchNotifier(this.ref) : super(const SearchState());

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const SearchState(repositories: [], isLoading: false, query: '');
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null, query: query, page: 1, hasMore: true);

    try {
      final repoFunctions = await ref.read(repositoryFunctionsProvider.future);
      final result = await repoFunctions.searchRepositories(query);

      result.fold(
            (failure) => state = state.copyWith(isLoading: false, errorMessage: failure.message),
            (repos) => state = state.copyWith(isLoading: false, repositories: repos, hasMore: repos.length >= 20),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.query.trim().isEmpty) return;

    state = state.copyWith(isLoadingMore: true);
    final nextPage = state.page + 1;

    try {
      final repoFunctions = await ref.read(repositoryFunctionsProvider.future);
      final result = await repoFunctions.searchRepositories(state.query, page: nextPage);

      result.fold(
            (failure) => state = state.copyWith(isLoadingMore: false, errorMessage: failure.message),
            (repos) => state = state.copyWith(
          isLoadingMore: false,
          repositories: [...state.repositories, ...repos],
          page: nextPage,
          hasMore: repos.length >= 20,
        ),
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, errorMessage: e.toString());
    }
  }
}

final searchNotifierProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(ref);
});

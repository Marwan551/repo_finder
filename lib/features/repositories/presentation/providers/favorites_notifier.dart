import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/repository.dart';
import 'repository_providers.dart';

class FavoriteState{
  final List<Repository> favorites;
  final bool isLoading;
  final String hasError;

  const FavoriteState({
     this.favorites = const [],
     this.isLoading = false,
     this.hasError = '',
  });

  FavoriteState copyWith({
    List<Repository>? favorites,
    bool? isLoading,
    String? hasError,
  }) {
    return FavoriteState(
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
    );
  }
}

class FavoritesNotifierProvider extends StateNotifier<FavoriteState>{

  final Ref ref;
  FavoritesNotifierProvider(this.ref) : super(const FavoriteState()){
    loadFavorites();
  }

  Future<void> loadFavorites() async{
    state = state.copyWith(isLoading: true,hasError: null);
    try{
      final repoFunctions = await ref.read(repositoryFunctionsProvider.future);
      final result = await repoFunctions.getFavorites();
      result.fold(
          (failure) => state = state.copyWith(isLoading: false,hasError: failure.message),
          (favorites) => state = state.copyWith(isLoading: false,favorites: favorites),
      );
    }catch(e){
      state = state.copyWith(isLoading: false,hasError: e.toString());
    }
  }

  Future<void> toggle(Repository repo) async{
    try{
     final repoFunctions = await ref.read(repositoryFunctionsProvider.future);
     final reslt = await repoFunctions.toggleFavorite(repo);
     reslt.fold(
         (failure) => state = state.copyWith(hasError: failure.message),
         (_) => loadFavorites(),
     );

    }catch(e){
      state = state.copyWith(hasError: e.toString());
    }
  }

  bool isFavorite(int repoID){
  return state.favorites.any((repo) => repo.id == repoID);
  }
}
final favoriteNotifierProvider = StateNotifierProvider<FavoritesNotifierProvider,FavoriteState>((ref){
  return FavoritesNotifierProvider(ref);
});

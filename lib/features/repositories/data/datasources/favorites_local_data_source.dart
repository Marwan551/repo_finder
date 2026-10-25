import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/repository_model.dart';

abstract class FavoritesLocalDataSource {
  Future<List<RepositoryModel>> getFavorites();
  Future<void> addFavorite(RepositoryModel repository);
  Future<void> removeFavorite(int repositoryId);
  Future<bool> isFavorite(int repositoryId);
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String cachedFavoritesKey = 'CACHED_FAVORITES_REPOSITORIES';

  FavoritesLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<RepositoryModel>> getFavorites() async {
    try {
      final jsonStringList = sharedPreferences.getStringList(cachedFavoritesKey);
      if (jsonStringList != null) {
        return jsonStringList
            .map((jsonStr) => RepositoryModel.fromJson(json.decode(jsonStr)))
            .toList();
      }
      return [];
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> addFavorite(RepositoryModel repository) async {
    try {
      final favorites = await getFavorites();
      if (!favorites.any((fav) => fav.id == repository.id)) {
        favorites.add(repository);
        final jsonStringList = favorites
            .map((repo) => json.encode(repo.toJson()))
            .toList();
        await sharedPreferences.setStringList(cachedFavoritesKey, jsonStringList);
      }
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<void> removeFavorite(int repositoryId) async {
    try {
      final favorites = await getFavorites();
      favorites.removeWhere((repo) => repo.id == repositoryId);
      final jsonStringList = favorites
          .map((repo) => json.encode(repo.toJson()))
          .toList();
      await sharedPreferences.setStringList(cachedFavoritesKey, jsonStringList);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }

  @override
  Future<bool> isFavorite(int repositoryId) async {
    try {
      final favorites = await getFavorites();
      return favorites.any((repo) => repo.id == repositoryId);
    } catch (e) {
      throw CacheException(message: e.toString());
    }
  }
}

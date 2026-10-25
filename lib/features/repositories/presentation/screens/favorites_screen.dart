import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/favorites_notifier.dart';
import '../widgets/repository_card.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesState = ref.watch(favoriteNotifierProvider);

    return favoritesState.isLoading
        ? const Center(child: CircularProgressIndicator())
        : favoritesState.favorites.isEmpty
            ? const Center(child: Text('No favorites yet'))
            : ListView.builder(
                itemCount: favoritesState.favorites.length,
                itemBuilder: (context, index) => RepositoryCard(
                  repository: favoritesState.favorites[index],
                ),
              );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/repository.dart';
import '../providers/favorites_notifier.dart';
import '../screens/repository_details_screen.dart';

class RepositoryCard extends ConsumerWidget {
  final Repository repository;

  const RepositoryCard({super.key, required this.repository});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesState = ref.watch(favoriteNotifierProvider);
    final isFav = favoritesState.favorites.any((fav) => fav.id == repository.id);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(repository.ownerAvatarUrl),
      ),
      title: Text(repository.fullName),
      subtitle: Text(
        '${repository.language ?? 'Unknown'} • ⭐ ${repository.stargazersCount}',
      ),
      trailing: IconButton(
        icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : null),
        onPressed: () {
          ref.read(favoriteNotifierProvider.notifier).toggle(repository);
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RepositoryDetailsScreen(repository: repository),
          ),
        );
      },
    );
  }
}

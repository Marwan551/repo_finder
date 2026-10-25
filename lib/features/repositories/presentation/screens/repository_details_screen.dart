import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/repository.dart';
import '../providers/favorites_notifier.dart';
import 'package:url_launcher/url_launcher.dart';

class RepositoryDetailsScreen extends ConsumerWidget {
  final Repository repository;

  const RepositoryDetailsScreen({super.key, required this.repository});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesState = ref.watch(favoriteNotifierProvider);
    final isFav = favoritesState.favorites.any((fav) => fav.id == repository.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(repository.name),
        actions: [
          IconButton(
            icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : null),
            onPressed: () {
              ref.read(favoriteNotifierProvider.notifier).toggle(repository);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(repository.fullName, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(repository.description ?? 'No description provided.'),
            const SizedBox(height: 16),
            Text(' Stars: ${repository.stargazersCount}'),
            Text(' Forks: ${repository.forksCount}'),
            Text(' Open Issues: ${repository.openIssuesCount}'),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                _launchURL(repository.htmlUrl);
              },
              child: const Text('Open in Browser'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String urlString) async {
    final url = Uri.parse(urlString);
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch $urlString: $e');
    }
  }
}

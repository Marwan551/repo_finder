import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/search_notifier.dart';
import '../widgets/repository_card.dart';
import '../widgets/search_field.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchNotifierProvider);

    return Column(
      children: [
        SearchField(
          onSearch: (query) => ref.read(searchNotifierProvider.notifier).search(query),
        ),
        Expanded(
          child: searchState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: searchState.repositories.length,
                  itemBuilder: (context, index) => RepositoryCard(
                    repository: searchState.repositories[index],
                  ),
                ),
        ),
      ],
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/datasources/favorites_local_data_source.dart';
import '../../data/datasources/github_remote_data_source.dart';
import '../../data/repositories/repository_functions_impl.dart';
import '../../domain/repositories/repository_functions.dart';


final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
return await  SharedPreferences.getInstance();
});


final dioClient = Provider<DioClient>((ref) => DioClient());

final githubRemoteDataSourceProvider = Provider<GithubRemoteDataSource>((ref) {
  return GithubRemoteDataSourceImpl(dio: ref.watch(dioClient).dio);

});


final favoritesLocalDataSourceProvider = FutureProvider<FavoritesLocalDataSource>((ref) async{
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return FavoritesLocalDataSourceImpl(sharedPreferences: prefs);
});


final repositoryFunctionsProvider = FutureProvider<RepositoryFunctions>((ref) async {

final remote = ref.watch(githubRemoteDataSourceProvider);
final local = await ref.watch(favoritesLocalDataSourceProvider.future);
return RepositoryFunctionsImpl(remoteDataSource: remote, localDataSource: local);
});


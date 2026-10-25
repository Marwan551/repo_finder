import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/repository_model.dart';

abstract class GithubRemoteDataSource {
  Future<List<RepositoryModel>> searchRepositories(String query, {int page = 1});
  Future<RepositoryModel> getRepositoryDetails(String owner, String repo);
}

class GithubRemoteDataSourceImpl implements GithubRemoteDataSource {
  final Dio dio;

  GithubRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<RepositoryModel>> searchRepositories(String query, {int page = 1}) async {
    try {
      final response = await dio.get(
        '/search/repositories',
        queryParameters: {
          'q': query,
          'page': page,
          'per_page': 20,
        },
      );

      if (response.statusCode == 200) {
        final List items = response.data['items'] ?? [];
        return items.map((item) => RepositoryModel.fromJson(item)).toList();
      } else {
        throw ServerException(message: 'Failed to search repositories: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<RepositoryModel> getRepositoryDetails(String owner, String repo) async {
    try {
      final response = await dio.get('/repos/$owner/$repo');

      if (response.statusCode == 200) {
        return RepositoryModel.fromJson(response.data);
      } else {
        throw ServerException(message: 'Failed to get repository details: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/repository.dart';
import '../../domain/repositories/repository_functions.dart';
import '../datasources/favorites_local_data_source.dart';
import '../datasources/github_remote_data_source.dart';
import '../models/repository_model.dart';

class RepositoryFunctionsImpl implements RepositoryFunctions {
  final GithubRemoteDataSource remoteDataSource;
  final FavoritesLocalDataSource localDataSource;

  RepositoryFunctionsImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<Repository>>> searchRepositories(String query, {int page = 1}) async {
    try {
      final remoteRepos = await remoteDataSource.searchRepositories(query, page: page);
      return Right(remoteRepos);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Repository>> getRepositoryDetails(String owner, String repo) async {
    try {
      final remoteRepo = await remoteDataSource.getRepositoryDetails(owner, repo);
      return Right(remoteRepo);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Repository>>> getFavorites() async {
    try {
      final localRepos = await localDataSource.getFavorites();
      return Right(localRepos);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleFavorite(Repository repository) async {
    try {
      final repoModel = RepositoryModel.fromEntity(repository);
      final isFav = await localDataSource.isFavorite(repository.id);
      if (isFav) {
        await localDataSource.removeFavorite(repository.id);
      } else {
        await localDataSource.addFavorite(repoModel);
      }
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(int repositoryId) async {
    try {
      final isFav = await localDataSource.isFavorite(repositoryId);
      return Right(isFav);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}

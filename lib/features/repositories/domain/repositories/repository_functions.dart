import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/repository.dart';

abstract class RepositoryFunctions {
  Future<Either<Failure, List<Repository>>> searchRepositories(String query, {int page = 1});
  Future<Either<Failure, Repository>> getRepositoryDetails(String owner, String repo);
  Future<Either<Failure, List<Repository>>> getFavorites();
  Future<Either<Failure, void>> toggleFavorite(Repository repository);
  Future<Either<Failure, bool>> isFavorite(int repositoryId);
}

import '../../domain/entities/repository.dart';

class RepositoryModel extends Repository {
  const RepositoryModel({
    required super.id,
    required super.name,
    required super.fullName,
    super.description,
    required super.htmlUrl,
    required super.stargazersCount,
    required super.forksCount,
    required super.openIssuesCount,
    super.language,
    required super.ownerLogin,
    required super.ownerAvatarUrl,
  });

  factory RepositoryModel.fromJson(Map<String, dynamic> json) {
    return RepositoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      fullName: json['full_name'] ?? '',
      description: json['description'],
      htmlUrl: json['html_url'] ?? '',
      stargazersCount: json['stargazers_count'] ?? 0,
      forksCount: json['forks_count'] ?? 0,
      openIssuesCount: json['open_issues_count'] ?? 0,
      language: json['language'],
      ownerLogin: json['owner'] != null ? json['owner']['login'] ?? '' : '',
      ownerAvatarUrl: json['owner'] != null ? json['owner']['avatar_url'] ?? '' : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'full_name': fullName,
      'description': description,
      'html_url': htmlUrl,
      'stargazers_count': stargazersCount,
      'forks_count': forksCount,
      'open_issues_count': openIssuesCount,
      'language': language,
      'owner': {
        'login': ownerLogin,
        'avatar_url': ownerAvatarUrl,
      },
    };
  }

  factory RepositoryModel.fromEntity(Repository repository) {
    return RepositoryModel(
      id: repository.id,
      name: repository.name,
      fullName: repository.fullName,
      description: repository.description,
      htmlUrl: repository.htmlUrl,
      stargazersCount: repository.stargazersCount,
      forksCount: repository.forksCount,
      openIssuesCount: repository.openIssuesCount,
      language: repository.language,
      ownerLogin: repository.ownerLogin,
      ownerAvatarUrl: repository.ownerAvatarUrl,
    );
  }
}

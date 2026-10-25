class Repository {
  final int id;
  final String name;
  final String fullName;
  final String? description;
  final String htmlUrl;
  final int stargazersCount;
  final int forksCount;
  final int openIssuesCount;
  final String? language;
  final String ownerLogin;
  final String ownerAvatarUrl;

  const Repository({
    required this.id,
    required this.name,
    required this.fullName,
    this.description,
    required this.htmlUrl,
    required this.stargazersCount,
    required this.forksCount,
    required this.openIssuesCount,
    this.language,
    required this.ownerLogin,
    required this.ownerAvatarUrl,
  });
}

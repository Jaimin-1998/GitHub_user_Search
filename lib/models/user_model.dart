
class GithubUserModel {
  final String login;
  final String avatarUrl;
  final String htmlUrl;
  final int publicRepos;

  GithubUserModel({
    required this.login,
    required this.avatarUrl,
    required this.htmlUrl,
    required this.publicRepos,
  });

  factory GithubUserModel.fromJson(Map<String, dynamic> json) {
    return GithubUserModel(
      login: json['login'],
      avatarUrl: json['avatar_url'],
      htmlUrl: json['html_url'],
      publicRepos: json['public_repos'] ?? 0,
    );
  }
}

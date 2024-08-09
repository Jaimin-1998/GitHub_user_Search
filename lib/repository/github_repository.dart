import 'dart:convert';
import 'package:githubsearchtesk/api/urls.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../utils/app_string.dart';

class GithubRepository {
  Future<List<GithubUserModel>> fetchUsers(String query) async {
    final url = Uri.parse('${ApiUrls.searchUsersUrl}?q=$query');
    final response = await http.get(url, headers: {
      'Authorization': 'token ${AppStrings.strGithubToken}',
    });
    if (response.statusCode == 200) {
      final List users = json.decode(response.body)['items'];
      List<GithubUserModel> githubUsers = [];
      for (var user in users) {
        final userDetail = await fetchUserDetails(user['login']);
        githubUsers.add(userDetail);
      }
      return githubUsers;
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<GithubUserModel> fetchUserDetails(String username) async {
    final url = Uri.parse('${ApiUrls.userDetailsUrl}$username');
    final response = await http.get(url, headers: {
      'Authorization': 'token ${AppStrings.strGithubToken}',
    });
    if (response.statusCode == 200) {
      return GithubUserModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user details');
    }
  }

  Future<String> getGithubToken() async {
    final url = Uri.parse(ApiUrls.getGithubToken);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var body =json.decode(response.body);
      return body['token'].toString();
    } else {
      throw Exception('Failed to load user details');
    }
  }
}

import 'package:flutter/material.dart';
import 'package:githubsearchtesk/utils/app_colors.dart';
import 'package:githubsearchtesk/utils/app_string.dart';
import '../models/user_model.dart';
import '../repository/github_repository.dart';
import '../widgets/app_bar.dart';

class GithubUserSearchPage extends StatefulWidget {
  const GithubUserSearchPage({super.key});

  @override
  State<GithubUserSearchPage> createState() => _GithubUserSearchPageState();
}

class _GithubUserSearchPageState extends State<GithubUserSearchPage> {
  final TextEditingController _controller = TextEditingController();
  final GithubRepository _githubService = GithubRepository();
  List<GithubUserModel> _users = [];
  bool _isLoading = false;
  String _errorMessage = '';

  void _searchUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final users = await _githubService.fetchUsers(_controller.text);
      setState(() {
        _users = users;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception:', '');
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }
  getToken() async {
    String token = await _githubService.getGithubToken();
    AppStrings.strGithubToken = token.toString();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.clrWhite,
      appBar: appBar(context, AppStrings.strAppName, false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: AppStrings.strSearchByUsername,
                labelText: AppStrings.strSearchByUsername,
                suffixIcon: _controller.text.isEmpty?
                const SizedBox():IconButton(
                  icon: const Icon(Icons.clear,color: AppColors.clrGrey,),
                  onPressed: (){
                    setState(() {
                      _controller.clear();
                      _users.clear();
                    });
                  },
                ),
                prefixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchUsers,
                ),
              ),
              onChanged: (val){
                setState(() {

                });
              },
              onSubmitted: (_) => _searchUsers(),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.clrBlue,))
                  : _errorMessage.isNotEmpty
                      ? Center(
                        child: Text(_errorMessage,
                            style: const TextStyle(color: AppColors.clrRed)),
                      )
                      : _users.isEmpty
                          ? const Center(
                              child: Text(AppStrings.strNoResults,
                                  style: TextStyle(
                                      color: AppColors.clrGrey, fontSize: 18)))
                          : ListView.builder(
                              itemCount: _users.length,
                              itemBuilder: (context, index) {
                                final user = _users[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(user.avatarUrl),
                                  ),
                                  title: Text(user.login),
                                  subtitle: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                                      decoration: BoxDecoration(
                                        color:AppColors.clrBlue,
                                        borderRadius: BorderRadius.circular(25)
                                      ),
                                      child:  Text('${user.publicRepos}  ${AppStrings.strRepositories}',style: const TextStyle(color: AppColors.clrWhite,fontSize: 14),),
                                    ),
                                  ),
                                  onTap: () {
                                  },
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}

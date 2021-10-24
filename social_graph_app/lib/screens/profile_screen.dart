import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_graph_app/models/association_type.dart';
import 'package:social_graph_app/providers/auth_provider.dart';
import 'package:social_graph_app/providers/comment_provider.dart';
import 'package:social_graph_app/providers/post_like_provider.dart';
import 'package:social_graph_app/providers/post_provider.dart';
import 'package:social_graph_app/providers/user_provider.dart';
import 'package:social_graph_app/services/association_service.dart';
import 'package:social_graph_app/widgets/profile_card.dart';
import 'package:social_graph_app/widgets/profile_friends.dart';
import '../widgets/new_post.dart';
import '../widgets/post.dart';
import '../widgets/posts_title.dart';

import '../widgets/profile_appbar.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = "/profile";

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _loading = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _loadPosts();
    });
  }

  Future<void> loadUser() async {
    final _userProvider = Provider.of<UserProvider>(context, listen: false);
    final _authProvider = Provider.of<AuthProvider>(context, listen: false);

    final username = ModalRoute.of(context)!.settings.arguments as String?;

    if (_userProvider.user == null) {
      if (username == null) {
        await _userProvider.loadUser("", "", _authProvider.currentUser);
      } else {
        await _userProvider.loadUser(username, _authProvider.token, null);
      }
    }
  }

  Future<void> _loadPosts() async {
    final _postProvider = Provider.of<PostProvider>(context, listen: false);
    final _userProvider = Provider.of<UserProvider>(context, listen: false);

    await loadUser();

    setState(() {
      _loading = true;
    });

    try {
      await _postProvider.findUserPosts(_userProvider.user!.id);
      setState(() {
        _loading = false;
      });
    } catch (error) {
      setState(() {
        _loading = false;
      });
    }
  }

  List<Widget> _buildListItems() {
    final _postProvider = Provider.of<PostProvider>(context, listen: false);

    return _postProvider.posts
        .map(
          (post) => MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => CommentProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => PostLikeProvider(),
              )
            ],
            child: PostWidget(post: post),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final _postProvider = Provider.of<PostProvider>(context);
    final _authProvider = Provider.of<AuthProvider>(context);
    final _userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: _userProvider.user == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: _loadPosts,
                child: CustomScrollView(
                  slivers: [
                    const ProfileAppbar(),
                    const SliverToBoxAdapter(
                      child: ProfileCard(),
                    ),
                    const SliverToBoxAdapter(
                      child: ProfileFriends(),
                    ),
                    if (_authProvider.currentUser.id == _userProvider.user!.id)
                      SliverToBoxAdapter(
                        child: NewPost(
                          onCreatePost: (_) async {
                            await _postProvider
                                .findUserPosts(_authProvider.currentUser.id);
                          },
                        ),
                      ),
                    const SliverToBoxAdapter(
                      child: PostsTitle(),
                    ),
                    _loading
                        ? SliverPadding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            sliver: SliverToBoxAdapter(
                              child: Center(
                                child: Container(
                                    padding: const EdgeInsets.all(7),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 5,
                                    )),
                              ),
                            ),
                          )
                        : _postProvider.posts.isEmpty
                            ? SliverFillRemaining(
                                child: Container(
                                  color: Colors.white,
                                  height: double.infinity,
                                  child: const Center(
                                    child: Text(
                                      "No posts found",
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ),
                                ),
                              )
                            : SliverList(
                                delegate:
                                    SliverChildListDelegate(_buildListItems()),
                              ),
                  ],
                ),
              ),
            ),
    );
  }
}

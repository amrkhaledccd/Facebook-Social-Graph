import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_graph_app/models/user.dart';
import 'package:social_graph_app/services/auth_service.dart';
import 'package:social_graph_app/widgets/profile_card.dart';

import '../services/post_service.dart';
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
  User? user;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _loadPosts();
    });
  }

  Future<User> loadUser() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final username = ModalRoute.of(context)!.settings.arguments as String?;

    if (user == null) {
      if (username == null) {
        user = authService.currentUser;
      } else {
        user = await authService.findUser(username);
      }
    }
    return user!;
  }

  Future<void> _loadPosts() async {
    final postService = Provider.of<PostService>(context, listen: false);
    await loadUser();

    setState(() {
      _loading = true;
    });

    try {
      await postService.findUserPosts(user!.id);
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
    final postService = Provider.of<PostService>(context, listen: false);
    return postService.posts
        .map((post) => PostWidget(
              postText: post.text,
              user: user!,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final postService = Provider.of<PostService>(context);
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: user == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: _loadPosts,
                child: CustomScrollView(
                  slivers: [
                    ProfileAppbar(title: user!.name),
                    SliverToBoxAdapter(
                      child: ProfileCard(user: user!),
                    ),
                    if (authService.currentUser.id == user!.id)
                      const SliverToBoxAdapter(
                        child: NewPost(),
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
                        : postService.posts.isEmpty
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

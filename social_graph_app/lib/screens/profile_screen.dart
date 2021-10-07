import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_graph_app/services/auth_service.dart';

import '../services/post_service.dart';
import '../widgets/new_post.dart';
import '../widgets/post.dart';
import '../widgets/posts_title.dart';

import '../widgets/profile_appbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _loading = false;

  @override
  void initState() {
    _loadPosts();
    super.initState();
  }

  Future<void> _loadPosts() async {
    final postService = Provider.of<PostService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    setState(() {
      _loading = true;
    });

    try {
      await postService.findUserPosts(authService.currentUser.id);
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
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final postService = Provider.of<PostService>(context);
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadPosts,
          child: CustomScrollView(
            slivers: [
              const ProfileAppbar(),
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
                                  color: Colors.white, shape: BoxShape.circle),
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
                          delegate: SliverChildListDelegate(_buildListItems()),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}

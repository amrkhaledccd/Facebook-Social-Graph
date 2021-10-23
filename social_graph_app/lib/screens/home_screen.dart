import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_graph_app/models/post.dart';
import 'package:social_graph_app/models/user.dart';
import 'package:social_graph_app/providers/auth_provider.dart';
import 'package:social_graph_app/providers/comment_provider.dart';
import 'package:social_graph_app/providers/post_like_provider.dart';
import 'package:social_graph_app/providers/post_provider.dart';
import 'package:social_graph_app/providers/user_provider.dart';
import 'package:social_graph_app/widgets/post.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _postProvider = Provider.of<PostProvider>(context, listen: false);
    final _authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          title: const Text('Social graph'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: FutureBuilder(
            future: _postProvider.findUserFeed(_authProvider.currentUser.id),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final posts = snapshot.data as List<Post>;

              if (posts.isEmpty) {
                return const Center(
                  child: Text("No posts found"),
                );
              }

              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (_, i) => FutureBuilder(
                  future: _postProvider.findCreator(posts[i].id),
                  builder: (_, creatorSnapshot) {
                    if (creatorSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const SizedBox();
                    }
                    final creator = creatorSnapshot.data as User;
                    final _userProvider = UserProvider();
                    _userProvider.loadUser("", "", creator);
                    return MultiProvider(
                      providers: [
                        ChangeNotifierProvider(
                          create: (_) => CommentProvider(),
                        ),
                        ChangeNotifierProvider(
                          create: (_) => PostLikeProvider(),
                        ),
                        ChangeNotifierProvider(
                          create: (_) => _userProvider,
                        )
                      ],
                      child: PostWidget(post: posts[i]),
                    );
                  },
                ),
              );
            },
          ),
        ));
  }
}

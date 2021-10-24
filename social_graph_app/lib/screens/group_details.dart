import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_graph_app/models/association_type.dart';
import 'package:social_graph_app/models/group.dart';
import 'package:social_graph_app/models/user.dart';
import 'package:social_graph_app/providers/auth_provider.dart';
import 'package:social_graph_app/providers/comment_provider.dart';
import 'package:social_graph_app/providers/group_provider.dart';
import 'package:social_graph_app/providers/post_like_provider.dart';
import 'package:social_graph_app/providers/post_provider.dart';
import 'package:social_graph_app/providers/user_provider.dart';
import 'package:social_graph_app/services/association_service.dart';
import 'package:social_graph_app/widgets/group_details_appbar.dart';
import 'package:social_graph_app/widgets/new_post.dart';
import 'package:social_graph_app/widgets/post.dart';
import 'package:social_graph_app/widgets/posts_title.dart';

class GroupDetails extends StatefulWidget {
  static const String routeName = '/group-details';
  const GroupDetails({Key? key}) : super(key: key);

  @override
  _GroupDetailsState createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  var _loading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      setState(() {
        _loading = true;
      });
      final argMap =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final _group = argMap['group'] as Group;
      final _authProvider = Provider.of<AuthProvider>(context, listen: false);
      final _groupProvider = Provider.of<GroupProvider>(context, listen: false);
      _groupProvider.checkIfJoinedByCurrentUser(
          _authProvider.currentUser.id, _group.id);
      final _postProvider = Provider.of<PostProvider>(context, listen: false);
      _postProvider.findGroupPosts(_group.id);
      setState(() {
        _loading = false;
      });
    });
    super.initState();
  }

  List<Widget> _buildListItems() {
    final _postProvider = Provider.of<PostProvider>(context, listen: false);

    return _postProvider.posts.map((post) {
      return FutureBuilder(
          future: _postProvider.findCreator(post.id),
          builder: (_, creatorSnapshot) {
            if (creatorSnapshot.connectionState == ConnectionState.waiting) {
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
                  create: (ctx) => _userProvider,
                )
              ],
              child: PostWidget(post: post),
            );
          });
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final argMap =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final _group = argMap['group'] as Group;
    final _isOwner = argMap['isOwner'] as bool;
    final _groupProvider = Provider.of<GroupProvider>(context);
    final _postProvider = Provider.of<PostProvider>(context);

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            GroupDetailsAppbar(_group, isOWner: _isOwner),
            if (_groupProvider.currentUserJoined || _isOwner)
              SliverToBoxAdapter(
                child: ChangeNotifierProvider(
                  create: (ctx) => PostProvider(),
                  child: NewPost(
                    onCreatePost: (postId) async {
                      await Provider.of<AssociationService>(context,
                              listen: false)
                          .createAssociation(
                              _group.id, postId, AssociationType.has);
                      await _postProvider.findGroupPosts(_group.id);
                    },
                  ),
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
                                color: Colors.white, shape: BoxShape.circle),
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
                        delegate: SliverChildListDelegate(_buildListItems()),
                      ),
          ],
        ),
      ),
    );
  }
}

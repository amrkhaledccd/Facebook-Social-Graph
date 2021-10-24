import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_graph_app/models/group.dart';
import 'package:social_graph_app/providers/auth_provider.dart';
import 'package:social_graph_app/providers/group_provider.dart';
import 'package:social_graph_app/providers/post_provider.dart';
import 'package:social_graph_app/widgets/group_details_appbar.dart';
import 'package:social_graph_app/widgets/new_post.dart';

class GroupDetails extends StatefulWidget {
  static const String routeName = '/group-details';
  const GroupDetails({Key? key}) : super(key: key);

  @override
  _GroupDetailsState createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      final argMap =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final _group = argMap['group'] as Group;
      final _authProvider = Provider.of<AuthProvider>(context, listen: false);
      Provider.of<GroupProvider>(context, listen: false)
          .checkIfJoinedByCurrentUser(_authProvider.currentUser.id, _group.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final argMap =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final _group = argMap['group'] as Group;
    final _isOwner = argMap['isOwner'] as bool;
    final _groupProvider = Provider.of<GroupProvider>(context);

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            GroupDetailsAppbar(_group, isOWner: _isOwner),
            if (_groupProvider.currentUserJoined || _isOwner)
              SliverToBoxAdapter(
                  child: ChangeNotifierProvider(
                      create: (ctx) => PostProvider(), child: const NewPost())),
          ],
        ),
      ),
    );
  }
}

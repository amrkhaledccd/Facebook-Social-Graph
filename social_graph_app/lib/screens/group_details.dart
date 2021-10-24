import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_graph_app/models/group.dart';
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
  Widget build(BuildContext context) {
    final _group = ModalRoute.of(context)!.settings.arguments as Group;

    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            GroupDetailsAppbar(_group),
            SliverToBoxAdapter(
                child: ChangeNotifierProvider(
                    create: (ctx) => PostProvider(), child: const NewPost())),
          ],
        ),
      ),
    );
  }
}

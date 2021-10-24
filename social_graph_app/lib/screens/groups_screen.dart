import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_graph_app/providers/auth_provider.dart';
import 'package:social_graph_app/providers/group_provider.dart';
import 'package:social_graph_app/widgets/add_new_group.dart';
import 'package:social_graph_app/widgets/horizontal_group_list.dart';
import 'package:social_graph_app/widgets/verticle_group_list.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({Key? key}) : super(key: key);

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      final _authProvider = Provider.of<AuthProvider>(context, listen: false);
      final _groupProvider = Provider.of<GroupProvider>(context, listen: false);
      _groupProvider.findUserGroups(_authProvider.currentUser.id);
      _groupProvider.findOtherGroups(_authProvider.currentUser.id);
      _groupProvider.findMemberOfGroups(_authProvider.currentUser.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _groupProvider = Provider.of<GroupProvider>(context);
    return Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          title: const Text("Groups"),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    context: context,
                    builder: (bCtx) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ChangeNotifierProvider(
                            create: (_) => _groupProvider,
                            child: const AddNewGroup()),
                      );
                    });
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: Column(
          children: [
            const GroupsTitle("Your Groups"),
            HorizontalGroupList(_groupProvider.userGroups, isUserGroup: true),
            const GroupsTitle("Member Of", marginTop: 10),
            HorizontalGroupList(_groupProvider.memberOfGroups),
            const GroupsTitle("Explore Groups", marginTop: 10),
            Expanded(child: VerticleGroupList(_groupProvider.otherGroups)),
          ],
        ));
  }
}

class GroupsTitle extends StatelessWidget {
  final String title;
  final double marginTop;
  const GroupsTitle(this.title, {Key? key, this.marginTop = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      margin: EdgeInsets.only(top: marginTop),
      padding: const EdgeInsets.all(10),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}

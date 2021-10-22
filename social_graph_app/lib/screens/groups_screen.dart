import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_graph_app/providers/auth_provider.dart';
import 'package:social_graph_app/providers/group_provider.dart';
import 'package:social_graph_app/widgets/add_new_group.dart';

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
      Provider.of<GroupProvider>(context, listen: false)
          .findUserGroups(_authProvider.currentUser.id);
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
            SizedBox(
              height: 140,
              width: double.infinity,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _groupProvider.userGroups.length,
                  itemBuilder: (_, i) => SharedWithItem(
                      _groupProvider.userGroups[i].name,
                      _groupProvider.userGroups[i].imageUrl)),
            ),
          ],
        ));
  }
}

class SharedWithItem extends StatelessWidget {
  final String name;
  final String imageUrl;

  SharedWithItem(this.name, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      //width: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            softWrap: true,
            maxLines: 1,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

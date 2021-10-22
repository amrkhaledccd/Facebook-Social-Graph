import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_graph_app/models/user.dart';
import 'package:social_graph_app/providers/user_provider.dart';
import 'package:social_graph_app/screens/profile_screen.dart';

class FindPeopleScreen extends StatelessWidget {
  const FindPeopleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Find People'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder(
            future: _userProvider.findAllUsers(),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              final users = snapshot.data as List<User>;
              return ListView.separated(
                separatorBuilder: (_, i) => const Divider(thickness: 1),
                itemCount: users.length,
                itemBuilder: (_, i) => ListTile(
                  onTap: () {
                    Navigator.of(context).pushNamed(ProfileScreen.routeName,
                        arguments: users[i].username);
                  },
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(users[i].imageUrl),
                  ),
                  title: Text(users[i].name),
                ),
              );
            },
          ),
        ));
  }
}

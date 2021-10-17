import 'package:flutter/material.dart';
import 'package:social_graph_app/screens/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(ProfileScreen.routeName, arguments: "islam");
            },
            child: const Text("Go to profile screen")),
      ),
    );
  }
}

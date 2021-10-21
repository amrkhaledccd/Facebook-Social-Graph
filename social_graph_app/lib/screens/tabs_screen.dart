import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_graph_app/providers/post_provider.dart';
import 'package:social_graph_app/providers/user_provider.dart';
import 'package:social_graph_app/screens/find_people_screen.dart';
import 'package:social_graph_app/screens/groups_screen.dart';
import 'package:social_graph_app/screens/home_screen.dart';
import 'package:social_graph_app/screens/notification_screen.dart';
import 'package:social_graph_app/screens/profile_screen.dart';
import 'package:social_graph_app/services/post_service.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 0;

  List<Widget> screens = [
    MultiProvider(providers: [
      ChangeNotifierProvider<PostProvider>(
        create: (ctx) => PostProvider(),
      ),
      ChangeNotifierProvider(
        create: (ctx) => PostProvider(),
      )
    ], child: const HomeScreen()),
    const GroupsScreen(),
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PostProvider>(
          create: (ctx) => PostProvider(),
        ),
        ChangeNotifierProvider<UserProvider>(
          create: (ctx) => UserProvider(),
        ),
      ],
      child: const ProfileScreen(),
    ),
    ChangeNotifierProvider(
        create: (_) => UserProvider(), child: const FindPeopleScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        iconSize: 24,
        selectedItemColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.blueGrey[50],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Groups'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'people'),
        ],
      ),
    );
  }
}

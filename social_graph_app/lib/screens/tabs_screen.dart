import 'package:flutter/material.dart';
import 'package:social_graph_app/screens/groups_screen.dart';
import 'package:social_graph_app/screens/home_screen.dart';
import 'package:social_graph_app/screens/notification_screen.dart';
import 'package:social_graph_app/screens/profile_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 0;

  final screens = [
    const HomeScreen(),
    const GroupsScreen(),
    const NotificationScreen(),
    const ProfileScreen()
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
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

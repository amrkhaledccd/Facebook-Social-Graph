import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_graph_app/providers/auth_provider.dart';
import 'package:social_graph_app/providers/groups_provider.dart';
import 'package:social_graph_app/providers/post_provider.dart';
import 'package:social_graph_app/providers/user_provider.dart';
import 'package:social_graph_app/screens/auth_screen.dart';
import 'package:social_graph_app/screens/group_details.dart';
import 'package:social_graph_app/screens/profile_screen.dart';
import 'package:social_graph_app/screens/tabs_screen.dart';
import 'package:social_graph_app/services/association_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AssociationService(),
        )
      ],
      child: Consumer<AuthProvider>(
        builder: (_, authPrvider, _ch) => GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primaryColor: Colors.blue[700],
            ),
            home: authPrvider.isAuthenticated
                ? const TabsScreen()
                : const AuthScreen(),
            routes: {
              ProfileScreen.routeName: (ctx) => MultiProvider(
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
              GroupDetails.routeName: (ctx) => MultiProvider(providers: [
                    ChangeNotifierProvider(
                      create: (ctx) => GroupsProvider(),
                    ),
                    ChangeNotifierProvider(
                      create: (ctx) => PostProvider(),
                    )
                  ], child: const GroupDetails()),
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_graph_app/screens/auth_screen.dart';
import 'package:social_graph_app/screens/profile_screen.dart';
import 'package:social_graph_app/screens/tabs_screen.dart';
import 'package:social_graph_app/services/auth_service.dart';
import 'package:social_graph_app/services/post_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => AuthService(),
        ),
      ],
      child: Consumer<AuthService>(
        builder: (_, authService, _ch) => GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primaryColor: Colors.blue[700],
            ),
            home: authService.isAuthenticated
                ? ChangeNotifierProvider<PostService>(
                    create: (ctx) => PostService(), child: const TabsScreen())
                : const AuthScreen(),
          ),
        ),
      ),
    );
  }
}

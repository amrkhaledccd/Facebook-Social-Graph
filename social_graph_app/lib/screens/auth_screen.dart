import 'package:flutter/material.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthMode _authMode = AuthMode.Login;

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [Colors.blueGrey.withOpacity(0.1), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [1, 2],
            )),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 45, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Social Graph",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 35,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    const SizedBox(
                      height: 65,
                    ),
                    Text(
                      _authMode == AuthMode.Login
                          ? "Login to your account"
                          : "Create new account",
                      style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 30),
                    Form(
                        child: Column(
                      children: [
                        Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(5),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: "Username",
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                            height: _authMode == AuthMode.Login ? 0 : 15,
                            duration: const Duration(milliseconds: 300),
                            child: const SizedBox(height: 15)),
                        AnimatedContainer(
                          height: _authMode == AuthMode.Login ? 0 : 60,
                          duration: const Duration(milliseconds: 300),
                          child: Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(5),
                            child: const TextField(
                              decoration: InputDecoration(
                                hintText: "Email",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(5),
                          child: const TextField(
                            decoration: InputDecoration(
                              hintText: "Password",
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                            height: _authMode == AuthMode.Login ? 0 : 15,
                            duration: const Duration(milliseconds: 300),
                            child: const SizedBox(height: 15)),
                        AnimatedContainer(
                          height: _authMode == AuthMode.Login ? 0 : 60,
                          duration: const Duration(milliseconds: 300),
                          child: Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(5),
                            child: const TextField(
                              decoration: InputDecoration(
                                hintText: "Name",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                            height: _authMode == AuthMode.Login ? 0 : 15,
                            duration: const Duration(milliseconds: 300),
                            child: const SizedBox(height: 15)),
                        AnimatedContainer(
                          height: _authMode == AuthMode.Login ? 0 : 60,
                          duration: const Duration(milliseconds: 300),
                          child: Material(
                            elevation: 2,
                            borderRadius: BorderRadius.circular(5),
                            child: const TextField(
                              decoration: InputDecoration(
                                hintText: "Image url",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 30),
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).primaryColor),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)))),
                              onPressed: () {},
                              child: Text(
                                _authMode == AuthMode.Login
                                    ? "Sign in"
                                    : "Sign up",
                                style: const TextStyle(
                                    fontSize: 16, letterSpacing: 1),
                              )),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_authMode == AuthMode.Login
                                ? "Don't have an account?"
                                : "Already have an account?"),
                            TextButton(
                                onPressed: _switchAuthMode,
                                child: Text(_authMode == AuthMode.Login
                                    ? "Sign up"
                                    : "Sign in"))
                          ],
                        )
                      ],
                    ))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

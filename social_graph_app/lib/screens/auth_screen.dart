import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_graph_app/exceptions/http_exception.dart';
import 'package:social_graph_app/services/auth_service.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthMode _authMode = AuthMode.Login;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey();

  final Map<String, String> _authData = {
    'username': '',
    'password': '',
    'email': '',
    'name': '',
    'imageUrl': ''
  };

  void _showErrorDialog(message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Okay'))
            ],
          );
        });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<AuthService>(context, listen: false).login({
          'username': _authData['username']!,
          'password': _authData['password']!,
        });
      } else {
        await Provider.of<AuthService>(context, listen: false)
            .signup(_authData);

        _switchAuthMode();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Please login to access your account")));
      }
    } on HttpException catch (error) {
      _showErrorDialog(error.message);
    } catch (error) {
      const message = "Something went wrong, try again later";
      _showErrorDialog(message);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    _formKey.currentState!.reset();

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
                        key: _formKey,
                        child: Column(
                          children: [
                            Material(
                              elevation: 2,
                              borderRadius: BorderRadius.circular(5),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  hintText: "Username",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? "Please enter a username"
                                        : null,
                                onSaved: (value) =>
                                    _authData['username'] = value!,
                              ),
                            ),
                            AnimatedContainer(
                                height: _authMode == AuthMode.Login ? 0 : 15,
                                duration: const Duration(milliseconds: 300),
                                child: const SizedBox(height: 15)),
                            AnimatedOpacity(
                              opacity: _authMode == AuthMode.Login ? 0 : 1,
                              duration: const Duration(milliseconds: 500),
                              child: AnimatedContainer(
                                height: _authMode == AuthMode.Login ? 0 : 60,
                                duration: const Duration(milliseconds: 300),
                                child: Material(
                                  elevation: 2,
                                  borderRadius: BorderRadius.circular(5),
                                  child: LayoutBuilder(
                                    builder: (BuildContext ctx,
                                            BoxConstraints constraints) =>
                                        constraints.maxHeight == 0
                                            ? const SizedBox(
                                                height: 0,
                                              )
                                            : TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: "Email",
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                                validator: (value) => value ==
                                                            null ||
                                                        value.isEmpty
                                                    ? "Please enter an email"
                                                    : null,
                                                onSaved: (value) =>
                                                    _authData['email'] = value!,
                                              ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Material(
                              elevation: 2,
                              borderRadius: BorderRadius.circular(5),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  hintText: "Password",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                obscureText: true,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? "Please enter a password"
                                        : null,
                                onSaved: (value) =>
                                    _authData['password'] = value!,
                              ),
                            ),
                            AnimatedContainer(
                                height: _authMode == AuthMode.Login ? 0 : 15,
                                duration: const Duration(milliseconds: 300),
                                child: const SizedBox(height: 15)),
                            AnimatedOpacity(
                              opacity: _authMode == AuthMode.Login ? 0 : 1,
                              duration: const Duration(milliseconds: 500),
                              child: AnimatedContainer(
                                height: _authMode == AuthMode.Login ? 0 : 60,
                                duration: const Duration(milliseconds: 300),
                                child: Material(
                                  elevation: 2,
                                  borderRadius: BorderRadius.circular(5),
                                  child: LayoutBuilder(
                                    builder: (BuildContext ctx,
                                            BoxConstraints constraints) =>
                                        constraints.maxHeight == 0
                                            ? const SizedBox(
                                                height: 0,
                                              )
                                            : TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: "Name",
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                                validator: (value) =>
                                                    value == null ||
                                                            value.isEmpty
                                                        ? "Please enter a name"
                                                        : null,
                                                onSaved: (value) =>
                                                    _authData['name'] = value!,
                                              ),
                                  ),
                                ),
                              ),
                            ),
                            AnimatedContainer(
                                height: _authMode == AuthMode.Login ? 0 : 15,
                                duration: const Duration(milliseconds: 300),
                                child: const SizedBox(height: 15)),
                            AnimatedOpacity(
                              opacity: _authMode == AuthMode.Login ? 0 : 1,
                              duration: const Duration(milliseconds: 500),
                              child: AnimatedContainer(
                                height: _authMode == AuthMode.Login ? 0 : 60,
                                duration: const Duration(milliseconds: 300),
                                child: Material(
                                  elevation: 2,
                                  borderRadius: BorderRadius.circular(5),
                                  child: LayoutBuilder(
                                    builder: (BuildContext ctx,
                                            BoxConstraints constraints) =>
                                        constraints.maxHeight == 0
                                            ? const SizedBox(
                                                height: 0,
                                              )
                                            : TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: "Image url",
                                                  border: OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                                validator: (value) => value ==
                                                            null ||
                                                        value.isEmpty
                                                    ? "Please enter a profile image url"
                                                    : null,
                                                onSaved: (value) =>
                                                    _authData['imageUrl'] =
                                                        value!,
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
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Theme.of(context).primaryColor),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)))),
                                  onPressed: _isLoading ? null : _submit,
                                  child: _isLoading
                                      ? const CircularProgressIndicator()
                                      : Text(
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

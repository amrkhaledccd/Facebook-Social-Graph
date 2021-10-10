import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:social_graph_app/exceptions/http_exception.dart';
import 'package:social_graph_app/models/user.dart';

class AuthService with ChangeNotifier {
  String? _token;
  User? _currentUser;

  User get currentUser {
    return _currentUser!;
  }

  String get token {
    return _token!;
  }

  bool get isAuthenticated {
    return _token != null && _currentUser != null;
  }

  void logout() {
    _token = null;
    _currentUser = null;
    notifyListeners();
  }

  Future<void> signup(Map<String, String> signupRequest) async {
    const url = "http://10.0.2.2:3001/users";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(signupRequest),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode > 300) {
        final body = json.decode(response.body);
        throw HttpException(body['message']);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> login(Map<String, String> loginRequest) async {
    const url = "http://10.0.2.2:3001/signin";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(loginRequest),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode == 401) {
        throw HttpException("Invalid username or password");
      } else if (response.statusCode >= 400) {
        throw HttpException("Unable to authenticate");
      }

      final body = json.decode(response.body);
      _token = body['accessToken'];
      _currentUser = User(
        body['user']['id'],
        body['user']['data']['username'],
        body['user']['data']['email'],
        body['user']['data']['name'],
        body['user']['data']['imageUrl'],
      );
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<User> findUser(String username) async {
    final url = "http://10.0.2.2:3001/users/$username";
    try {
      final response = await http
          .get(Uri.parse(url), headers: {"Authorization": "Bearer $_token"});

      if (response.statusCode >= 400) {
        throw HttpException("Unauthorized");
      } else if (response.statusCode >= 500) {
        throw HttpException("Something went wrong");
      }

      final body = json.decode(response.body);
      return User(
        body['id'],
        body['data']['username'],
        body['data']['email'],
        body['data']['name'],
        body['data']['imageUrl'],
      );
    } catch (error) {
      rethrow;
    }
  }
}

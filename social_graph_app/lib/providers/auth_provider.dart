import 'package:flutter/foundation.dart';
import 'package:social_graph_app/services/auth_service.dart';

import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  User? _currentUser;
  final _authService = AuthService();

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
    try {
      await _authService.signup(signupRequest);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> login(Map<String, String> loginRequest) async {
    try {
      final loginRes = await _authService.login(loginRequest);
      _token = loginRes['token'];
      _currentUser = loginRes['user'];
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}

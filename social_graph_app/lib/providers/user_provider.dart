import 'package:flutter/foundation.dart';
import 'package:social_graph_app/models/user.dart';
import 'package:social_graph_app/services/auth_service.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  List<User> _friends = [];
  final _authService = AuthService();

  User? get user {
    return _user;
  }

  List<User> get friends {
    return _friends;
  }

  Future<void> loadUser(
      String username, String token, User? currentUser) async {
    if (currentUser != null) {
      _user = currentUser;
    } else {
      final response = await _authService.findUser(username, token);
      _user = response;
    }

    notifyListeners();
  }

  Future<void> loadUserFriends() async {
    final response = await _authService.findUserFriends(user!.id);
    _friends = response;
    notifyListeners();
  }
}

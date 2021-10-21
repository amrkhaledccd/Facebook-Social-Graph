import 'package:flutter/foundation.dart';
import 'package:social_graph_app/models/user.dart';
import 'package:social_graph_app/services/auth_service.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  List<User> _friends = [];
  num _friendsCount = 0;
  final _authService = AuthService();

  User? get user {
    return _user;
  }

  num get friendsCount {
    return _friendsCount;
  }

  List<User> get friends {
    return _friends;
  }

  Future<void> loadUser(String username, String token, User? loadedUser) async {
    print('loading user $username');
    if (loadedUser != null) {
      _user = loadedUser;
    } else {
      final response = await _authService.findUser(username, token);
      _user = response;
    }
  }

  Future<void> loadUserFriends(String token) async {
    final response = await _authService.findUserFriends(user!.id, token);
    _friends = response;
    notifyListeners();
  }

  Future<void> loadMutualFriends(String currentUserId, String token) async {
    final response =
        await _authService.findMutualFriends(currentUserId, user!.id, token);
    _friends = response;
    notifyListeners();
  }

  Future<void> countUserFriends(String token) async {
    _friendsCount = await _authService.countUserFriends(user!.id, token);
    notifyListeners();
  }

  Future<void> countMutualFriends(String currentUserId, String toekn) async {
    _friendsCount =
        await _authService.countMutualFriends(currentUserId, user!.id, toekn);
    notifyListeners();
  }

  Future<List<User>> findAllUsers() async {
    return await _authService.findAllUsers();
  }
}

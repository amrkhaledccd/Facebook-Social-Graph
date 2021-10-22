import 'package:flutter/foundation.dart';
import 'package:social_graph_app/models/group.dart';
import 'package:social_graph_app/services/groups_service.dart';

class GroupProvider with ChangeNotifier {
  List<Group> _userGroups = [];
  final _groupService = GroupsService();

  List<Group> get userGroups {
    return [..._userGroups];
  }

  Future<Group> createGroup(String name, String imageUrl) async {
    return await _groupService.createGroup(name, imageUrl);
  }

  Future<void> findUserGroups(String userId) async {
    _userGroups = await _groupService.findUserGroups(userId);
    notifyListeners();
  }
}

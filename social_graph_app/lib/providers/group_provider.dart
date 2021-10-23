import 'package:flutter/foundation.dart';
import 'package:social_graph_app/models/group.dart';
import 'package:social_graph_app/services/groups_service.dart';

class GroupProvider with ChangeNotifier {
  List<Group> _userGroups = [];
  List<Group> _otherGroups = [];
  final _groupService = GroupsService();

  List<Group> get userGroups {
    return [..._userGroups];
  }

  List<Group> get otherGroups {
    return [..._otherGroups];
  }

  Future<Group> createGroup(String name, String imageUrl) async {
    return await _groupService.createGroup(name, imageUrl);
  }

  Future<void> findUserGroups(String userId) async {
    _userGroups = await _groupService.findUserGroups(userId);
    notifyListeners();
  }

  Future<void> findOtherGroups(String userId) async {
    _otherGroups = await _groupService.findOtherGroups(userId);
    notifyListeners();
  }
}

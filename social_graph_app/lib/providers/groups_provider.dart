import 'package:flutter/foundation.dart';
import 'package:social_graph_app/models/association_type.dart';
import 'package:social_graph_app/models/group.dart';
import 'package:social_graph_app/services/association_service.dart';
import 'package:social_graph_app/services/groups_service.dart';

class GroupsProvider with ChangeNotifier {
  List<Group> _userGroups = [];
  List<Group> _otherGroups = [];
  List<Group> _memberOfGroups = [];
  bool _currentUserJoined = false;
  final _groupService = GroupsService();
  final _associationService = AssociationService();

  void notify() {
    notifyListeners();
  }

  List<Group> get userGroups {
    return [..._userGroups];
  }

  List<Group> get otherGroups {
    return [..._otherGroups];
  }

  List<Group> get memberOfGroups {
    return _memberOfGroups;
  }

  bool get currentUserJoined {
    return _currentUserJoined;
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

  Future<void> checkIfJoinedByCurrentUser(String userId, String groupId) async {
    _currentUserJoined = await _associationService.associationExists(
        userId, groupId, AssociationType.joined);
    notifyListeners();
  }

  Future<void> findMemberOfGroups(String userId) async {
    _memberOfGroups = await _groupService.findMemberOfGroups(userId);
    notifyListeners();
  }
}

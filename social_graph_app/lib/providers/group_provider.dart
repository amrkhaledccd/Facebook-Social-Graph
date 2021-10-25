import 'package:flutter/foundation.dart';
import 'package:social_graph_app/models/association_type.dart';
import 'package:social_graph_app/models/object_type.dart';
import 'package:social_graph_app/services/association_service.dart';

class GroupProvider with ChangeNotifier {
  final _associationService = AssociationService();
  num _numOfPosts = 0;
  num _numOfMembers = 0;

  num get numOfPosts {
    return _numOfPosts;
  }

  num get numOfMembers {
    return _numOfMembers;
  }

  Future<void> countPosts(String groupId) async {
    _numOfPosts = await _associationService.countAssociation(
        groupId, AssociationType.has, ObjectType.post);
    notifyListeners();
  }

  Future<void> countMembers(String groupId) async {
    _numOfMembers = await _associationService.countAssociation(
        groupId, AssociationType.member_of, ObjectType.user);
    notifyListeners();
  }
}

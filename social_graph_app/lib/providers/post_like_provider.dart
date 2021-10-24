import 'package:flutter/foundation.dart';
import 'package:social_graph_app/models/association_type.dart';
import 'package:social_graph_app/services/association_service.dart';

class PostLikeProvider with ChangeNotifier {
  var _likesText = "";
  var _likedByCurrentUser = false;
  final _associationService = AssociationService();

  String get likesText {
    return _likesText;
  }

  bool get isLikedByCurrentUser {
    return _likedByCurrentUser;
  }

  Future<void> loadLikesStats(String postId, String userId) async {
    var likes = await _associationService.countAssociation(
        postId, AssociationType.liked_by);

    final isLikedByCurrentUser = await _associationService.associationExists(
      userId,
      postId,
      AssociationType.liked_by,
    );

    if (likes == 0) {
      if (_likedByCurrentUser) {
        _likedByCurrentUser = false;
      }
      _likesText = '';
      notifyListeners();
      return;
    }
    var text = "$likes";

    if (isLikedByCurrentUser) {
      if (likes == 1) {
        text = "You";
      } else if (likes == 2) {
        text = "You and ${likes - 1} more";
      } else {
        text = "You and ${likes - 1} others";
      }
    }

    _likesText = text;
    _likedByCurrentUser = isLikedByCurrentUser;
    notifyListeners();
  }
}

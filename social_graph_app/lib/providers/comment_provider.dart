import 'package:flutter/foundation.dart';
import 'package:social_graph_app/models/association_type.dart';
import 'package:social_graph_app/models/comment.dart';
import 'package:social_graph_app/models/object_type.dart';
import 'package:social_graph_app/models/user.dart';
import 'package:social_graph_app/services/association_service.dart';
import 'package:social_graph_app/services/comment_service.dart';

class CommentProvider with ChangeNotifier {
  List<Comment> _items = [];
  num _numOfCoumments = 0;

  final _commentService = CommentService();

  List<Comment> get comments {
    return [..._items];
  }

  num get numOfComments {
    return _numOfCoumments;
  }

  Future<void> loadPostComments(String postId) async {
    final commentList = await _commentService.loadComments(postId);
    _items = commentList;
    notifyListeners();
  }

  Future<void> countComments(String postId) async {
    final _associationService = AssociationService();
    var count = await _associationService.countAssociation(
        postId, AssociationType.has, ObjectType.comment);
    _numOfCoumments = count;
    notifyListeners();
  }

  Future<Comment> createComment(String text) async {
    return await _commentService.createComment(text);
  }

  Future<User> findCommentCreator(String commentId) async {
    return await _commentService.findCreator(commentId);
  }
}

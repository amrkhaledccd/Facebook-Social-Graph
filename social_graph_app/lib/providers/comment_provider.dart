import 'package:flutter/foundation.dart';
import 'package:social_graph_app/models/association_type.dart';
import 'package:social_graph_app/models/comment.dart';
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

  Future<void> countComments(String postId) async {
    final _associationService = AssociationService();
    var count =
        await _associationService.countAssociation(postId, AssociationType.has);
    _numOfCoumments = count;
    notifyListeners();
  }

  Future<Comment> createComment(String text) async {
    return await _commentService.createComment(text);
  }
}

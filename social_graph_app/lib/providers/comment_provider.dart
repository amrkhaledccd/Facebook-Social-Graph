import 'package:flutter/foundation.dart';
import 'package:social_graph_app/models/comment.dart';
import 'package:social_graph_app/services/comment_service.dart';

class CommentProvider with ChangeNotifier {
  final _commentService = CommentService();

  Future<Comment> createComment(String text) async {
    return await _commentService.createComment(text);
  }
}

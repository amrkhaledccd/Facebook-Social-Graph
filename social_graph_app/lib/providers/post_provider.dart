import 'package:flutter/foundation.dart';
import 'package:social_graph_app/models/post.dart';
import 'package:social_graph_app/services/post_service.dart';

class PostProvider with ChangeNotifier {
  final _postService = PostService();
  List<Post> _items = [];

  List<Post> get posts {
    return [..._items];
  }

  Future<void> findUserPosts(String userId) async {
    final response = await _postService.findUserPosts(userId);
    _items = response;
    notifyListeners();
  }

  Future<Post> createPost(String text) async {
    return await _postService.createPost(text);
  }
}

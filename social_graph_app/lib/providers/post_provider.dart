import 'package:flutter/foundation.dart';
import 'package:social_graph_app/models/post.dart';
import 'package:social_graph_app/models/user.dart';
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

  Future<List<User>> findPostLikers(String postId) async {
    return await _postService.findPostLikers(postId);
  }

  Future<Post> createPost(String text, String url) async {
    return await _postService.createPost(text, url);
  }

  Future<List<Post>> findUserFeed(String userId) async {
    return await _postService.findUserFeed(userId);
  }

  Future<User> findCreator(String postId) async {
    return await _postService.findCreator(postId);
  }
}

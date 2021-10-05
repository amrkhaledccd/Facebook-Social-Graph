import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/post.dart';

class PostService with ChangeNotifier {
  List<Post> _items = [];

  List<Post> get posts {
    return [..._items];
  }

  Future<void> findUserPosts(String userId) async {
    final url = "http://10.0.2.2:3004/objects/$userId/adjacents?type=POST";

    try {
      final response = await http.get(Uri.parse(url));
      print(response.statusCode);
      if (response.statusCode < 300) {
        final fetchedPosts = json.decode(response.body);
        List<Post> posts = [];

        fetchedPosts.forEach(
            (post) => {posts.add(Post(post["id"], post["data"]["text"]))});

        _items = posts;
      }

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<Post> createPost(String text) async {
    const url = "http://10.0.2.2:3004/objects";

    try {
      final createObjRes = await http.post(
        Uri.parse(url),
        body: json.encode({
          "type": "POST",
          "data": {"text": text}
        }),
        headers: {'content-type': 'application/json'},
      );

      final createObjBody = json.decode(createObjRes.body);

      return Post(createObjBody["id"], createObjBody["data"]["text"]);
    } catch (error) {
      rethrow;
    }
  }
}

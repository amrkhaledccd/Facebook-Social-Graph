import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

class PostService {
  Future<List<Post>> findUserPosts(String userId) async {
    final url = "http://10.0.2.2:3004/objects/$userId/adjacents?type=POST";

    try {
      final response = await http.get(Uri.parse(url));
      List<Post> posts = [];
      if (response.statusCode < 400) {
        final fetchedPosts = json.decode(response.body);

        fetchedPosts.forEach(
            (post) => {posts.add(Post(post["id"], post["data"]["text"]))});
      }
      return posts;
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

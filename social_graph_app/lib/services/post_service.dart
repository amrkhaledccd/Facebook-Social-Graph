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

        fetchedPosts.forEach((post) => {
              posts.add(Post(
                post["id"],
                post["data"]["text"],
                post["data"]["url"] ?? "",
              ))
            });
      }
      return posts;
    } catch (error) {
      rethrow;
    }
  }

  Future<Post> createPost(String text, String postUrl) async {
    const url = "http://10.0.2.2:3004/objects";

    Map<String, String> data = {'text': text};

    if (postUrl.isNotEmpty) {
      data.putIfAbsent('url', () => postUrl);
    }

    try {
      final createObjRes = await http.post(
        Uri.parse(url),
        body: json.encode({
          "type": "POST",
          "data": data,
        }),
        headers: {'content-type': 'application/json'},
      );

      final createObjBody = json.decode(createObjRes.body);

      return Post(
        createObjBody["id"],
        createObjBody["data"]["text"],
        createObjBody["data"]["url"] ?? "",
      );
    } catch (error) {
      rethrow;
    }
  }
}

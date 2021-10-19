import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:social_graph_app/exceptions/http_exception.dart';
import 'package:social_graph_app/models/user.dart';
import '../models/comment.dart';

class CommentService {
  Future<List<Comment>> loadComments(String id) async {
    final url =
        "http://10.0.2.2:3004/objects/$id/adjacents?type=COMMENT&associationType=HAS";

    try {
      final response = await http.get(Uri.parse(url));
      List<Comment> comments = [];
      if (response.statusCode < 400) {
        final fetchedComments = json.decode(response.body) as List;

        fetchedComments
            .sort((a, b) => a["createdAt"].compareTo(b["createdAt"]));

        fetchedComments.forEach((comment) => {
              comments.add(Comment(
                comment["id"],
                comment["data"]["text"],
                DateTime.parse(comment["createdAt"]),
              ))
            });
      }
      return comments;
    } catch (error) {
      rethrow;
    }
  }

  Future<Comment> createComment(String text) async {
    const url = "http://10.0.2.2:3004/objects";

    Map<String, String> data = {'text': text};

    try {
      final createObjRes = await http.post(
        Uri.parse(url),
        body: json.encode({
          "type": "COMMENT",
          "data": data,
        }),
        headers: {'content-type': 'application/json'},
      );

      final createObjBody = json.decode(createObjRes.body);

      return Comment(
        createObjBody["id"],
        createObjBody["data"]["text"],
        DateTime.parse(createObjBody["createdAt"]),
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<User> findCreator(String commentId) async {
    final url =
        "http://10.0.2.2:3004/objects/$commentId/adjacents?type=USER&associationType=CREATED_BY";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode >= 400) {
        throw HttpException("Unable to fetch the comment creator");
      }

      final fetchedUsers = json.decode(response.body);
      return User(
        fetchedUsers[0]['id'],
        fetchedUsers[0]['data']['username'],
        fetchedUsers[0]['data']['email'],
        fetchedUsers[0]['data']['name'],
        fetchedUsers[0]['data']['imageUrl'],
      );
    } catch (error) {
      rethrow;
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/comment.dart';

class CommentService {
  Future<Comment> createComment(String text) async {
    const url = "http://10.0.2.2:3004/objects";

    print(url);
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
      );
    } catch (error) {
      rethrow;
    }
  }
}

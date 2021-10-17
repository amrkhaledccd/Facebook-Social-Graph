import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:social_graph_app/exceptions/http_exception.dart';
import 'package:social_graph_app/models/user.dart';

class AuthService {
  Future<void> signup(Map<String, String> signupRequest) async {
    const url = "http://10.0.2.2:3001/users";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(signupRequest),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode > 300) {
        final body = json.decode(response.body);
        throw HttpException(body['message']);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> login(Map<String, String> loginRequest) async {
    const url = "http://10.0.2.2:3001/signin";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(loginRequest),
        headers: {'content-type': 'application/json'},
      );

      if (response.statusCode >= 500) {
        throw HttpException("Something went wrong");
      } else if (response.statusCode >= 400) {
        throw HttpException("Unauthorized");
      }

      final body = json.decode(response.body);
      return {
        'token': body['accessToken'],
        'user': User(
          body['user']['id'],
          body['user']['data']['username'],
          body['user']['data']['email'],
          body['user']['data']['name'],
          body['user']['data']['imageUrl'],
        )
      };
    } catch (error) {
      rethrow;
    }
  }

  Future<User> findUser(String username, String token) async {
    final url = "http://10.0.2.2:3001/users/$username";
    try {
      final response = await http
          .get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});

      if (response.statusCode >= 500) {
        throw HttpException("Something went wrong");
      } else if (response.statusCode >= 400) {
        throw HttpException("Unauthorized");
      }

      final body = json.decode(response.body);
      return User(
        body['id'],
        body['data']['username'],
        body['data']['email'],
        body['data']['name'],
        body['data']['imageUrl'],
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<List<User>> findUserFriends(String userId, String token) async {
    final url =
        "http://10.0.2.2:3004/objects/$userId/adjacents?type=USER&associationType=FRIEND&limit=6";

    try {
      final response = await http
          .get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});

      if (response.statusCode >= 500) {
        throw HttpException("Something went wrong");
      } else if (response.statusCode >= 400) {
        throw HttpException("Unauthorized");
      }

      final body = json.decode(response.body) as List<dynamic>;

      return body
          .map((userData) => User(
                userData['id'],
                userData['data']['username'],
                userData['data']['email'],
                userData['data']['name'],
                userData['data']['imageUrl'],
              ))
          .toList();
    } catch (error) {
      rethrow;
    }
  }

  Future<num> countUserFriends(String userId, String token) async {
    final url =
        "http://10.0.2.2:3004/objects/$userId/adjacents/count?type=USER";

    try {
      final response = await http
          .get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});

      if (response.statusCode >= 500) {
        throw HttpException("Something went wrong");
      } else if (response.statusCode >= 400) {
        throw HttpException("Unauthorized");
      }

      return json.decode(response.body) as num;
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  Future<List<User>> findMutualFriends(
      String userId1, String userId2, String token) async {
    final url =
        "http://10.0.2.2:3004/objects/$userId1/mutual/$userId2?type=USER&limit=6";

    try {
      final response = await http
          .get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});

      if (response.statusCode >= 500) {
        throw HttpException("Something went wrong");
      } else if (response.statusCode >= 400) {
        throw HttpException("Unauthorized");
      }

      final body = json.decode(response.body) as List<dynamic>;

      return body
          .map((userData) => User(
                userData['id'],
                userData['data']['username'],
                userData['data']['email'],
                userData['data']['name'],
                userData['data']['imageUrl'],
              ))
          .toList();
    } catch (error) {
      rethrow;
    }
  }

  Future<num> countMutualFriends(
      String userId1, String userId2, String token) async {
    final url =
        "http://10.0.2.2:3004/objects/$userId1/mutual/$userId2/count?type=USER";

    try {
      final response = await http
          .get(Uri.parse(url), headers: {"Authorization": "Bearer $token"});

      if (response.statusCode >= 500) {
        throw HttpException("Something went wrong");
      } else if (response.statusCode >= 400) {
        throw HttpException("Unauthorized");
      }

      return json.decode(response.body) as num;
    } catch (error) {
      rethrow;
    }
  }
}

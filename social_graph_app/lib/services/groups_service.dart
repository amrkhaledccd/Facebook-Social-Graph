import 'dart:convert';

import 'package:social_graph_app/models/group.dart';
import 'package:http/http.dart' as http;

class GroupsService {
  Future<Group> createGroup(String name, String groupImageUrl) async {
    const url = "http://10.0.2.2:3004/objects";

    Map<String, String> data = {'name': name};

    if (groupImageUrl.isNotEmpty) {
      data.putIfAbsent('imageUrl', () => groupImageUrl);
    }

    try {
      final createObjRes = await http.post(
        Uri.parse(url),
        body: json.encode({
          "type": "GROUP",
          "data": data,
        }),
        headers: {'content-type': 'application/json'},
      );

      final createObjBody = json.decode(createObjRes.body);

      return Group(
        createObjBody["id"],
        createObjBody["data"]["name"],
        createObjBody["data"]["imageUrl"] ?? "",
        DateTime.parse(createObjBody["updatedAt"]),
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Group>> findUserGroups(String userId) async {
    final url =
        "http://10.0.2.2:3004/objects/$userId/adjacents?type=GROUP&associationType=CREATED";

    try {
      final response = await http.get(Uri.parse(url));
      List<Group> groups = [];
      if (response.statusCode < 400) {
        final fetchedGroups = json.decode(response.body) as List;

        fetchedGroups.sort((a, b) => b["createdAt"].compareTo(a["createdAt"]));

        fetchedGroups.forEach((post) => {
              groups.add(Group(
                post["id"],
                post["data"]["name"],
                post["data"]["imageUrl"] ?? "",
                DateTime.parse(post["updatedAt"]),
              ))
            });
      }
      return groups;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Group>> findOtherGroups(String userId) async {
    final url =
        "http://10.0.2.2:3004/objects/$userId/no_relation?objectType=GROUP&associationType=CREATED";

    try {
      final response = await http.get(Uri.parse(url));
      List<Group> groups = [];
      if (response.statusCode < 400) {
        final fetchedGroups = json.decode(response.body) as List;

        fetchedGroups.sort((a, b) => b["updatedAt"].compareTo(a["updatedAt"]));

        fetchedGroups.forEach((post) => {
              groups.add(Group(
                post["id"],
                post["data"]["name"],
                post["data"]["imageUrl"] ?? "",
                DateTime.parse(post["updatedAt"]),
              ))
            });
      }
      return groups;
    } catch (error) {
      rethrow;
    }
  }

  Future<List<Group>> findMemberOfGroups(String userId) async {
    final url =
        "http://10.0.2.2:3004/objects/$userId/adjacents?type=GROUP&associationType=JOINED";

    try {
      final response = await http.get(Uri.parse(url));
      List<Group> groups = [];
      if (response.statusCode < 400) {
        final fetchedGroups = json.decode(response.body) as List;

        fetchedGroups.sort((a, b) => b["updatedAt"].compareTo(a["updatedAt"]));

        fetchedGroups.forEach((post) => {
              groups.add(Group(
                post["id"],
                post["data"]["name"],
                post["data"]["imageUrl"] ?? "",
                DateTime.parse(post["updatedAt"]),
              ))
            });
      }
      return groups;
    } catch (error) {
      rethrow;
    }
  }
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:social_graph_app/exceptions/http_exception.dart';
import 'package:social_graph_app/models/association_type.dart';
import 'package:http/http.dart' as http;

class AssociationService with ChangeNotifier {
  Future<void> createAssociation(
      String id1, String id2, AssociationType associationType) async {
    const _url = "http://10.0.2.2:3004/associations";

    try {
      await http.post(Uri.parse(_url),
          body: json.encode({
            'startObjectId': id1,
            'endObjectId': id2,
            'type': describeEnum(associationType).toUpperCase(),
          }),
          headers: {'content-type': 'application/json'});
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> associationExists(
      String id1, String id2, AssociationType type) async {
    final _url =
        "http://10.0.2.2:3004/associations/$id1/$id2?type=${describeEnum(type).toUpperCase()}";

    try {
      final response = await http.get(Uri.parse(_url), headers: {});

      if (response.statusCode == 200) {
        return true;
      }

      return false;
    } catch (error) {
      rethrow;
    }
  }

  Future<num> countAssociation(String objectId, AssociationType type) async {
    final _url =
        "http://10.0.2.2:3004/associations/$objectId/count?type=${describeEnum(type).toUpperCase()}";

    try {
      final response = await http.get(Uri.parse(_url), headers: {});

      if (response.statusCode >= 500) {
        throw HttpException("Something went wrong");
      } else if (response.statusCode >= 400) {
        throw HttpException("Unauthorized");
      }

      return json.decode(response.body);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteAssociation(
      String id1, String id2, AssociationType type) async {
    final _url =
        "http://10.0.2.2:3004/associations/$id1/$id2?type=${describeEnum(type).toUpperCase()}";

    try {
      await http.delete(Uri.parse(_url), headers: {});
      //notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:social_graph_app/models/association_type.dart';
import 'package:http/http.dart' as http;

class AssociationService {
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
}

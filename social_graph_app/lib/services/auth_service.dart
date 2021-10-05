import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  final _userId = "a734417b-6c96-4b1f-bc22-f3d3c5ac981b";

  String get userId {
    return _userId;
  }
}

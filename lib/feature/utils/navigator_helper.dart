import 'package:flutter/material.dart';

class NavigatorHelper {
  static void navigateToView(BuildContext context, String route) {
    Navigator.pushReplacementNamed(context, '/${route.toLowerCase()}');
  }
}

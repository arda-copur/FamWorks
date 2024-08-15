import 'package:flutter/material.dart';

mixin NavigatorMixin<T extends StatefulWidget> on State<T> {
  void navigateToHome() {
    Navigator.pushReplacementNamed(context, '/home');
  }
}


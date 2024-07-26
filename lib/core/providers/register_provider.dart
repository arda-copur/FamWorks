import 'package:flutter/material.dart';

class RegisterProvider extends ChangeNotifier {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _homeCodeController = TextEditingController();

 TextEditingController get nameController => _nameController;
 TextEditingController get passwordController => _passwordController;
 TextEditingController get emailController => _emailController;
 TextEditingController get homeCodeController => _homeCodeController;
}
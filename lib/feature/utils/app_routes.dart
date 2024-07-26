import 'package:fam_works/screens/create_task_screen.dart';
import 'package:fam_works/screens/home_screen.dart';
import 'package:fam_works/screens/login_screen.dart';
import 'package:fam_works/screens/register_screen.dart';
import 'package:fam_works/screens/rotate_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static Map<String, WidgetBuilder> get appRoutes => {
        '/login': (context) => LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/create-task': (context) => CreateTaskScreen(),
        '/rotate': (context) => const MyBottomNavigationBar(),
      };
}

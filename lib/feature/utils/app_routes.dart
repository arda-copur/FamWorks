import 'package:fam_works/views/create_task_screen.dart';
import 'package:fam_works/views/home_view.dart';
import 'package:fam_works/views/login_screen.dart';
import 'package:fam_works/views/register_screen.dart';
import 'package:fam_works/views/bottom_view.dart';
import 'package:flutter/material.dart';

class Routes {
  static Map<String, WidgetBuilder> get appRoutes => {
        '/login': (context) => LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeView(),
        '/create-task': (context) => CreateTaskScreen(),
        '/rotate': (context) => const BottomView(),
      };
}

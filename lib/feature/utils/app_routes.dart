import 'package:fam_works/views/create_task_view.dart';
import 'package:fam_works/views/home_view.dart';
import 'package:fam_works/views/login_view.dart';
import 'package:fam_works/views/register_view.dart';
import 'package:fam_works/views/bottom_view.dart';
import 'package:flutter/material.dart';

class Routes {
  static Map<String, WidgetBuilder> get appRoutes => {
        '/login': (context) => LoginScreen(),
        '/register': (context) => const RegisterView(),
        '/home': (context) => const HomeView(),
        '/create-task': (context) => CreateTaskView(),
        '/rotate': (context) => const BottomView(),
      };
}

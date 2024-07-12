import 'package:fam_works/screens/chat_screen.dart';
import 'package:fam_works/screens/create_task_screen.dart';
import 'package:fam_works/screens/home_screen.dart';
import 'package:fam_works/screens/login_screen.dart';
import 'package:fam_works/screens/register_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: []);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fam Works',
      theme: ThemeData(     
      ),
       initialRoute: '/login',
       routes: {
         '/login': (context) =>  LoginScreen(),
         '/register': (context) => RegisterScreen(),
         '/home': (context) => const HomeScreen(),
         '/create-task': (context) => CreateTaskScreen(),
       },
//image picker sdk hatası veriyor daha düşük paketine geç
    );
  }
}
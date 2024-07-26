
import 'package:fam_works/screens/login_screen.dart';
import 'package:fam_works/screens/rotate_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserAuthStatus extends StatelessWidget {
  const UserAuthStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          return  MyBottomNavigationBar();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
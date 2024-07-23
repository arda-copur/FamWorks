import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home_screen.dart';
import 'activity_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _selectedIndex = 0;
  final User user = FirebaseAuth.instance.currentUser!;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final Color bgColor = const Color(0xFF1C2341);
  final Color containerColor = const Color(0xFF272D4A);
  final Color white = const Color.fromARGB(255, 232, 218, 218);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          }

          var userData = snapshot.data!;
          String homeCode = userData['homeCode'];

          List<Widget> _screens = <Widget>[
            const HomeScreen(),
            ActivityScreen(),
            ChatScreen(homeCode: homeCode),
            ProfileScreen(userId: user.uid),
          ];

          return Scaffold(
            body: _screens[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              items:  <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  backgroundColor: bgColor,
                  icon: Icon(Icons.home),
                  label: 'Ev',
                ),
                BottomNavigationBarItem(
                    backgroundColor: bgColor,
                  icon: Icon(Icons.event),
                  label: 'Aktivite',
                ),
                BottomNavigationBarItem(
                    backgroundColor: bgColor,
                  icon: Icon(Icons.chat),
                  label: 'Sohbet',
                ),
                BottomNavigationBarItem(
                    backgroundColor: bgColor,
                  icon: Icon(Icons.person),
                  label: 'Profil',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.white,
              onTap: _onItemTapped,
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                   DrawerHeader(
                    decoration: BoxDecoration(
                      color: bgColor,
                    ),
                    child: Image.network(
                 "https://cf.ltkcdn.net/family/images/std/200821-800x533r1-family.jpg",fit: BoxFit.cover,
                 
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.task),
                    title: const Text('Geçmiş Görevler'),
                    onTap: () {
                      Navigator.pop(context);
                      _onItemTapped(0);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.event),
                    title: const Text('Geçmiş Aktiviteler'),
                    onTap: () {
                      Navigator.pop(context);
                      _onItemTapped(1);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.summarize),
                    title: const Text('Aile Özeti'),
                    onTap: () {
                      Navigator.pop(context);
                      _onItemTapped(2);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text('Çıkış'),
                    onTap: () async{
                       await FirebaseAuth.instance.signOut();
        Navigator.pushReplacementNamed(context, '/login');
                     // Navigator.pop(context);
                    //  _onItemTapped(3);
                    },
                    
                  ),
                   ListTile(
                    leading: Icon(Icons.map),
                    title: Text('Map'),
                    onTap: () {
                      Navigator.pop(context);
                      _onItemTapped(4);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

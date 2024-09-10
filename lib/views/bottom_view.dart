import 'package:fam_works/feature/utils/cache/image_network.dart';
import 'package:fam_works/constants/app_colors.dart';
import 'package:fam_works/feature/providers/bottom_provider.dart';
import 'package:fam_works/feature/utils/navigator_helper.dart';
import 'package:fam_works/views/location_view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'home_view.dart';
import 'activity_screen.dart';
import 'chat_screen.dart';
import 'profile_view.dart';

class BottomView extends StatefulWidget {
  const BottomView({super.key});

  @override
  _BottomViewState createState() => _BottomViewState();
}

class _BottomViewState extends State<BottomView> {
  final User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final bottomProvider = Provider.of<BottomProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: AppColors.bgColor,
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
            return const Center(child: Text('Bir hata oluştu'));
          }

          var userData = snapshot.data!;
          String homeCode = userData['homeCode'];

          List<Widget> _screens = [
            const HomeView(),
            ActivityScreen(),
            ChatScreen(homeCode: homeCode),
            ProfileView(userId: user.uid),
          ];

          return _screens[bottomProvider.selectedIndex];
        },
      ),
      bottomNavigationBar:
          AppBottomNavigationBar(bottomProvider: bottomProvider),
      drawer: AppDrawer(bottomProvider: bottomProvider),
    );
  }
}

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
    required this.bottomProvider,
  });

  final BottomProvider bottomProvider;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          backgroundColor: AppColors.bgColor,
          icon: const Icon(Icons.home),
          label: bottomProvider.homeLabel,
        ),
        BottomNavigationBarItem(
          backgroundColor: AppColors.bgColor,
          icon: const Icon(Icons.event),
          label: bottomProvider.activityLabel,
        ),
        BottomNavigationBarItem(
          backgroundColor: AppColors.bgColor,
          icon: const Icon(Icons.chat),
          label: bottomProvider.chatLabel,
        ),
        BottomNavigationBarItem(
          backgroundColor: AppColors.bgColor,
          icon: const Icon(Icons.person),
          label: bottomProvider.profileLabel,
        ),
      ],
      currentIndex: bottomProvider.selectedIndex,
      selectedItemColor: Colors.white,
      onTap: bottomProvider.onItemTapped,
    );
  }
}

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.bottomProvider,
  });

  final BottomProvider bottomProvider;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.bgColor,
            ),
            child: FutureBuilder<ImageProvider>(
              future: ImageNetworkClass.getImage(
                  bottomProvider.imageUrl, bottomProvider.imageFileName),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Hata: ${snapshot.error}'));
                } else {
                  return Center(
                    child: Image(image: snapshot.data!),
                  );
                }
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.task),
            title: Text(bottomProvider.pastTasks),
            onTap: () {
              Navigator.pop(context);
              bottomProvider.onItemTapped(0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: Text(bottomProvider.pastActivities),
            onTap: () {
              Navigator.pop(context);
              bottomProvider.onItemTapped(1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.summarize),
            title: Text(bottomProvider.famSummary),
            onTap: () {
              Navigator.pop(context);
              bottomProvider.onItemTapped(2);
            },
          ),
          ListTile(
            leading: const Icon(Icons.map),
            title: Text("Harita"),
            onTap: () {
              Navigator.pop(context);
              bottomProvider.onItemTapped(3);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LocationView()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: Text(bottomProvider.exit),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              NavigatorHelper.navigateToView(context, "login");
            },
          ),
        ],
      ),
    );
  }
}

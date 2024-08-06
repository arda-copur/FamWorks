import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fam_works/core/constants/app_borders.dart';
import 'package:fam_works/core/constants/app_colors.dart';
import 'package:fam_works/core/constants/app_paddings.dart';
import 'package:fam_works/feature/services/connectivy/connectivy_manager.dart';
import 'package:fam_works/views/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  late StreamSubscription<ConnectivityResult> _subscription;
   String _connectionStatus = 'Bağlantı durumu: Bilinmiyor';

  @override
  void initState() {
    super.initState();
    _subscription = ConnectivityManager()
        .connectivityStream
        .listen((ConnectivityResult result) {
      setState(() {
        _connectionStatus =
            ConnectivityManager().getConnectionStatusString(result);
      });
    });

    _checkCurrentConnectivity();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  Future<void> _checkCurrentConnectivity() async {
    ConnectivityResult result =
        await ConnectivityManager().getCurrentConnectivity();
    setState(() {
      _connectionStatus =
          ConnectivityManager().getConnectionStatusString(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        centerTitle: true,
        title: Text(_connectionStatus,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.white)),
      ),
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
            return const Center(child: Text('Veri bulunamadı'));
          }

          var userData = snapshot.data!;
          String homeCode = userData['homeCode'];

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('tasks')
                .where('homeCode', isEqualTo: homeCode)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData) {
                return const Center(child: Text('Aktif görev bulunmuyor'));
              }

              var tasks = snapshot.data!.docs;
              int tasksCompletedByUserInLast24Hours = 0;
              int tasksCompletedByUserInLastWeek = 0;

              // Tarih formatı için hazırlık
              DateTime now = DateTime.now();
              DateTime yesterday = now.subtract(const Duration(days: 1));
              DateTime oneWeekAgo = now.subtract(const Duration(days: 7));

              // Son 24 saatte ve bir haftada tamamlanan görevlerin sayısını hesapla
              for (var task in tasks) {
                if (task['completed'] && task['completedById'] == user.uid) {
                  DateTime taskCompletedAt =
                      (task['completedAt'] as Timestamp).toDate();
                  if (taskCompletedAt.isAfter(yesterday)) {
                    tasksCompletedByUserInLast24Hours++;
                  }
                  if (taskCompletedAt.isAfter(oneWeekAgo)) {
                    tasksCompletedByUserInLastWeek++;
                  }
                }
              }
              //UI BAŞLANGICI

              return Padding(
                padding: const AppPaddings.allMedium(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const AppPaddings.allNormal(),
                      decoration: BoxDecoration(
                          color: AppColors.containerColor,
                          borderRadius: AppBorders.circularLow()),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: userData['profilePic'] != ''
                                ? NetworkImage(userData['profilePic'])
                                : const AssetImage('assets/default_avatar.png')
                                    as ImageProvider,
                          ),
                          const SizedBox(width: 16.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Merhaba ${userData['name']}!',
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                'Son 24 saatte $tasksCompletedByUserInLast24Hours görev tamamladın',
                                style: const TextStyle(color: AppColors.white),
                              ),
                              Text(
                                'Bu hafta boyunca $tasksCompletedByUserInLastWeek görev tamamladın',
                                style: const TextStyle(color: AppColors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Görevler',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    // Görev listesi
                    Expanded(
                      child: ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          var task = tasks[index];
                          bool isCompleted = task['completed'];
                          String completedBy = task['completedBy'];

                          return SizedBox(
                            height: 250,
                            child: Card(      
                              color: AppColors.containerColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: AppBorders.circularLow()),
                              child: Padding(
                                padding: const AppPaddings.allSmall(),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          task['description'],
                                          style: const TextStyle(
                                            color: Colors.amberAccent,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Oluşturan:',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfileScreen(
                                                              userId: task[
                                                                  'createdBy']),
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  '${task['createdByName']}',
                                                  style:  TextStyle(
                                                      color: Colors.amber[300],
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                          ],
                                        ),
                                        Text(
                                          'Kategori: ${task['category']}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        if (isCompleted)
                                          Text('Tamamlayan: $completedBy',
                                              style: const TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold)),
                                        Row(
                                          children: [
                                            const Text(
                                              'Puan Ver',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.star,
                                                  color: Colors.yellow),
                                              onPressed: () {
                                                if (isCompleted &&
                                                    task['createdBy'] ==
                                                        user.uid &&
                                                    task['completedById'] !=
                                                        user.uid) {
                                                  _showRatingDialog(task.id,
                                                      task['completedById']);
                                                } else {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return const Dialog(
                                                          child: SizedBox(
                                                            height: 70,
                                                            width: 300,
                                                            child: Center(
                                                                child: Text(
                                                                    "Kendinize Puan Veremezsiniz")),
                                                          ),
                                                        );
                                                      });
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            isCompleted
                                                ? const Text(
                                                    "Tamamlandı",
                                                    style: TextStyle(
                                                        color: Colors.green),
                                                  )
                                                : const Text(""),
                                            Row(
                                              children: [
                                                const Text("Durum",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.check_circle,
                                                    color: isCompleted
                                                        ? Colors.green
                                                        : Colors.grey,
                                                  ),
                                                  onPressed: isCompleted
                                                      ? null
                                                      : () {
                                                          completeTask(task.id);
                                                        },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    if (task['imageUrl'] != '')
                                      Container(
                                        height: 200,
                                        width: 150,
                                        decoration: const BoxDecoration(),
                                        child: Image.network(
                                          task['imageUrl'],
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    else
                                      const Text("Fotoğrafa ulaşılamadı"),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create-task');
        },
        child: const Icon(Icons.add_circle,color: AppColors.bgColor,),
      ),
    );
  }



  Future<void> completeTask(String taskId) async {
    try {
      User user = FirebaseAuth.instance.currentUser!;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      String userName = userDoc['name'];

      await FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
        'completed': true,
        'completedBy': userName,
        'completedById': user.uid,
        'completedAt': Timestamp.now(), // Görev tamamlanma tarihini güncelle
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void _showRatingDialog(String taskId, String completedById) {
    double _rating = 0.0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Görevi tamamlayan kişiye puan verin'),
          content: RatingBar.builder(
            initialRating: 1,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
          actions: [
            TextButton(
              child: const Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Puan Ver'),
              onPressed: () {
                _rateUser(taskId, completedById, _rating);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _rateUser(String taskId, String userId, double rating) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
        'ratings': FieldValue.arrayUnion([
          {'userId': userId, 'rating': rating}
        ]),
      });
    } catch (e) {
      print("Error: $e");
    }
  }
}

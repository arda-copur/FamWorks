import 'package:fam_works/constants/app_colors.dart';
import 'package:fam_works/feature/utils/app_box.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileView extends StatefulWidget {
  final String userId;

  const ProfileView({super.key, required this.userId});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final String profile = 'Profil';
  final String averagePoint = 'Ortalama Puan';
  final String createdTasks = 'Oluşturulan Görevler';
  final String completedTasks = "Tamamlanan Görevler";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        title: Text(
          profile,
          style: const TextStyle(color: AppColors.white),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var userData = snapshot.data!;
            return Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: userData['profilePic'] != ''
                      ? NetworkImage(userData['profilePic'])
                      : const AssetImage('assets/default_avatar.png')
                          as ImageProvider,
                ),
                const AppHeightBox(height: 10),
                Text(userData['name'],
                    style: const TextStyle(fontSize: 24, color: Colors.amber)),
                const AppHeightBox(height: 20),
                Expanded(
                  child: FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('tasks')
                        .where('completedById', isEqualTo: widget.userId)
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return const Text("Bir sorun oluştu");
                      }
                      var tasks = snapshot.data!.docs;
                      num totalRating = 0;
                      double ratingCount = 0;

                      for (var task in tasks) {
                        var ratings = task['ratings'] ?? [];
                        for (var rating in ratings) {
                          if (rating['userId'] == widget.userId) {
                            totalRating += rating['rating'];
                            ratingCount++;
                          }
                        }
                      }
                      double averageRating =
                          ratingCount > 0 ? totalRating / ratingCount : 0;

                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  '$averagePoint ${averageRating.toStringAsFixed(1)}',
                                  style: const TextStyle(
                                      fontSize: 18, color: AppColors.white)),
                              const SizedBox(
                                width: 6,
                              ),
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                              )
                            ],
                          ),
                          const AppHeightBox(height: 20),
                          Text(createdTasks,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.amber)),
                          Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('tasks')
                                  .where('createdBy', isEqualTo: widget.userId)
                                  .snapshots(),
                              builder: (context, createdSnapshot) {
                                if (createdSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (!createdSnapshot.hasData ||
                                    createdSnapshot.data!.docs.isEmpty) {
                                  return Center(
                                      child: Text(
                                    'Henüz görev oluşturmamış.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: AppColors.white),
                                  ));
                                }

                                var createdTasks = createdSnapshot.data!.docs;

                                return ListView.builder(
                                  itemCount: createdTasks.length,
                                  itemBuilder: (context, index) {
                                    var task = createdTasks[index];
                                    return ListTile(
                                      leading: task['imageUrl'] != ''
                                          ? Image.network(task['imageUrl'],
                                              width: 50, height: 50)
                                          : null,
                                      title: Text(
                                        task['title'],
                                        style: const TextStyle(
                                            color: AppColors.white),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            task['description'],
                                            style: const TextStyle(
                                                color: AppColors.white),
                                          ),
                                          Text(
                                            task['category'],
                                            style: const TextStyle(
                                                color: AppColors.white),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          const AppHeightBox(height: 20),
                          Text(completedTasks,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.amber)),
                          Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('tasks')
                                  .where('completedById',
                                      isEqualTo: widget.userId)
                                  .snapshots(),
                              builder: (context, completedSnapshot) {
                                if (completedSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (!completedSnapshot.hasData ||
                                    completedSnapshot.data!.docs.isEmpty) {
                                  return const Center(
                                      child: Text(
                                    'Henüz bir görev tamamlamadınız',
                                    style: TextStyle(color: AppColors.white),
                                  ));
                                }

                                var completedTasks =
                                    completedSnapshot.data!.docs;

                                return ListView.builder(
                                  itemCount: completedTasks.length,
                                  itemBuilder: (context, index) {
                                    var task = completedTasks[index];
                                    return ListTile(
                                      leading: task['imageUrl'] != ''
                                          ? Image.network(task['imageUrl'],
                                              width: 50, height: 50)
                                          : null,
                                      title: Text(
                                        task['title'],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        task['description'],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      trailing: Text(
                                        task['category'],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

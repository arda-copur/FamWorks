import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  ProfileScreen({required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  
 final Color bgColor = const Color(0xFF1C2341);
 final Color containerColor =  const Color(0xFF272D4A);
 final Color white = Colors.white;
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: bgColor,
    appBar: AppBar(
      backgroundColor: bgColor,
      title: Text('Profil',style: TextStyle(color: white),),
    ),
    body: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(widget.userId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var userData = snapshot.data!;
          return Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: userData['profilePic'] != ''
                    ? NetworkImage(userData['profilePic'])
                    : const AssetImage('assets/default_avatar.png') as ImageProvider,
              ),
              const SizedBox(height: 10),
              Text(userData['name'], style: const TextStyle(fontSize: 24,color: Colors.amber)),
              const SizedBox(height: 20),
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
                    double averageRating = ratingCount > 0 ? totalRating / ratingCount : 0;

                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Ortalama Puan: ${averageRating.toStringAsFixed(1)}', style: TextStyle(fontSize: 18,color: white)),
                            const SizedBox(width: 6,),
                            const Icon(Icons.star,color: Colors.amber,)
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text('Oluşturulan Görevler', style: TextStyle(fontSize: 18,color: Colors.amber)),
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('tasks')
                                .where('createdBy', isEqualTo: widget.userId)
                                .snapshots(),
                            builder: (context, createdSnapshot) {
                              if (createdSnapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (!createdSnapshot.hasData || createdSnapshot.data!.docs.isEmpty) {
                                return const Center(child: Text('No created tasks'));
                              }

                              var createdTasks = createdSnapshot.data!.docs;

                              return ListView.builder(
                                itemCount: createdTasks.length,
                                itemBuilder: (context, index) {
                                  var task = createdTasks[index];
                                  return ListTile(
                                    leading: task['imageUrl'] != ''
                                        ? Image.network(task['imageUrl'], width: 50, height: 50)
                                        : null,
                                    title: Text(task['title'],style: TextStyle(color: white),),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(task['description'],style: TextStyle(color: white),),
                                        Text(task['category'],style: TextStyle(color: white),),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text('Tamamlanan Görevler', style: TextStyle(fontSize: 18,color: Colors.amber)),
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('tasks')
                                .where('completedById', isEqualTo: widget.userId)
                                .snapshots(),
                            builder: (context, completedSnapshot) {
                              if (completedSnapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (!completedSnapshot.hasData || completedSnapshot.data!.docs.isEmpty) {
                                return Center(child: Text('Henüz bir görev tamamlamadınız',style: TextStyle(color: white),));
                              }

                              var completedTasks = completedSnapshot.data!.docs;

                              return ListView.builder(
                                itemCount: completedTasks.length,
                                itemBuilder: (context, index) {
                                  var task = completedTasks[index];
                                  return ListTile(
                                    leading: task['imageUrl'] != ''
                                        ? Image.network(task['imageUrl'], width: 50, height: 50)
                                        : null,
                                    title: Text(task['title'],style: TextStyle(color: Colors.white),),
                                    subtitle: Text(task['description'],style: TextStyle(color: Colors.white),),
                                    trailing: Text(task['category'],style: TextStyle(color: Colors.white),),
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

import 'package:fam_works/constants/app_colors.dart';
import 'package:fam_works/feature/extensions/dynamic_size_extension.dart';
import 'package:fam_works/feature/services/firebase_service.dart';
import 'package:fam_works/views/create_activity.screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ActivityScreen extends StatelessWidget {
  final FirebaseService service = FirebaseService();
  final String activitiesText = "Aktiviteler";
  final String activitiesErrorText = "Aktivite bulunamadı";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        title: Text(
          activitiesText,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('activities')
            // .where('invitees', arrayContains: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text(activitiesErrorText));
          }

          var activities = snapshot.data!.docs;

          return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              var activity = activities[index];
              bool isParticipant =
                  activity['participants'].contains(service.user.uid);

              return SizedBox(
                height: context.dynamicHeight(0.12),
                width: context.dynamicWidth(0.8),
                child: Card(
                  color: AppColors.containerColor,
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          activity['title'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          activity['location'],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      DateFormat('dd-MM-yyyy – HH:mm')
                          .format(activity['dateTime'].toDate()),
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: isParticipant
                        ? const Text(
                            'Katılıyorsun',
                            style: TextStyle(color: Colors.white),
                          )
                        : ElevatedButton(
                            onPressed: () => service.joinActivity(activity.id),
                            child: const Text(
                              'Katıl',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: SizedBox(
        width: 150,
        child: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 248, 198, 49),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CreateActivityScreen()),
            );
          },
          child: const Text(
            "Plan Oluştur",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

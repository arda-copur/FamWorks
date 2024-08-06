import 'package:fam_works/views/create_activity.screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ActivityScreen extends StatelessWidget {
  final User user = FirebaseAuth.instance.currentUser!;
  final Color bgColor = const Color(0xFF1C2341);
  final Color containerColor = const Color(0xFF272D4A);
  final Color white = const Color.fromARGB(255, 232, 218, 218);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text('Aktiviteler',style: TextStyle(color: Colors.white),),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('activities')
           // .where('invitees', arrayContains: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Aktivite bulunamadı'));
          }

          var activities = snapshot.data!.docs;

          return ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) {
              var activity = activities[index];
              bool isParticipant = activity['participants'].contains(user.uid);

              return SizedBox(
                height: 100,
                width: 700,
                child: Card(
                  color: containerColor,
                  child: ListTile(
                    title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(activity['title'],style: TextStyle(color: Colors.white),),
                        Text(activity['location'],style: TextStyle(color: Colors.white),),
                      ],
                    ),
                    subtitle: Text(
                      '${DateFormat('dd-MM-yyyy – HH:mm').format(activity['dateTime'].toDate())}',style: TextStyle(color: Colors.white),
                      
                    ),
                    trailing: isParticipant
                        ? Text('Katılıyorsun',style: TextStyle(color: Colors.white),)
                        : ElevatedButton(
                            onPressed: () => _joinActivity(activity.id),
                            child: Text('Katıl',style: TextStyle(color: Colors.white),),
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
         backgroundColor: Color.fromARGB(255, 248, 198, 49),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateActivityScreen()),
            );
          },
          child: Text("Plan Oluştur",style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }

  Future<void> _joinActivity(String activityId) async {
    try {
      await FirebaseFirestore.instance.collection('activities').doc(activityId).update({
        'participants': FieldValue.arrayUnion([user.uid]),
      });
    } catch (e) {
      print('Error joining activity: $e');
      // Show error message to user
    }
  }
}

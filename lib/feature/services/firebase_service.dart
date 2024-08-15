import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fam_works/model/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseService {

  User user = FirebaseAuth.instance.currentUser!;

   Future<void> completeTask(String taskId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      String userName = userDoc['name'];

      await FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
        'completed': true,
        'completedBy': userName,
        'completedById': user.uid,
        'completedAt': Timestamp.now(), 
      });
    } catch (e) {
      print("Error: $e");
    }
  }

 
  Future<void> rateUser(String taskId, String userId, double rating) async {
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

  
  void sendMessage(TextEditingController messageController,String homeCode) async {
    if (messageController.text.isNotEmpty) {
      var currentUser = FirebaseAuth.instance.currentUser;
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).get();
      var userName = userDoc['name'];
      var userProfilePic = userDoc['profilePic'];

      Message message = Message(
      text: messageController.text,
      senderId: currentUser.uid,
      senderName: userName,
      senderProfilePic: userProfilePic,
      timestamp: Timestamp.now(),
    );

    FirebaseFirestore.instance.collection('chats').doc(homeCode).collection('messages').add(message.toMap());
      messageController.clear();
    }
  }
  

    Future<void> joinActivity(String activityId) async {
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fam_works/feature/utils/navigator_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserAuth {
  Future<void> registerUser(String name, String email, String password,
      String homeCode, String? imageUrl, context) async {
    try {
      DocumentSnapshot homeDoc = await FirebaseFirestore.instance
          .collection('homes')
          .doc(homeCode)
          .get();

      
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = userCredential.user!;

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': name,
        'email': email,
        'homeCode': homeCode,
        'profilePic': imageUrl ?? '',
      });

      DocumentReference homeRef =
          FirebaseFirestore.instance.collection('homes').doc(homeCode);
      await homeRef.set({
        'members': FieldValue.arrayUnion([user.uid])
      }, SetOptions(merge: true));

      NavigatorHelper.navigateToView(context, "rotate");
    } on FirebaseAuthException catch (e) {
      print("Error: $e");
    }
  }

  Future<void> loginUser(String email, String password, context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = userCredential.user!;

      NavigatorHelper.navigateToView(context, 'rotate');
    } on FirebaseAuthException catch (e) {
      print("Error: $e");
    }
  }
}

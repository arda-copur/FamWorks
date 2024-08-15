import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fam_works/views/create_task_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

abstract class TaskViewModel extends State<CreateTaskView> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  String selectedCategory = 'Temizlik';
  File? image;
  final picker = ImagePicker();
  final String createTaskString = "Görev Oluştur";

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('Fotoğraf seçilmedi.');
      }
    });
  }

  Future<String> uploadFile(File file) async {
    String fileName = file.path.split('/').last;
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child('task_images/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> createTask(
      String title, String description, String category) async {
    try {
      User user = FirebaseAuth.instance.currentUser!;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      String homeCode = userDoc['homeCode'];
      String createdByName = userDoc['name'];
      String? imageUrl;

      if (image != null) {
        imageUrl = await uploadFile(image!);
      }

      await FirebaseFirestore.instance.collection('tasks').add({
        'title': title,
        'description': description,
        'homeCode': homeCode,
        'createdBy': user.uid,
        'createdByName': createdByName,
        'completed': false,
        'completedBy': '',
        'category': category,
        'imageUrl': imageUrl ?? '',
      });

      Navigator.pop(context);
    } catch (e) {
      print("Error: $e");
    }
  }
}

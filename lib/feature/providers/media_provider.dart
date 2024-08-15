
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MediaProvider extends ChangeNotifier {
  
  final ImagePicker _picker = ImagePicker();
  
  File? _image;
  File? get image => _image;

  Future<void> pickImage() async { 
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      notifyListeners(); 
    }
  }

  Future<String?> uploadImage(File file) async {
    if (_image == null) return null;

    final storageRef = FirebaseStorage.instance.ref().child('profile_pics/${DateTime.now().toIso8601String()}');
    final uploadTask = storageRef.putFile(_image!);
    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _homeCodeController = TextEditingController();
  File? _image;
 final Color bgColor = const Color(0xFF1C2341);
 final Color containerColor =  const Color(0xFF272D4A);
 final Color white = Colors.white;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<String> _uploadImage(File image) async {
    final storageRef = FirebaseStorage.instance.ref().child('profile_pics/${DateTime.now().toIso8601String()}');
    final uploadTask = storageRef.putFile(image);
    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                    Text(
              'Lütfen bilgilerinizi giriniz',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: white),
            ),
             const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration:     InputDecoration(
                hintText: 'İsim',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.person),
                filled: true,
                fillColor: Colors.purple.shade50,
              ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Lütfen isminizi girin';
                    }
                    else if (value.length < 2){
                       return "Lütfen en az 3 karakter girin";
                    }
                    else {
                      return null;
                    }
                  },
                ),
                 const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                 decoration:  InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.email),
                filled: true,
                fillColor: Colors.purple.shade50,
              ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                 const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration:  InputDecoration(
                hintText: 'Şifre',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.lock),
                filled: true,
                fillColor: Colors.purple.shade50,
              ),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Lütfen şifre giriniz';
                    }
                    else if (value.length < 6) {
                       return "Şifre en az 6 karakter olmalıdır";
                    }
                    else {
                      return null;
                    }
                    
                  },
                ),
                 const SizedBox(height: 16),
                TextFormField(
                  controller: _homeCodeController,
                 decoration:  InputDecoration(
                hintText: 'Ev Kodu',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.home_filled),
                filled: true,
                fillColor: Colors.purple.shade50,
              ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the home code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                _image == null
                    ? SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                          onPressed: _pickImage,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt,color: bgColor,),
                              const SizedBox(width: 8,),
                              Text('Fotoğraf Yükle',style: TextStyle(color: bgColor,fontWeight: FontWeight.bold,fontSize: 16),),
                            ],
                          ),
                        ),
                    )
                    : Image.file(_image!, height: 100, width: 100),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                   style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String? imageUrl;
                        if (_image != null) {
                          imageUrl = await _uploadImage(_image!);
                        }
                        registerUser(
                          _nameController.text,
                          _emailController.text,
                          _passwordController.text,
                          _homeCodeController.text,
                          imageUrl,
                        );
                      }
                    },
                    child: Text('Hesap Oluştur',style: TextStyle(color: bgColor,fontWeight: FontWeight.bold,fontSize: 18),),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text('Zaten bir hesabınız var mı? Giriş yapın',style: TextStyle(color: Colors.white60),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> registerUser(String name, String email, String password, String homeCode, String? imageUrl) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
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

      DocumentReference homeRef = FirebaseFirestore.instance.collection('homes').doc(homeCode);
      await homeRef.set({
        'members': FieldValue.arrayUnion([user.uid])
      }, SetOptions(merge: true));

      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      print("Error: $e");
    }
  }
}

import 'dart:io';
import 'package:flutter/material.dart';

class RegisterButton extends StatelessWidget {
  final GlobalKey<FormState> registerKey;
  final Future<void> Function() registerUser;
  final Future<String?> registerImageUpload;
  final File? image;
  String? imageUrl;
   RegisterButton({
    Key? key,
    required this.registerKey,
    required this.registerUser,
    required this.registerImageUpload,
    this.image, this.imageUrl,
   }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width: double.infinity,
      child: ElevatedButton(
                     style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: ()  async{
                        if (registerKey.currentState!.validate()) {
                          if (image != null) {
                             imageUrl =  await registerImageUpload;
                          }
                          registerUser();
                        }
                      },
                      child: const Text('Hesap Oluştur',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 18),),
                    ),
    );
  }
}

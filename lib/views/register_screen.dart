import 'package:fam_works/core/constants/app_colors.dart';
import 'package:fam_works/core/constants/app_paddings.dart';
import 'package:fam_works/core/constants/app_texts.dart';
import 'package:fam_works/core/providers/media_provider.dart';
import 'package:fam_works/core/providers/auth_module_provider.dart.dart';
import 'package:fam_works/core/register/widgets/register_email_tf.dart';
import 'package:fam_works/core/register/widgets/register_home_tf.dart';
import 'package:fam_works/core/register/widgets/register_name_tf.dart.dart';
import 'package:fam_works/core/register/widgets/register_password_tf.dart';
import 'package:fam_works/feature/services/auth/user_auth.dart';
import 'package:fam_works/feature/utils/app_box.dart';
import 'package:fam_works/feature/utils/navigator_helper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formKey = GlobalKey<FormState>();
  UserAuth auth = UserAuth();

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<AuthModuleProvider>(context, listen: false); //true idi. false veya registerUserdaki context patlatıyor mu bir bak
    final mediaProvider = Provider.of<MediaProvider>(context, listen: true);
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Padding(
        padding: const AppPaddings.allMedium(),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  AppTexts.info,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white),
                ),
                const AppHeightBox(height: 24),
                NameTextField(nameController: registerProvider.nameController),
                const AppHeightBox(
                  height: 16,
                ),
                EmailTextField(
                    emailController: registerProvider.emailController),
                const AppHeightBox(
                  height: 16,
                ),
                PasswordTextField(
                    passwordController: registerProvider.passwordController),
                const AppHeightBox(
                  height: 16,
                ),
                HomeCodeTextField(
                    homeCodeController: registerProvider.homeCodeController),
                const AppHeightBox(
                  height: 30,
                ),
                mediaProvider.image == null
                    ? SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: mediaProvider.pickImage,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                color: AppColors.bgColor,
                              ),
                              AppWidthBox(),
                              Text(
                                AppTexts.addPhoto,
                                style: TextStyle(
                                    color: AppColors.bgColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Image.file(mediaProvider.image!, height: 100, width: 100),
                const AppHeightBox(height: 20),
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

                        imageUrl = await mediaProvider
                            .uploadImage(mediaProvider.image!);

                        auth.registerUser(
                          registerProvider.nameController.text,
                          registerProvider.emailController.text,
                          registerProvider.passwordController.text,
                          registerProvider.homeCodeController.text,
                          imageUrl,
                          context,
                         homeCodeDialog,
                         
                        );
                      }
                    },
                    child: const Text(
                      AppTexts.createAccount,
                      style: TextStyle(
                          color: AppColors.bgColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    NavigatorHelper.navigateToView(context, "login");
                  },
                  child: const Text(
                    'Zaten bir hesabınız var mı? Giriş yapın',
                    style: TextStyle(color: Colors.white60),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Future<T?> homeCodeDialog<T>(context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Uyarı'),
              content: const Text(
                  'Bu ev kodu zaten mevcut. Lütfen başka bir kod giriniz.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Tamam'),
                ),
              ],
            ));
  }


  Future<void> registerUser(String name, String email, String password,
      String homeCode, String? imageUrl) async {
    try {
      DocumentSnapshot homeDoc = await FirebaseFirestore.instance
          .collection('homes')
          .doc(homeCode)
          .get();

      if (homeDoc.exists) {
      
        return;
      }

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
}

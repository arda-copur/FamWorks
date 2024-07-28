
import 'package:fam_works/core/login/login_tf_styles.dart';
import 'package:fam_works/core/register/textfields_styles.dart';
import 'package:flutter/material.dart';

class LoginEmailTextfield extends StatelessWidget with LoginTextFields {
  TextEditingController emailController;
   LoginEmailTextfield({
    Key? key,
    required this.emailController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  TextFormField(
                  controller: emailController,
                  decoration: emailTfStyle,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return emailTfIsEmpty;
                    }
                    else if (value.length < 7){
                       return emailTfLeastCharacters;
                    }
                    else {
                      return null;
                    }
                  },
                );
  }
}

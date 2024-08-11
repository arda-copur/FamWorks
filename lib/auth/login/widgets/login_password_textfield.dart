
import 'package:fam_works/auth/login/login_tf_styles.dart';
import 'package:fam_works/auth/register/textfields_styles.dart';
import 'package:flutter/material.dart';

class LoginPasswordTextfield extends StatelessWidget with LoginTextFields {
  TextEditingController passwordController;
   LoginPasswordTextfield({
    Key? key,
    required this.passwordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: passwordTfStyle,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return passwordTfIsEmpty;
                    }
                    else if (value.length < 7){
                       return passwordTfLeastCharacters;
                    }
                    else {
                      return null;
                    }
                  },
                );
  }
}


import 'package:fam_works/auth/register/textfields_styles.dart';
import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget with RegisterTextFields {
  TextEditingController passwordController;
   PasswordTextField({
    Key? key,
    required this.passwordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  TextFormField(
                  controller: passwordController,
                  decoration: passwordTfStyle,
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return passwordTfIsEmpty;
                    }
                    else if (value.length < 6){
                       return passwordTfLeastCharacters;
                    }
                    else {
                      return null;
                    }
                  },
                );
  }
}

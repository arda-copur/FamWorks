
import 'package:fam_works/auth/register/textfields_styles.dart';
import 'package:flutter/material.dart';

class EmailTextField extends StatelessWidget with RegisterTextFields {
  TextEditingController emailController;
   EmailTextField({
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

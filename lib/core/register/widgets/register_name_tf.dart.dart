
import 'package:fam_works/core/register/textfields_styles.dart';
import 'package:flutter/material.dart';

class NameTextField extends StatelessWidget with RegisterTextFields {
  TextEditingController nameController;
   NameTextField({
    Key? key,
    required this.nameController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  TextFormField(
                  controller: nameController,
                  decoration: nameTfStyle,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return nameTfIsEmpty;
                    }
                    else if (value.length < 2){
                       return nameTfLeastCharacters;
                    }
                    else {
                      return null;
                    }
                  },
                );
  }
}



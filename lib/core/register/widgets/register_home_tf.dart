
import 'package:fam_works/core/register/textfields_styles.dart';
import 'package:flutter/material.dart';

 class HomeCodeTextField extends StatelessWidget with RegisterTextFields {
   TextEditingController homeCodeController;
   HomeCodeTextField({
    Key? key,
    required this.homeCodeController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  TextFormField(
                  controller: homeCodeController,
                  decoration: homeCodeTfStyle,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return homeCodeTfIsEmpty;
                    }
                    else if (value.length < 2){
                       return homeCodeTfLeastCharacters;
                    }
                    else {
                      return null;
                    }
                  },
                );
  }
}

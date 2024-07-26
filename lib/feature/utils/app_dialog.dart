import 'package:flutter/material.dart';

 class AppDialogs {


    final AppDialogStyle dialogStyle = AppDialogStyle();
  
   Future<T?> appDialog<T>(BuildContext context, String dialogTitle, String dialogMessage, String dialogButtonTitle) {
    return showDialog(context: context, builder: (context) => AlertDialog(
        title:  Text(dialogTitle,style: dialogStyle.dialogTitleStyle),
            content:  Text(dialogMessage,style: dialogStyle.dialogMessageStyle,),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child:  Text(dialogButtonTitle),
              ),
            ],
           
    ));
    
  }

  
  Future<T?> registerDialog<T>(context) {
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

}

class AppDialogStyle {
  final TextStyle dialogTitleStyle = const TextStyle(
    color: Colors.white,
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
  );

  final TextStyle dialogMessageStyle = const TextStyle(
    color: Colors.black,
    fontSize: 16.0,
  );

 
}

  


import 'package:fam_works/constants/app_borders.dart';
import 'package:flutter/material.dart';


mixin LoginTextFields on StatelessWidget {

   _LoginHintTexts  get _loginHintTexts => const _LoginHintTexts();

   final Color fillColor = Colors.purple.shade50;

  InputDecoration get emailTfStyle => InputDecoration(
        hintText: _loginHintTexts.emailHint,
        border: OutlineInputBorder(
          borderRadius: AppBorders.circularLow()
        ),
        prefixIcon: const Icon(Icons.email),
        filled: true,
        fillColor: fillColor
      );

      InputDecoration get passwordTfStyle => InputDecoration(
        hintText: _loginHintTexts .passwordHint,
        border: OutlineInputBorder(
          borderRadius: AppBorders.circularLow()
        ),
        prefixIcon: const Icon(Icons.lock),     
        filled: true,
        fillColor: fillColor
      );

       

      
      String emailTfIsEmpty = "Lütfen email adresinizi giriniz";
      String emailTfLeastCharacters = "Lütfen en az 7 karakter giriniz";
      String passwordTfIsEmpty = "Lütfen şifre giriniz";
      String passwordTfLeastCharacters = "Lütfen en az 6 karakter giriniz";
    
}



@immutable
class _LoginHintTexts {

  final String passwordHint = 'Şifre';
  final String emailHint = 'Email';

  const _LoginHintTexts();
}
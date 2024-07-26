import 'package:fam_works/core/constants/app_borders.dart';
import 'package:flutter/material.dart';


mixin RegisterTextFields on StatelessWidget {

   _RegisterHintTexts get _registerHintTexts => const _RegisterHintTexts();

   final Color fillColor = Colors.purple.shade50;

  InputDecoration get nameTfStyle => InputDecoration(
        hintText: _registerHintTexts.nameHint,
        border: OutlineInputBorder(
          borderRadius: AppBorders.circularLow()
        ),
        prefixIcon: const Icon(Icons.person),
        filled: true,
        fillColor: fillColor
      );

      InputDecoration get passwordTfStyle => InputDecoration(
        hintText: _registerHintTexts.passwordHint,
        border: OutlineInputBorder(
          borderRadius: AppBorders.circularLow()
        ),
        prefixIcon: const Icon(Icons.lock),
        filled: true,
        fillColor: fillColor
      );

       InputDecoration get homeCodeTfStyle => InputDecoration(
        hintText: _registerHintTexts.homeCodeHint,
        border: OutlineInputBorder(
          borderRadius: AppBorders.circularLow()
        ),
        prefixIcon: const Icon(Icons.home),
        filled: true,
        fillColor: fillColor
      );

      InputDecoration get emailTfStyle => InputDecoration(
        hintText: _registerHintTexts.emailHint,
        border: OutlineInputBorder(
          borderRadius: AppBorders.circularLow()
        ),
        prefixIcon: const Icon(Icons.email),
        filled: true,
        fillColor: fillColor
      );

      String nameTfIsEmpty = "Lütfen isminizi giriniz";
      String nameTfLeastCharacters = "Lütfen en az 3 karakter giriniz";
      String emailTfIsEmpty = "Lütfen email adresinizi giriniz";
      String emailTfLeastCharacters = "Lütfen en az 7 karakter giriniz";
      String passwordTfIsEmpty = "Lütfen şifre giriniz";
      String passwordTfLeastCharacters = "Lütfen en az 6 karakter giriniz";
      String homeCodeTfIsEmpty = "Lütfen ev kodu giriniz";
      String homeCodeTfLeastCharacters = "Lütfen en az 2 karakter giriniz";
}



@immutable
class _RegisterHintTexts {
  final String nameHint = 'İsim';
  final String passwordHint = 'Şifre';
  final String homeCodeHint = 'Ev Kodu';
  final String emailHint = 'Email';

  const _RegisterHintTexts();
}
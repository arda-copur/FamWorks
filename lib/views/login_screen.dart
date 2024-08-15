import 'package:fam_works/constants/app_borders.dart';
import 'package:fam_works/constants/app_colors.dart';
import 'package:fam_works/constants/app_paddings.dart';
import 'package:fam_works/constants/app_texts.dart';
import 'package:fam_works/auth/login/widgets/login_email_textfield.dart';
import 'package:fam_works/auth/login/widgets/login_password_textfield.dart';
import 'package:fam_works/feature/services/auth/user_auth.dart';
import 'package:fam_works/feature/utils/app_box.dart';
import 'package:fam_works/feature/utils/navigator_helper.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final UserAuth auth = UserAuth();
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                  AppTexts.againWelcome,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white),
                ),
                const AppHeightBox(),
                const Text(
                  AppTexts.clickForLogin,
                  style: TextStyle(color: Colors.white60),
                ),
                const AppHeightBox(height: 30),
                LoginEmailTextfield(
                    emailController: loginEmailController),
                const AppHeightBox(height: 16),
                LoginPasswordTextfield(
                    passwordController: loginPasswordController),
                const AppHeightBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppBorders.circularLow()
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        auth.loginUser(
                          loginEmailController.text,
                          loginPasswordController.text,
                          context
                        );
                      }
                    },
                    child: const Text(
                      AppTexts.login,
                      style: TextStyle(
                          color: AppColors.bgColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
                const AppHeightBox(height: 16),
                TextButton(
                  onPressed: () {
                    NavigatorHelper.navigateToView(context, 'register');
                  },
                  child: const Text(
                    AppTexts.dontHaveAccount,
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

}

import 'package:flutter/material.dart';
import 'package:gsg2_firebase/Auth/helpers/auth_helper.dart';
import 'package:gsg2_firebase/Auth/ui/login_page.dart';
import 'package:gsg2_firebase/chats/home_page.dart';
import 'package:gsg2_firebase/services/custom_dialoug.dart';
import 'package:gsg2_firebase/services/routes_helper.dart';

class AuthProvider extends ChangeNotifier {
  TabController tabController;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  resetControllers() {
    emailController.clear();
    passwordController.clear();
  }

  register() async {
    try {
      await AuthHelper.authHelper
          .signup(emailController.text, passwordController.text);
      await AuthHelper.authHelper.verifyEmail();
      await AuthHelper.authHelper.logout();
      tabController.animateTo(1);
    } on Exception catch (e) {
      // TODO
    }
// navigate to login

    resetControllers();
  }

  login() async {
    await AuthHelper.authHelper
        .signin(emailController.text, passwordController.text);
    bool isVerifiedEmail = AuthHelper.authHelper.checkEmailVerification();
    if (isVerifiedEmail) {
      RouteHelper.routeHelper.goToPageWithReplacement(HomePage.routeName);
    } else {
      CustomDialoug.customDialoug.showCustomDialoug(
          'You have to verify your email, press ok to send another email',
          sendVericiafion);
    }
    resetControllers();
  }

  sendVericiafion() {
    AuthHelper.authHelper.verifyEmail();
    AuthHelper.authHelper.logout();
  }

  resetPassword() async {
    AuthHelper.authHelper.resetPassword(emailController.text);
    resetControllers();
  }
}

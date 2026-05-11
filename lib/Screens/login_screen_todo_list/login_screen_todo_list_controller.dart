part of 'login_screen_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/api/auth_service.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LoginScreenController extends GetxController {
  var emailCtrl = TextEditingController();
  var passwordCtrl = TextEditingController();

  var authService = AuthService();
  var isLoading = false.obs;

  void login() async {
    try {
      var response = await authService.loginService(
        email: emailCtrl.text,
        password: passwordCtrl.text,
      );
      if (response["result"] == true) {
        Get.snackbar("Success", "Login success");
      } else {
        Get.snackbar("Failed", "Login Failed");
      }
    } catch (e) {
      Get.snackbar("Failed", "Login Failed");
    }
  }
}

import 'package:dio_todo_llist/Screens/routes/app_routes.dart';
import 'package:dio_todo_llist/core/api/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class RegisterTodoListViewController extends GetxController {
  var refnCtrl = TextEditingController();
  var reEmailCtrl = TextEditingController();
  var rePassCtrl = TextEditingController();
  var reConfirmPassCtrl = TextEditingController();
  var isLoading = false.obs;
  var authService = AuthService();

  @override
  void onClose() {
    refnCtrl.dispose();
    reEmailCtrl.dispose();
    rePassCtrl.dispose();
    reConfirmPassCtrl.dispose();
    super.onClose();
  }

  

  void register() async {
    try {
      isLoading.value = true;
      var respone = await authService.registerService(
        name: refnCtrl.text,
        email: reEmailCtrl.text,
        password: rePassCtrl.text,
      );
      if (respone["result"] == true) {
        Get.snackbar("success", "Register success");
        isLoading.value = false;
        Get.offAllNamed(AppRoutes.login);
      }
    } catch (e) {
      Get.snackbar("Failed", "Register fales");
      isLoading.value = false;
    }
  }
}

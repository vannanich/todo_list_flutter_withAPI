part of 'register_todo_list_view.dart';

class RegisterTodoListViewController extends GetxController {
  var refnCtrl = TextEditingController();
  var reEmailCtrl = TextEditingController();
  var rePassCtrl = TextEditingController();
  var reConfirmPassCtrl = TextEditingController();
  var isLoading = false.obs;
  var authService = AuthService();

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

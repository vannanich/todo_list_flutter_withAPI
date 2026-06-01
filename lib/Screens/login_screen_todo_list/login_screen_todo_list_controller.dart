part of 'login_screen_todo_list_view.dart';

class LoginScreenTodoListViewController extends GetxController {
  var emailCtrl = TextEditingController();
  var passCtrl = TextEditingController();

  var authService = AuthService();
  var isLoading = false.obs;
  var box = GetStorage();

  var rememberMe = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSavedCredentials();
  }
  

  void _loadSavedCredentials() {
    final savedEmail = box.read("saved_email") ?? "";
    final savedPass = box.read("saved_password") ?? "";
    final wasRemembered = box.read("remember_me") ?? false;

    if (wasRemembered) {
      emailCtrl.text = savedEmail;
      passCtrl.text = savedPass;
      rememberMe.value = true;
    }
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  void login() async {
    try {
      isLoading.value = true;
      var response = await authService.loginService(
        email: emailCtrl.text,
        password: passCtrl.text,
      );

      if (response["result"] == true) {
        if (rememberMe.value) {
          box.write("saved_email", emailCtrl.text);
          box.write("saved_password", passCtrl.text);
          box.write("remember_me", true);
        } else {
          box.remove("saved_email");
          box.remove("saved_password");
          box.write("remember_me", false);
        }

        Get.snackbar("Success", "Login success");
        isLoading.value = false;
        box.write("token", response["data"]["token"]);
        Get.offAllNamed(AppRoutes.home);
        debugPrint("Token : ${response["data"]["token"]}");
      } else {
        Get.snackbar("Failed", "Login Failed");
        isLoading.value = false;
      }
    } catch (error) {
      Get.snackbar("Failed", "Login Failed");
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.onClose();
  }

  // @override
  // void onClose() {
  //   super.onClose();  
  // }
}
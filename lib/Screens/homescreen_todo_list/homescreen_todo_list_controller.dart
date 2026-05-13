part of 'homescreen_todo_list_view.dart';

class HomescreenTodoListViewController extends GetxController {
  var authService = AuthService();
  var box = GetStorage();
  var user = {}.obs;
  var isLoading = false.obs;
  late UserModel userr;

  void getProfile() async {
    isLoading.value = true;

    var respone = await authService.fixProfile();
    isLoading.value = false;
    // user.value = respone;
    userr = UserModel.fromMap(respone["data"]);

    debugPrint(respone.toString());
  }

  void logout() {
    box.remove("token");
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getProfile();
  }
}

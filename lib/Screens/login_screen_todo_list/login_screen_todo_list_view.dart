import 'package:dio_todo_llist/Screens/routes/app_routes.dart';
import 'package:dio_todo_llist/core/api/auth_service.dart';
import 'package:dio_todo_llist/widgets/textFields/custom_textFields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

part 'login_screen_todo_list_binding.dart';
part 'login_screen_todo_list_controller.dart';

class LoginScreenTodoListView
    extends GetView<LoginScreenTodoListViewController> {
  const LoginScreenTodoListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Screen")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            CustomTextField(
              controller: controller.emailCtrl,
              hintText: "Enter Email...",
              // prefix: Icons.email,
              ),
            SizedBox(height: 20),
            CustomTextField(
              controller: controller.passCtrl,
              hintText: "Enter Password ...",
              // prefix: Icons.password_sharp,
              // suffix: Icons.visibility,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                controller.login();
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Obx(
                  () => Center(
                    child: controller.isLoading.value
                        ? CircularProgressIndicator()
                        : GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoutes.home);
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 29),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account ?",
                  style: TextStyle(color: Colors.black),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.register);
                  },
                  child: Text(
                    " Sign Up",
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

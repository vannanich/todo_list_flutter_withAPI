import 'package:dio_todo_llist/Screens/routes/app_routes.dart';
import 'package:dio_todo_llist/core/api/auth_service.dart';
import 'package:dio_todo_llist/widgets/textFields/custom_textFields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'register_todo_list_binding.dart';
part 'register_todo_list_controller.dart';

class RegisterTodoListView extends GetView<RegisterTodoListViewController> {
  const RegisterTodoListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register Screen")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            custom_textfield(
              controller: controller.refnCtrl,
              hintText: "Enter Full name",
              prefix: Icons.people,
            ),
            SizedBox(height: 20),
            custom_textfield(
              controller: controller.reEmailCtrl,
              hintText: "Enter Email...",
              prefix: Icons.email,
            ),
            SizedBox(height: 20),
            custom_textfield(
              controller: controller.rePassCtrl,
              hintText: "Enter Password ...",
              prefix: Icons.password_sharp,
              suffix: Icons.visibility,
            ),

            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                controller.register();
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
                        : Text(
                            "Register",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 29),
            Text(
              "You already have account ? ",
              style: TextStyle(color: Colors.black),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.login);
              },
              child: Text(
                " login",
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

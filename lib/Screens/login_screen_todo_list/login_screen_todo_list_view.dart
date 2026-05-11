import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/textFields/custom_textFields.dart';
import 'package:get/get.dart';

part 'login_screen_todo_list_binding.dart';

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
            custom_textfield(
              controller: controller.emailCtrl,
              hintText: "Enter Email...",
              prefix: Icons.email,
            ),
            SizedBox(height: 20),
            custom_textfield(
              controller: controller.passCtrl,
              hintText: "Enter Password ...",
              prefix: Icons.password_sharp,
              suffix: Icons.visibility,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {},
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    "Login",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

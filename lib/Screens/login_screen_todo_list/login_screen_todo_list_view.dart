import 'package:dio_todo_llist/Screens/routes/app_routes.dart';
import 'package:dio_todo_llist/core/api/auth_service.dart';
import 'package:dio_todo_llist/widgets/textFields/custom_textFields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

part 'login_screen_todo_list_binding.dart';
part 'login_screen_todo_list_controller.dart';

class LoginScreenTodoListView
    extends GetView<LoginScreenTodoListViewController> {LoginScreenTodoListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 SizedBox(height: 24),

                Container(
                  width: 36,
                  height: 36,
                  decoration:  BoxDecoration(
                    // color: Colors.red,
                    image: DecorationImage(image: AssetImage("assets/misc.png",))
                    
                  ),
                ),
                 SizedBox(height: 24),

                 Text(
                  "SIGN IN",
                  style: GoogleFonts.nunito(
                    fontSize: 42,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                 SizedBox(height: 4),
                 Text(
                  "Manage your tasks",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),

                 SizedBox(height: 90),

                CustomTextField(
                  controller: controller.emailCtrl,
                  hintText: "Enter your email address",
                ),
                 SizedBox(height: 12),

                CustomTextField(
                  controller: controller.passCtrl,
                  hintText: "Enter your password",
                  isPassword: true,
                  // suffix: Icons.visibility,
                ),

                 SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Checkbox(
                            value: false,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (_) {},
                          ),
                        ),
                         SizedBox(width: 8),
                         Text("Remember me?",
                            style: TextStyle(fontSize: 13, color: Colors.black87)),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {},
                      child:  Text(
                        "Forget password",
                        style: TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                    ),
                  ],
                ),

                 SizedBox(height: 54),

                GestureDetector(
                  onTap: () => controller.login(),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    
                    child: Obx(
                      () => Stack(
                        alignment: Alignment.center,
                        children: [
                          controller.isLoading.value
                              ?  CircularProgressIndicator(color: Colors.white)
                              :  Text(
                                  "Continue",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                          if (!controller.isLoading.value)
                            Positioned(
                              right: 8,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child:  Icon(
                                
                                  Icons.arrow_outward,
                                  color: Colors.black,
                                  size: 18,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                 SizedBox(height: 100),

                Row(
                  children: [
                     Expanded(child: Divider(color: Colors.black26)),
                    Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "or continue with",
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ),
                     Expanded(child: Divider(color: Colors.black26)),
                  ],
                ),

                 SizedBox(height: 16),

                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                       Text(
                        "Continue with Google",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Positioned(
                        right: 8,
                        child: Container(
                          width: 40,
                          height: 40,
                         
                         child: Image(image: AssetImage("assets/google.png")),
                      ),
                      ),
                    ],
                  ),
                ),

                 SizedBox(height: 32),

                Center(
                  child: RichText(
                    text: TextSpan(
                      style:  TextStyle(fontSize: 13, color: Colors.black54),
                      children: [
                         TextSpan(text: "Don't have an account? "),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.register),
                            child:  Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                 SizedBox(height: 16),

                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text:  TextSpan(
                      style: TextStyle(fontSize: 11, color: Colors.black45),
                      children: [
                        TextSpan(text: "By signing in, you accept our "),
                        TextSpan(
                          text: "Terms of Service",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        TextSpan(text: " and\n"),
                        TextSpan(
                          text: "Privacy Policy",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        TextSpan(text: "."),
                      ],
                    ),
                  ),
                ),

                 SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
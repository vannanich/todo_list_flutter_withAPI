import 'package:dio_todo_llist/Screens/register_todo_list/register_todo_list_controller.dart';
import 'package:dio_todo_llist/Screens/routes/app_routes.dart';
import 'package:dio_todo_llist/widgets/textFields/custom_textFields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


part 'register_todo_list_binding.dart';

class RegisterTodoListView extends GetView<RegisterTodoListViewController>{
   RegisterTodoListView({super.key});

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
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  child: Image(image: AssetImage("assets/misc.png",),),
                ),

                 SizedBox(height: 24),

                 Text(
                  "SIGN UP",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.2,
                    color: Colors.black,
                  ),
                ),
                 SizedBox(height: 4),
                 Text(
                  "Turn Khmer documents, images, and PDFs into\neditable text instantly.",
                  style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.4),
                ),

                 SizedBox(height: 48),

                CustomTextField(
                  controller: controller.refnCtrl,
                  hintText: "Enter your full name",
                ),
                 SizedBox(height: 12),
                CustomTextField(
                  controller: controller.reEmailCtrl,
                  hintText: "Enter your email address",
                ),
                 SizedBox(height: 12),
                CustomTextField(
                  suffixIcon: Icons.visibility,
                  controller: controller.rePassCtrl,
                  hintText: "Enter your password",
                  isPassword: true,
                  // suffix: Icons.visibility,
                ),
                 SizedBox(height: 12),
                CustomTextField(
                  suffixIcon: Icons.visibility,
                  controller: controller.reConfirmPassCtrl,
                  hintText: "Confirm password",
                  isPassword:true,
                  // suffix: Icons.visibility,
                ),

                 SizedBox(height: 24),
                GestureDetector(
                  onTap: () => controller.register(),
                  child: Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: 
                  
                    
              
                   Obx(
                    () =>  Stack(
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
                   )
                    ),
                  ),
                

                 SizedBox(height: 90),
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
                          color: Colors.black87,
                        ),
                      ),
                      Positioned(
                        right: 8,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child:  SizedBox(
                            width: 70,
                            height: 70,
                            child: Image(image: AssetImage("assets/google.png"))),
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
                         TextSpan(text: "Really have account ? "),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.login),
                            child:  Text(
                              "Sign In",
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
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        TextSpan(text: " and\n"),
                        TextSpan(
                          text: "Privacy Policy",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
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
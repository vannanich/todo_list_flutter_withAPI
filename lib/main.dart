import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/routes/app_pages.dart';
import 'package:flutter_application_1/Screens/routes/app_routes.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppRoutes.login,
      getPages: AppPages.routes,
    );
  }
}

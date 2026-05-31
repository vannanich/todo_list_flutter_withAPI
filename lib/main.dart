// import 'package:dio_todo_llist/Screens/routes/app_pages.dart';
// import 'package:dio_todo_llist/Screens/routes/app_routes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:get_storage/get_storage.dart';

// void main() async {
//   await GetStorage.init();

//   runApp(const MainApp());
// }

// class MainApp extends StatefulWidget {
//   const MainApp({super.key});

//   @override
//   State<MainApp> createState() => _MainAppState();
// }
// class _MainAppState extends State<MainApp> {
  
//   var box = GetStorage();
//   String? token;

//   void getToken() {
//     setState(() {
//       token = box.read("token");
//     });

//     debugPrint("token : $token");
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getToken();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,    
//       initialRoute: token != null ? AppRoutes.login : AppRoutes.login,
//       getPages: AppPages.routes,
//     );
//   }
// }

import 'package:dio_todo_llist/Screens/routes/app_pages.dart';
import 'package:dio_todo_llist/Screens/routes/app_routes.dart';
import 'package:dio_todo_llist/core/api/theme/theme_color/theme_color_controller.dart';
import 'package:dio_todo_llist/core/app_theme/app_theme_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
void main() async {
  await GetStorage.init();
  Get.put(ThemeColorController());
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splashScreen,
        getPages: AppPages.routes,
        theme: AppTheme.light,        
        darkTheme: AppTheme.dark,      
        themeMode: ThemeColorController.to.themeMode.value,
      ),
    );
  }
}
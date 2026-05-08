import 'package:flutter_application_1/Screens/login_screen_todo_list/login_screen_todo_list_view.dart';
import 'package:get/get.dart';

import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreenTodoListView(),
      binding: LoginScreenTodoListViewBinding(),
    ),
  ];
}

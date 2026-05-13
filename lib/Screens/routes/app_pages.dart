import 'package:dio_todo_llist/Screens/homescreen_todo_list/homescreen_todo_list_view.dart';
import 'package:dio_todo_llist/Screens/login_screen_todo_list/login_screen_todo_list_view.dart';
import 'package:dio_todo_llist/Screens/register_todo_list/register_todo_list_view.dart';
import 'package:get/get.dart';

import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => HomescreenTodoListView(),
      binding: HomescreenTodoListViewBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreenTodoListView(),
      binding: LoginScreenTodoListViewBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => RegisterTodoListView(),
      binding: RegisterTodoListViewBinding(),
    ),
  ];
}

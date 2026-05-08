part of 'login_screen_todo_list_view.dart';

class LoginScreenTodoListViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => LoginScreenTodoListViewController());
   }
}
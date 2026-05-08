part of 'register_todo_list_view.dart';

class RegisterTodoListViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => RegisterTodoListViewController());
   }
}
part of 'homescreen_todo_list_view.dart';

class HomescreenTodoListViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => HomescreenTodoListViewController());
   }
}
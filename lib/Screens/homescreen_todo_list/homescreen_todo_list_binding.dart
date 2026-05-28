

part of 'homescreen_todo_list_view.dart';

class HomeScreenViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => HomescreenTodoListController(),);
   }
}
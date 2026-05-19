

import 'package:dio_todo_llist/Screens/homescreen_todo_list/homescreen_todo_list_controller.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/instance_manager.dart';

class HomeScreenViewBinding extends Bindings {

   @override
   void dependencies() {
       Get.lazyPut(() => HomescreenTodoListController());
   }
}


import 'package:dio_todo_llist/Screens/routes/app_routes.dart';
import 'package:dio_todo_llist/core/api/auth_service.dart';
import 'package:dio_todo_llist/core/api/services/tasks_services.dart';
import 'package:dio_todo_llist/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class HomescreenTodoListController extends GetxController {
  var authService = AuthService();
  var taskService = TasksServices();
  var box = GetStorage();
  var argument = Get.arguments;
  var isDeleting = false.obs;
  late UserModel user;
  var tasks = [].obs;
  var isLoading = false.obs;

  void getProfile() async {
    isLoading.value = true;

    var response = await authService.fixProfile();

    isLoading.value = false;

    user = UserModel.fromMap(response["data"]);

    debugPrint(response.toString());
  }

  var isLoadTask = false.obs;

  void getTasks() async {
    isLoadTask.value = true;
    var response = await taskService.fetchTask();
    isLoadTask.value = false;

    tasks.value = response["data"];

    debugPrint(response.toString());
  }

  void deleteTask({required String id,required int index}) async {
    try {

      isDeleting.value = true;
      var response = await taskService.deleteTask(id: id);

      debugPrint("Response $response");

      if (response["result"] == true) {
        Get.snackbar("Success", "Task deleted");
        isDeleting.value = false;
        tasks.removeAt(index);
      }
    } catch (e) {
      debugPrint("Task Delete error : ${e.toString()}");
      isDeleting.value = false;
    }
  }

  void onDeleteTask({required String id, required int index}) {
    Get.dialog(
      AlertDialog(
        title: Text("Delete Task"),
        content: Text("Are you sure?"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: Text("No"),
          ),
          Obx( () => ElevatedButton(
            onPressed: () {
              Get.back();
              deleteTask(id: id, index: index);
              // Get.back();
            },
            child: isDeleting.value?CircularProgressIndicator():Text("Yes") ,
          ),)
          // ElevatedButton(
          //   onPressed: () {
          //     deleteTask(id: id);
          //     Get.back();
          //   },
          //   child: isDeleting.value?CircularProgressIndicator():Text("Yes") ,
          // ),
        ],
      ),
    );

    // showDialog(context: Get.context!, builder: builder)
  }

  void logout() {
    box.remove("token");
    Get.offAllNamed(AppRoutes.login);
  }

  String formattedDate(String date) {
    // convert from string to datetime
    var formatString = DateTime.parse(date);
    var formatedDate = DateFormat("dd/MMM/yyyy").format(formatString);
    return formatedDate;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getProfile();
    getTasks();
  }
}

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

  late UserModel user;

  var tasks = [].obs;

  var completingTaskId = "".obs;

  var isLoading = false.obs;
  var isDeleting = false.obs;
  var isLoadTask = false.obs;
  var isCompleting = false.obs;

  List<dynamic> get doneTaskList => tasks.where((task) {
    return task["completed"] == true;
  }).toList();

  List<dynamic> get boardTaskList => tasks.where((task) {
    return task["completed"] == false;
  }).toList();

  void getProfile() async {
    isLoading.value = true;

    var response = await authService.fixProfile();

    isLoading.value = false;

    user = UserModel.fromMap(response["data"]);

    debugPrint(response.toString());
  }

  void getTasks() async {
    isLoadTask.value = true;
    var response = await taskService.fetchTask();
    isLoadTask.value = false;

    tasks.value = response["data"];

    debugPrint(response.toString());
  }

  void deleteTask({required String id, required int index}) async {
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
          Obx(
            () => ElevatedButton(
              onPressed: () {
                Get.back();
                deleteTask(id: id, index: index);
              },
              child: isDeleting.value
                  ? CircularProgressIndicator()
                  : Text("Yes"),
            ),
          ),
        ],
      ),
    );

    // showDialog(context: Get.context!, builder: builder)
  }

  void logout() {
    box.remove("token");
    Get.offAllNamed(AppRoutes.login);
  }

  String formattedDateTime(String date) {
    var formatString = DateTime.parse(date);

    var formattedDate = DateFormat("dd MMM, yyyy").format(formatString);

    return formattedDate;
  }

  void markCompleteTask({required String id, required int index}) async {
    try {
      isCompleting.value = true;
      completingTaskId.value = id;
      var response = await taskService.markCompleteTask(id: id);

      if (response["result"] == true) {
        tasks.refresh();
        tasks[index]["completed"] = true; //update ui
        isCompleting.value = false;
        Get.snackbar("Success", response["messaeg"]);
      }
    } catch (e) {
      tasks[index]["completed"] = false;
      isCompleting.value = false;
      Get.snackbar("Failed", "Something went wrong!");
      debugPrint("Task Complete error : ${e.toString()}");
    }
  }

  void unMarkCompleteTask({required String id, required int index}) async {
    try {
      isCompleting.value = true;
      completingTaskId.value = id;
      var response = await taskService.unMarkCompleteTask(id: id);

      if (response["result"] == true) {
        tasks.refresh();
        tasks[index]["completed"] = false; //update ui
        isCompleting.value = false;

        Get.snackbar("Success", response["messaeg"]);
      }
    } catch (e) {
      tasks[index]["completed"] = true;
      isCompleting.value = false;
      Get.snackbar("Failed", "Something went wrong!");
      debugPrint("Task Complete error : ${e.toString()}");
    }
  }

  void toggleMarkComplete({required String id}) {
    var taskIndex = tasks.indexWhere((element) => element["id"] == id);

    if (tasks[taskIndex]["completed"]) {
      unMarkCompleteTask(id: id, index: taskIndex);
    } else {
      markCompleteTask(id: id, index: taskIndex);
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getProfile();
    getTasks();
  }
}

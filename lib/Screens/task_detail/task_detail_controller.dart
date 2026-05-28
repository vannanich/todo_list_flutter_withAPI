part of 'task_detail_view.dart';

class TaskDetailController extends GetxController {
  var taskService = TasksServices();

  late Map<String, dynamic> task;

  var isCompleting = false.obs;
  var isDeleting = false.obs;

  @override
  void onInit() {
    super.onInit();
    // receive task object passed from home screen
    task = Map<String, dynamic>.from(Get.arguments);
  }

  String formattedDate(String? date) {
    if (date == null) return "N/A";
    try {
      var parsed = DateTime.parse(date);
      return DateFormat("dd - MMM - yyyy").format(parsed).toUpperCase();
    } catch (e) {
      return "N/A";
    }
  }

  void toggleMarkComplete() async {
    try {
      isCompleting.value = true;
      if (task["completed"] == true) {
        var response = await taskService.unMarkCompleteTask(id: task["id"]);
        if (response["result"] == true) {
          task["completed"] = false;
          Get.snackbar("Success", "Task marked as undone");
        }
      } else {
        var response = await taskService.markCompleteTask(id: task["id"]);
        if (response["result"] == true) {
          task["completed"] = true;
          Get.snackbar("Success", "Task marked as done");
        }
      }
      isCompleting.value = false;
    } catch (e) {
      isCompleting.value = false;
      Get.snackbar("Failed", "Something went wrong!");
      debugPrint("Toggle error: ${e.toString()}");
    }
  }

  void deleteTask() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Delete Task",
          style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w700),
        ),
        content: Text(
          "Are you sure you want to delete this task?",
          style: GoogleFonts.spaceGrotesk(color: Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: GoogleFonts.spaceGrotesk(color: Colors.black),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              Get.back(); // close dialog
              try {
                isDeleting.value = true;
                var response = await taskService.deleteTask(id: task["id"]);
                if (response["result"] == true) {
                  Get.snackbar("Success", "Task deleted");
                  Get.back(); // go back to home
                }
                isDeleting.value = false;
              } catch (e) {
                isDeleting.value = false;
                Get.snackbar("Failed", "Something went wrong!");
              }
            },
            child: Text(
              "Delete",
              style: GoogleFonts.spaceGrotesk(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
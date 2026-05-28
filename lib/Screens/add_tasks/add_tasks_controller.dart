part of 'add_tasks_view.dart';

class AddTasksViewController extends GetxController {
  var taskService = TasksServices();

  var nameCtrl = TextEditingController();
  var desCtrl = TextEditingController();
  var argument = Get.arguments;
  var isLoading = false.obs;
  var nameFocus = FocusNode();

  var selectedPriority = "".obs;
  final List<String> priorityOptions = ["Low Priority", "Medium Priority", "Hight Priority"];

  var startDate = Rxn<DateTime>();
  var dueDate = Rxn<DateTime>();

  String get formattedStartDate {
    if (startDate.value == null) return "Select date";
    return DateFormat("dd-MMM-yyyy").format(startDate.value!).toUpperCase();
  }

  String get formattedDueDate {
    if (dueDate.value == null) return "Optional";
    return DateFormat("dd-MMM-yyyy").format(dueDate.value!).toUpperCase();
  }

  void pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) startDate.value = picked;
  }

  void pickDueDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dueDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) dueDate.value = picked;
  }

  void createTask() async {
    if (nameCtrl.text.isNotEmpty && desCtrl.text.isNotEmpty) {
      isLoading.value = true;
      var response = await taskService.createTask(
        name: nameCtrl.text,
        description: desCtrl.text,
      );
      isLoading.value = false;
      if (response["result"] == true) {
        nameFocus.requestFocus();
        Get.back();
        Get.snackbar("Success", "Task created");
        nameCtrl.clear();
        desCtrl.clear();
        selectedPriority.value = "";
        startDate.value = null;
        dueDate.value = null;
      }
    } else {
      Get.snackbar("Failed", "All fields are required!");
    }
  }

  void updateTask() async {
    try {
      if (nameCtrl.text.isNotEmpty && desCtrl.text.isNotEmpty) {
        isLoading.value = true;
        var response = await taskService.updateTask(
          id: argument["id"],
          name: nameCtrl.text,
          description: desCtrl.text,
        );
        isLoading.value = false;
        if (response["result"] == true) {
          Get.back();
          Get.snackbar("Success", "Task updated");
          isLoading.value = false;
        }
      }
    } catch (e) {
      Get.snackbar("Failed", "");
      debugPrint("Update Task error : ${e.toString()}");
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (argument != null) {
      nameCtrl.text = argument["name"];
      desCtrl.text = argument["description"];
      selectedPriority.value = argument["priority"] ?? "";
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    desCtrl.dispose();
    nameFocus.dispose();
    super.onClose();
  }
}
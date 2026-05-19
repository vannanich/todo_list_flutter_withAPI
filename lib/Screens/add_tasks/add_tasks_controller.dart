part of 'add_tasks_view.dart';

class AddTasksViewController extends GetxController {
  var taskService = TasksServices();

  var nameCtrl = TextEditingController();
  var desCtrl = TextEditingController();
  var argument = Get.arguments;
  var isLoading = false.obs;
  var nameFocus = FocusNode();

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
        Get.snackbar("Success", "Task createed");
        nameCtrl.clear();
        desCtrl.clear();
        
      }
    } else {
      Get.snackbar("Failed", "All fields are required!");
    }
  }
void updateTask() async {
 try{
   if(nameCtrl.text.isNotEmpty && desCtrl.text.isNotEmpty){
    isLoading.value = true;
    var respone = await taskService.updateTask(id: argument["id"], name: nameCtrl.text, description: desCtrl.text);
    isLoading.value = false;

    if(respone["result"] == true){
      Get.back();
      Get.snackbar("Success", "Task updated");
      isLoading.value = false;
      
    }
  }

 }catch(e){
    Get.snackbar("Failed", "");
    debugPrint("Update Task error : ${e.toString()}");
    isLoading.value = false;
  }
}
@override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    if(argument!=null){
      nameCtrl.text = argument["name"];
      desCtrl.text = argument["description"];
    }
  }
}


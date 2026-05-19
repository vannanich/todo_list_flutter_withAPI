import 'package:dio_todo_llist/core/api/services/tasks_services.dart';
import 'package:dio_todo_llist/widgets/textFields/custom_textFields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'add_tasks_binding.dart';
part 'add_tasks_controller.dart';

class AddTasksView extends GetView<AddTasksViewController> {
  const AddTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Tasks")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text("Add Task", style: TextStyle(fontSize: 30, fontWeight: .bold)),
            SizedBox(height: 20),
            CustomTextField(
              hintText: "Enter task name",
              controller: controller.nameCtrl,
              focusNode: controller.nameFocus,
            ),
            SizedBox(height: 10),
            CustomTextField(
              hintText: "Enter task description",
              controller: controller.desCtrl,
              isMultiline: true,
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                // bat keyboard pel tse hx
                // FocusScope.of(Get.context!).unfocus();
                controller.argument != null ? controller.updateTask() :
                controller.createTask();
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: .circular(15),
                ),
                child: Center(
                  child: Obx(
                    () => controller.isLoading.value
                        ? CircularProgressIndicator()
                        : Text(
                            controller.argument != null ? "Update Task" : "Add Task",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

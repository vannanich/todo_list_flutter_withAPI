import 'package:dio_todo_llist/Screens/routes/app_routes.dart';
import 'package:dio_todo_llist/core/api/services/tasks_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

part 'task_detail_binding.dart';
part 'task_detail_controller.dart';

class TaskDetailView extends GetView<TaskDetailController> {
  const TaskDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),

      // ── AppBar ──
      appBar: AppBar(
        backgroundColor: Color(0xffF5F5F5),
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black12),
            ),
            child: Icon(Icons.arrow_back, color: Colors.black, size: 20),
          ),
        ),
        title: Text(
          "Task Detail",
          style: GoogleFonts.spaceGrotesk(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => controller.deleteTask(),
            child: Container(
              margin: EdgeInsets.all(8),
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black12),
              ),
              child: Icon(Icons.delete, color: Colors.red, size: 20),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),

            // ── Priority Badge ──
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xffE8F5E9),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                controller.task["priority"] ?? "Hight Priority",
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff2E7D32),
                ),
              ),
            ),

            SizedBox(height: 16),

            // ── Task Name ──
            Text(
              (controller.task["name"] ?? "").toUpperCase(),
              style: GoogleFonts.spaceGrotesk(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                height: 1.0,
                color: Colors.black,
              ),
            ),

            SizedBox(height: 12),

            // ── Description ──
            Text(
              controller.task["description"] ?? "",
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13,
                color: Colors.black54,
                height: 1.5,
              ),
            ),

            SizedBox(height: 20),

            // ── Status ──
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: controller.task["completed"] == true
                        ? Colors.grey
                        : Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  controller.task["completed"] == true
                      ? "Task completed"
                      : "Task in progress",
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: controller.task["completed"] == true
                        ? Colors.grey
                        : Colors.green,
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            // ── Divider ──
            Divider(color: Colors.black12),

            SizedBox(height: 16),

            // ── Start Date ──
            _dateRow(
              label: "Start Date",
              value: controller.formattedDate(controller.task["created_at"]),
            ),

            SizedBox(height: 16),

            // ── Due Date ──
            _dateRow(
              label: "Due Date",
              value: controller.task["due_date"] != null
                  ? controller.formattedDate(controller.task["due_date"])
                  : "Optional",
            ),

            Spacer(),

            // ── Bottom Buttons ──
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                children: [
                  // ── Edit Task ──
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.addTask,
                          arguments: controller.task,
                        )!.then((value) => Get.back());
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Center(
                          child: Text(
                            "Edit Task",
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 12),

                  // ── Mark as Done ──
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.toggleMarkComplete(),
                      child: Obx(
                        () => Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: controller.isCompleting.value
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    controller.task["completed"] == true
                                        ? "Mark Undone"
                                        : "Mark as Done",
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
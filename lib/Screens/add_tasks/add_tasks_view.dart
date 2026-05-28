import 'package:dio_todo_llist/core/api/services/tasks_services.dart';
import 'package:dio_todo_llist/widgets/textFields/custom_textFields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

part 'add_tasks_binding.dart';
part 'add_tasks_controller.dart';

class AddTasksView extends GetView<AddTasksViewController> {
  const AddTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, color: Colors.black, size: 20),
          ),
        ),
        title: Text(
          "Add New Tasks",
          style: GoogleFonts.spaceGrotesk(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),

            // ── Big Heading ──
            Text(
              controller.argument != null ? "EDIT TASK" : "ADD TASKS",
              style: GoogleFonts.spaceGrotesk(
                fontSize: 40,
                fontWeight: FontWeight.w800,
                height: 1.0,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Turn Khmer documents, images, and PDFs into\neditable text instantly.",
              style: GoogleFonts.spaceGrotesk(
                fontSize: 12,
                color: Colors.black45,
                height: 1.4,
              ),
            ),

            SizedBox(height: 24),

            // ── Title ──
            _label("Title"),
            SizedBox(height: 8),
            CustomTextField(
              hintText: "Enter your task title",
              controller: controller.nameCtrl,
              focusNode: controller.nameFocus,
            ),

            SizedBox(height: 16),

            // ── Description ──
            _label("Description"),
            SizedBox(height: 8),
            CustomTextField(
              hintText: "Enter your task description ...",
              controller: controller.desCtrl,
              isMultiline: true,
            ),

            SizedBox(height: 16),

            // ── Priority ──
            _label("Priority"),
            SizedBox(height: 8),
            Obx(
              () => _dropdownField(
                value: controller.selectedPriority.value.isEmpty
                    ? null
                    : controller.selectedPriority.value,
                hint: "Select task priority",
                items: controller.priorityOptions,
                onChanged: (val) {
                  if (val != null) controller.selectedPriority.value = val;
                },
              ),
            ),

            SizedBox(height: 16),

            // ── Start Date + Due Date ──
            Row(
              children: [
                // Start Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("Start Date"),
                      SizedBox(height: 8),
                      Obx(
                        () => _dateField(
                          value: controller.formattedStartDate,
                          onTap: () => controller.pickStartDate(context),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12),
                // Due Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("Due Date"),
                      SizedBox(height: 8),
                      Obx(
                        () => _dateField(
                          value: controller.formattedDueDate,
                          onTap: () => controller.pickDueDate(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 32),

            // ── Submit Button — KEPT EXACTLY THE SAME process ──
            GestureDetector(
              onTap: () {
                controller.argument != null
                    ? controller.updateTask()
                    : controller.createTask();
              },
              child: Container(
                width: double.infinity,
                height: 56,
                margin: EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Obx(
                      () => controller.isLoading.value
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              controller.argument != null ? "Update Task" : "Add Task",
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                    Obx(
                      () => !controller.isLoading.value
                          ? Positioned(
                              right: 8,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.arrow_outward,
                                  color: Colors.black,
                                  size: 18,
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Label widget ──
  Widget _label(String text) {
    return Text(
      text,
      style: GoogleFonts.spaceGrotesk(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }

  // ── Dropdown field ──
  Widget _dropdownField({
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            hint,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14,
              color: Colors.black45,
            ),
          ),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black54),
          style: GoogleFonts.spaceGrotesk(fontSize: 14, color: Colors.black),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ── Date field ──
  Widget _dateField({required String value, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 13,
                  color: value == "Optional" || value == "Select date"
                      ? Colors.black45
                      : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black54, size: 20),
          ],
        ),
      ),
    );
  }
}
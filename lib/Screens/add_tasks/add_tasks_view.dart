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
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration( 
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.arrow_back, color: cs.onSurface, size: 20), 
          ),
        ),
        title: Text(
          "Add New Tasks",
          style: GoogleFonts.spaceGrotesk(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),

            Text(
              controller.argument != null ? "EDIT TASK" : "ADD TASKS",
              style: GoogleFonts.spaceGrotesk(
                fontSize: 40,
                fontWeight: FontWeight.w800,
                height: 1.0,
                color: cs.onSurface, 
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Turn Khmer documents, images, and PDFs into\neditable text instantly.",
              style: GoogleFonts.spaceGrotesk(
                fontSize: 12,
                color: cs.onSurface.withOpacity(0.45), 
                height: 1.4,
              ),
            ),

            SizedBox(height: 24),

            _label("Title", context),
            SizedBox(height: 8),
            CustomTextField(
              hintText: "Enter your task title",
              controller: controller.nameCtrl,
              focusNode: controller.nameFocus,
              // textStyle: TextStyle(color: Colors.black),
            ),

            SizedBox(height: 16),

            _label("Description", context),
            SizedBox(height: 8),
            CustomTextField(
              hintText: "Enter your task description ...",
              controller: controller.desCtrl,
              isMultiline: true,
            ),

            SizedBox(height: 16),

            _label("Priority", context),
            SizedBox(height: 8),
            Obx(
              () => _dropdownField(
                context: context,
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

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("Start Date", context),
                      SizedBox(height: 8),
                      Obx(
                        () => _dateField(
                          context: context,
                          value: controller.formattedStartDate,
                          onTap: () => controller.pickStartDate(context),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _label("Due Date", context),
                      SizedBox(height: 8),
                      Obx(
                        () => _dateField(
                          context: context,
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
                  color: cs.onSurface, 
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Obx(
                      () => controller.isLoading.value
                          ? CircularProgressIndicator(color: cs.surface) 
                          : Text(
                              controller.argument != null ? "Update Task" : "Add Task",
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 16,
                                color: cs.surface, 
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
                                  color: cs.surface, 
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  Icons.arrow_outward,
                                  color: cs.onSurface, 
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

  Widget _label(String text, BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.spaceGrotesk(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface, 
      ),
    );
  }

  Widget _dropdownField({
    required BuildContext context,
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: cs.surface, 
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: Theme.of(context).cardColor, 
          hint: Text(
            hint,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14,
              color: cs.onSurface.withOpacity(0.45), 
            ),
          ),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              color: cs.onSurface.withOpacity(0.5)), 
          style: GoogleFonts.spaceGrotesk(
              fontSize: 14, color: cs.onSurface), 
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

  Widget _dateField({
    required BuildContext context, 
    required String value,
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(context).colorScheme;
    final isPlaceholder = value == "Optional" || value == "Select date";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: cs.surface, 
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
                  color: isPlaceholder
                      ? cs.onSurface.withOpacity(0.45)
                      : cs.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.keyboard_arrow_down_rounded,
                color: cs.onSurface.withOpacity(0.5), size: 20), 
          ],
        ),
      ),
    );
  }
}
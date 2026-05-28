import 'package:contentsize_tabbarview/contentsize_tabbarview.dart';
import 'package:dio_todo_llist/Screens/routes/app_routes.dart';
import 'package:dio_todo_llist/core/api/auth_service.dart';
import 'package:dio_todo_llist/core/api/services/tasks_services.dart' show TasksServices;
import 'package:dio_todo_llist/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

part 'homescreen_todo_list_binding.dart';
part 'homescreen_todo_list_controller.dart';

class HomeScreenView extends GetView<HomescreenTodoListController> {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.addTask)!.then((value) {
            controller.getTasks();
          });
        },
        child: Icon(Icons.add),
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          controller.getTasks();
          controller.getProfile();
        },
        child: DefaultTabController(
          length: 2,
          child: SafeArea(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── UI CHANGE: Profile row with settings icon ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Obx(
                      () => controller.isLoading.value
                          ? _buildProfilePlaceholder()
                          : _buildProfileHeader(),
                    ),
                  ),

                  // ── UI CHANGE: Big greeting text ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "GOOD\nMORNING!",
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 52,
                        fontWeight: FontWeight.w800,
                        height: 1.0,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // ── UI CHANGE: Date + progress row ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Obx(() {
                      final total = controller.boardTaskList.length + controller.doneTaskList.length;
                      final done = controller.doneTaskList.length;
                      final percent = total == 0 ? 0 : ((done / total) * 100).round();
                      final now = DateTime.now();
                      const days = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
                      const months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
                      final dayName = days[now.weekday % 7];
                      final dateStr = "${months[now.month - 1]} ${now.day.toString().padLeft(2,'0')}, ${now.year}";

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Today's $dayName",
                                  style: GoogleFonts.spaceGrotesk(fontSize: 13, fontWeight: FontWeight.w600)),
                              Text(dateStr,
                                  style: GoogleFonts.spaceGrotesk(fontSize: 12, color: Colors.black54)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("$percent% Done",
                                  style: GoogleFonts.spaceGrotesk(fontSize: 13, fontWeight: FontWeight.w700)),
                              Text("Completed Tasks",
                                  style: GoogleFonts.spaceGrotesk(fontSize: 12, color: Colors.black54)),
                            ],
                          ),
                        ],
                      );
                    }),
                  ),

                  SizedBox(height: 20),

                  // ── UI CHANGE: Tab bar with outlined badge ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildTabBar(),
                  ),

                  SizedBox(height: 16),

                  // ── KEPT EXACTLY THE SAME logic, just added padding ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ContentSizeTabBarView(
                      children: [
                        Obx(
                          () => controller.isLoadTask.value
                              ? _buildTaskPlaceholder()
                              : _buildTasksList(tasks: controller.boardTaskList),
                        ),
                        Obx(
                          () => controller.isLoadTask.value
                              ? _buildTaskPlaceholder()
                              : _buildTasksList(tasks: controller.doneTaskList),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── UI CHANGE: Tab bar style updated ──
  Widget _buildTabBar() {
    return Obx(
      () => TabBar(
        // ── KEPT EXACTLY THE SAME ──
        onTap: (value) {
          debugPrint("value of tab : $value");
          controller.tabIndex.value = value;
        },
        labelColor: Colors.black,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(width: 2, color: Colors.black),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: [
          // ── KEPT EXACTLY THE SAME logic ──
          tabbarItem(
            count: controller.boardTaskList.length,
            name: "Tasks",
            isSelected: controller.tabIndex.value == 0,
          ),
          tabbarItem(
            count: controller.doneTaskList.length,
            name: "Done",
            isSelected: controller.tabIndex.value == 1,
          ),
        ],
      ),
    );
  }

  // ── UI CHANGE: tabbarItem now uses isSelected instead of tabColor/countColor ──
  Widget tabbarItem({required int count, required String name, required bool isSelected}) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black26),
            ),
            child: Text(
              count.toString().padLeft(2, "0"),
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(width: 8),
          Text(
            name,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  // ── UI CHANGE: taller shimmer card ──
  Widget _buildTaskPlaceholder() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 2,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        );
      },
    );
  }

  // ── KEPT EXACTLY THE SAME logic ──
  Widget _buildTasksList({required List<dynamic> tasks}) {
    return tasks.isEmpty
        ? SizedBox(
            height: 120,
            child: Center(
              child: Text(
                "No Task!",
                style: GoogleFonts.spaceGrotesk(color: Colors.black38, fontSize: 15),
              ),
            ),
          )
        : ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return _taskCard(index: index, task: tasks);
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 12);
            },
            itemCount: tasks.length,
          );
  }

  Widget _taskCard({required int index, required List<dynamic> task}) {
  return GestureDetector( 
    onTap: () {
      Get.toNamed(AppRoutes.detailTask, arguments: task[index])!.then((value) {
        controller.getTasks(); // refresh after coming back
      });
    },
    child: Container( // everything inside stays the same
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _taskStatus(index: index, task: task),
          SizedBox(height: 14),
          _taskContent(index: index, task: task),
          SizedBox(height: 14),
          _dateNdone(index: index, task: task),
        ],
      ),
    ), // ✅ END GestureDetector
  );
}

  Widget _dateNdone({required int index, required List<dynamic> task}) {
    return Row(
      children: [
        Text(
          "Date : ${controller.formattedDateTime(task[index]["created_at"])}",
          style: GoogleFonts.spaceGrotesk(fontSize: 12, color: Colors.black45),
        ),
        Spacer(),

        GestureDetector(
          onTap: () {
            controller.toggleMarkComplete(id: task[index]["id"]);
          },
          child: Obx(
            () => Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                // ── UI CHANGE: black when done, white when not ──
                color: task[index]["completed"] ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: Colors.black12),
              ),
              child: Center(
                child: controller.isCompleting.value &&
                        controller.completingTaskId == task[index]["id"]
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        task[index]["completed"] ? "Done ✓" : "Mark as Done",
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: task[index]["completed"] ? Colors.white : Colors.black,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _taskContent({required int index, required List<dynamic> task}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          task[index]["name"].toUpperCase(),
          style: GoogleFonts.spaceGrotesk(fontSize: 22, fontWeight: FontWeight.w800),
        ),
        SizedBox(height: 4),
        Text(
          task[index]["description"],
          style: GoogleFonts.spaceGrotesk(fontSize: 13, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _taskStatus({required int index, required List<dynamic> task}) {
    return Row(
      children: [
        // ── UI CHANGE: border style priority badge ──
        Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.black12),
          ),
          child: Text(
            "Hight Priority",
            style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ),
        Spacer(),

        PopupMenuButton(
          position: PopupMenuPosition.under,
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                onTap: () {
                  Get.toNamed(AppRoutes.addTask, arguments: task[index])!.then((value) {
                    controller.getTasks();
                  });
                },
                child: Row(
                  children: [
                    Icon(Icons.edit_outlined, size: 18),
                    SizedBox(width: 10),
                    Text("Update",
                        style: GoogleFonts.spaceGrotesk(
                            color: Colors.black, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () {
                  controller.onDeleteTask(id: task[index]["id"], index: index);
                },
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red, size: 18),
                    SizedBox(width: 10),
                    Text("Delete",
                        style: GoogleFonts.spaceGrotesk(
                            color: Colors.red, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ];
          },
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.more_horiz, size: 18),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 22,
          backgroundImage: NetworkImage(controller.user.avatar),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.user.name.toUpperCase(),
              style: GoogleFonts.spaceGrotesk(
                  fontSize: 14, fontWeight: FontWeight.w700, height: 1.2),
            ),
            Text(
              controller.user.email,
              style: GoogleFonts.spaceGrotesk(
                  fontSize: 12, color: Colors.black45, height: 1.2),
            ),
          ],
        ),
        Spacer(),
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.settings_outlined, size: 20, color: Colors.black54),
        ),
      ],
    );
  }

  // ── UI CHANGE: cleaner shimmer ──
  Widget _buildProfilePlaceholder() {
    return Row(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade100,
          child: CircleAvatar(radius: 22, backgroundColor: Colors.grey),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.grey.shade100,
              child: Container(width: 100, height: 14, color: Colors.grey),
            ),
            SizedBox(height: 5),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.grey.shade100,
              child: Container(width: 140, height: 12, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}
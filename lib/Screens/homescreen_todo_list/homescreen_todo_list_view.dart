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
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Obx(
                      () => controller.isLoading.value
                          ? _buildProfilePlaceholder()
                          : _buildProfileHeader(),
                    ),
                  ),

                  SizedBox(height: 20),

                  _buildTabBar(),

                  SizedBox(height: 20),

                  ContentSizeTabBarView(
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Obx(() => 
    TabBar(
          onTap: (value) {
            debugPrint("value of tab : $value");
            controller.tabIndex.value=value;
          },
          labelColor: Colors.black,
          overlayColor: WidgetStateProperty.all(Colors.grey[200]),
          indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            width: 3,           // thickness
            color: Colors.black, // color
          ),),
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: [
            // tabbarItem(count: controller.boardCount, name: "Board",tabColor: controller.tabIndex.value==1 ?Colors.black:Colors.transparent ),
            // tabbarItem(count: controller.doneCount, name: "Done",),

            tabbarItem(
              count: controller.boardTaskList.length, 
              name: "Board",
              tabColor: controller.tabIndex.value == 0 ? Colors.black : Colors.transparent,
              countColor: controller.tabIndex.value == 0 ? "white" : "black",
            ),
            tabbarItem(
              count: controller.doneTaskList.length,   
              name: "Done",
              tabColor: controller.tabIndex.value == 1 ? Colors.black : Colors.transparent,
              countColor: controller.tabIndex.value == 1 ? "white" : "black",
            ),
            // Tab(text: "Board"),
            // Tab(text: "Done"),
          ],
        ),
    );
  }

  Widget tabbarItem({required int count , required String name , required Color tabColor,required String countColor}){
    return Row(
      mainAxisAlignment: .center,
      children: [
      // Text("count"),
      // SizedBox(width: 30,),
      // Text("Tab")
       Container(
        padding: .symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: .circular(20),
          color: tabColor,
        ),
      child: Text(count.toString().padLeft(2,"0"),style: TextStyle(color: countColor == "white" ? Colors.white : Colors.black),)),
      SizedBox(width: 10),
      Text(name,style: GoogleFonts.spaceGrotesk(fontSize: 20,fontWeight: FontWeight.bold,)),     
    ],);
  }

  Widget _buildTaskPlaceholder() {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade300,
          child: Container(height: 50, color: Colors.grey),
        );
      },
      itemCount: 2,
    );
  }

  Widget _buildTasksList({required List<dynamic> tasks}) {
    return tasks.isEmpty
        ? SizedBox(
          // height: ,
          child: Center(child: Text("No Task!")))
        : ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return _taskCard(index: index, task: tasks);
            },
            separatorBuilder: (context, index) {
              return SizedBox(height: 10);
            },
          itemCount: tasks.length,
        );
  }
  Widget _taskCard({required int index, required List<dynamic> task}) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xffD9D9D9).withValues(alpha: .5),
        borderRadius: .circular(35),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          _taskStatus(index: index, task: task),

          SizedBox(height: 20),

          _taskContent(index: index, task: task),

          SizedBox(height: 20),

          _dateNdone(index: index, task: task),
        ],
      ),
    );
  }

  Widget _dateNdone({required int index, required List<dynamic> task}) {
    return Row(
      children: [
        Text(
          "Date : ${controller.formattedDateTime(task[index]["created_at"])}",
          style: GoogleFonts.spaceGrotesk(fontSize: 15, fontWeight: .normal),
        ),
        Spacer(),

        GestureDetector(
          onTap: () {
            controller.toggleMarkComplete(id: task[index]["id"]);
          },
          child: Obx(
            () => Container(
              height: 45,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: .circular(50),
              ),
              child: Center(
                child:
                    controller.isCompleting.value &&
                        controller.completingTaskId == task[index]["id"]
                    ? CircularProgressIndicator()
                    : Text(
                        task[index]["completed"] ? "Done" : "Mark as Done",
                        style: GoogleFonts.spaceGrotesk(fontWeight: .bold),
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
      crossAxisAlignment: .start,
      children: [
        Text(
          task[index]["name"].toUpperCase(),
          style: GoogleFonts.spaceGrotesk(fontSize: 25, fontWeight: .bold),
        ),
        Text(
          task[index]["description"],
          style: GoogleFonts.spaceGrotesk(fontSize: 15, fontWeight: .normal),
        ),
      ],
    );
  }

  Widget _taskStatus({required int index, required List<dynamic> task}) {
    return Row(
      children: [
        Container(
          height: 45,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: .circular(50),
          ),
          child: Center(
            child: Text(
              "Hight Priority",
              style: GoogleFonts.spaceGrotesk(fontWeight: .bold),
            ),
          ),
        ),
        Spacer(),
        PopupMenuButton(
          position: PopupMenuPosition.under,
          color: Colors.white,

          itemBuilder: (context) {
            return [
              PopupMenuItem(
                onTap: () {
                  Get.toNamed(AppRoutes.addTask, arguments: task[index])!.then((
                    value,
                  ) {
                    controller.getTasks();
                  });
                },
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 10),
                    Text(
                      "Update",
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.black,
                        fontWeight: .bold,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () {
                  controller.onDeleteTask(id: task[index]["id"], index: index);
                },
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 10),
                    Text(
                      "Delete",
                      style: GoogleFonts.spaceGrotesk(
                        color: Colors.red,
                        fontWeight: .bold,
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(color: Colors.white, shape: .circle),
            child: Icon(Icons.more_horiz),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(controller.user.avatar),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              controller.user.name,
              style: TextStyle(fontSize: 20, fontWeight: .bold, height: 1.2),
            ),

            Text(
              controller.user.email,
              style: TextStyle(fontSize: 13, fontWeight: .normal, height: 1.2),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfilePlaceholder() {
    return Row(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade300,
          child: CircleAvatar(radius: 25),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: .start,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.grey.shade300,
              child: Container(width: 100, height: 20, color: Colors.grey),
            ),
            SizedBox(height: 5),
            Shimmer.fromColors(
              baseColor: Colors.grey.shade200,
              highlightColor: Colors.grey.shade300,
              child: Container(width: 150, height: 15, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}



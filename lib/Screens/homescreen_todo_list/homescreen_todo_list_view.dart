import 'package:dio_todo_llist/Screens/homescreen_todo_list/homescreen_todo_list_controller.dart';
import 'package:dio_todo_llist/Screens/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';



class HomeScreenView extends GetView<HomescreenTodoListController> {
  const HomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(controller.argument != null?"update task":"Goals List"),),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.addTask)!.then((value) {
            controller.getTasks();
          });
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              
              Obx(
                () => controller.isLoading.value
                    ? _buildProfilePlaceholder()
                    : _buildProfileHeader(),
              ),
              SizedBox(height: 20,),
              Obx(
                () => controller.isLoadTask.value
                    ? _buildTaskPlaceholder()
                    : _buildTasksList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskPlaceholder() {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade300,
          child: Container(height: 50, color: Colors.grey),
        );
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 10);
      },
      itemCount: 2,
    );
  }

    Widget _buildTasksList() {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return _buildTaskCard(index: index);
        
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: 10);
      },

      itemCount: controller.tasks.length,
      
    );
  }
  Widget _buildTaskCard({required int index}){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(child: Text("Nothing to do ",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
                        
                      ),
                      Spacer(),
                      PopupMenuButton(
                        position: PopupMenuPosition.under,
                        color: Colors.white,
                        itemBuilder: (context) => [
          
                          PopupMenuItem(
                            onTap: () {
                             Get.toNamed(
                            AppRoutes.addTask,
                            arguments: controller.tasks[index],
                          )!.then((value) {
                            controller.getTasks();
                          });
          
                            },
                            child: Row(
                              children: [
                                Text("Edit"),
                                SizedBox(width: 10,),
                                Icon(Icons.edit, size: 15,),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            onTap: () {
                             controller.onDeleteTask(
                            id: controller.tasks[index]["id"],
                            index: index,
                          );
                            },
                            child: Row(
                              children: [
                                Text("Delete"),
                                SizedBox(width: 10,),
                                Icon(Icons.delete, size: 15,),
                              ],
                            ),
                          ),
                        ],
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(Icons.more_horiz, color: Colors.black,),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Text(controller.tasks[index]["name"],style: GoogleFonts.spaceGrotesk(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
                  Text(controller.tasks[index]["description"],style: GoogleFonts.spaceGrotesk(color: Colors.white,fontSize:18),),
                  SizedBox(height: 40,),
                  Row(
                    children: [
                      Text(
                          "Date : ${controller.formattedDate(controller.tasks[index]["created_at"])}",
                          style: GoogleFonts.spaceGrotesk(fontSize: 15, fontWeight: .normal,color: Colors.white),
                        ),
              
                      Spacer(),
                      Container(
                        width: 120,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(child: Text("Marked as done",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)),
                      )
                    ],
                  ),
                ],
              ),
            
            ),
            
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
          crossAxisAlignment: CrossAxisAlignment.start,
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

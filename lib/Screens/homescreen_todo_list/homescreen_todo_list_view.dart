import 'package:dio_todo_llist/Screens/routes/app_routes.dart';
import 'package:dio_todo_llist/core/api/auth_service.dart';
import 'package:dio_todo_llist/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shimmer/shimmer.dart';

part 'homescreen_todo_list_binding.dart';
part 'homescreen_todo_list_controller.dart';

class HomescreenTodoListView extends GetView<HomescreenTodoListViewController> {
  const HomescreenTodoListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => controller.isLoading.value
                  ? _buildProfilePlaceholder()
                  : _buildProfile(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile() {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(controller.userr.avatar),
          // backgroundImage: NetworkImage(controller.user["data"]["avatar"]),
        ),
        const SizedBox(width: 10),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.userr.name,
              // controller.user["data"]?["name"] ?? "No Name",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            //  Text("nich@gmail.co", style: TextStyle(fontSize: 12)),
            Text(controller.userr.email, style: TextStyle(fontSize: 12)),
          ],
        ),
        ElevatedButton(
          onPressed: () => controller.logout(),
          child: const Text("Log out"),
        ),
      ],
    );
  }

  Widget _buildProfilePlaceholder() {
    return Row(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey,
          highlightColor: Colors.grey.shade100,
          child: const CircleAvatar(radius: 25),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: Colors.grey.shade100,
              child: Container(width: 100, height: 20, color: Colors.grey),
            ),
            Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: Colors.grey.shade100,
              child: Container(width: 150, height: 14, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }
}

part of 'task_detail_view.dart';

class TaskDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TaskDetailController(), fenix: true);
  }
}
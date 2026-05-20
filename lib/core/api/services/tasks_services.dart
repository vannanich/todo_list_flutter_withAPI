import 'package:dio_todo_llist/core/api/services/base_api_service.dart';

class TasksServices {
  final baseApiService = BaseApiService();

  Future<Map<String, dynamic>> fetchTask() async {
    var respone = await baseApiService.get(endpoint: "api/tasks");

    return respone;
  }

  Future<Map<String, dynamic>> createTask({
    required String name,
    required String description,
  }) async {
    var respone = await baseApiService.post(
      endpoint: "/api/tasks",
      data: {"name": name, "description": description},
    );
    return respone;
  }
   Future<Map<String, dynamic>> deleteTask({required String id}) async {
    var response = await baseApiService.delete(endpoint: "/api/tasks/$id");

    return response;
  }

  Future<Map<String,dynamic>> updateTask({
    required String id,
    required String name,
    required String description,
  }) async {
    var response = await baseApiService.put(
      endpoint: "/api/tasks/$id",
      data: {"name": name, "description": description},
    );

    return response;
  }

  Future<Map<String, dynamic>> markCompleteTask({required String id}) async {
    var respone = await BaseApiService().put(endpoint: "/api/tasks/mark-completed/$id");

    return respone;
  }
  Future<Map<String, dynamic>> unMarkCompleteTask({required String id}) async {
    var respone = await BaseApiService().put(endpoint: "/api/tasks/mark-completed/$id");

    return respone;
  }
}

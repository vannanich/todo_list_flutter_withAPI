// import 'package:dio/dio.dart';
// import 'package:dio_todo_llist/core/api/api_config.dart';
// import 'package:flutter/widgets.dart';

// class BaseApiService {
//   final ApiConfig apiConfig = ApiConfig();

//   Future<dynamic> post({
//     required String endpoint,
//     required Map<String, dynamic> data,
//   }) async {
//     try {
//       var respone = await apiConfig.dio.post(endpoint, data: data);
//       return respone.data;
//     } on DioException catch (e) {
//       // debugPrint("error : ${e.toString()}");
//       debugPrint("error : ${e.message}");
//     }
//   }

//   Future<dynamic> get({
//     required String endpoint,
//     Map<String, dynamic>? queryParameters,
//   }) async {
//     try {
//       var respone = await apiConfig.dio.get(endpoint);
//       return respone.data;
//     } on DioException catch (e) {
//       debugPrint("Error ${e.toString()}");
//     }
//   }
// }
import 'package:dio/dio.dart';
import 'package:dio_todo_llist/core/api/api_config.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';

class BaseApiService {
  final ApiConfig apiConfig = ApiConfig();
  final box = GetStorage();

  Future<dynamic> post({
    required String endpoint,
    required Map<String, dynamic> data,
  }) async {
    try {
      var response = await apiConfig.dio.post(endpoint, data: data);
      return response.data;
    } on DioException catch (e) {
      debugPrint("error: ${e.message}");
      return {}; // 👈 return empty map instead of null
    }
  }

  Future<dynamic> get({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      var token = box.read("token"); // 👈 read token
      var response = await apiConfig.dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(
          headers: {
            "Authorization": "Bearer $token", // 👈 send token
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      debugPrint("Error: ${e.message}");
      return {}; 
    }
  }
}

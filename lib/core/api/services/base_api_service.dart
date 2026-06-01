
// import 'package:dio/dio.dart';
// import 'package:dio_todo_llist/core/api/api_config.dart';
// import 'package:flutter/widgets.dart';
// import 'package:get_storage/get_storage.dart';

// class BaseApiService {
//   final ApiConfig apiConfig = ApiConfig();
//   final box = GetStorage();

//   Future<dynamic> post({
//     required String endpoint,
//     required Map<String, dynamic> data,
//   }) async {
//     try {
//       var response = await apiConfig.dio.post(endpoint, data: data);
//       return response.data;
//     } on DioException catch (e) {
//       debugPrint("error: ${e.message}");
//       return {}; 
//     }
//   }

//   Future<dynamic> get({
//     required String endpoint,
//     Map<String, dynamic>? queryParameters,
//   }) async {
//     try {
//       var token = box.read("token"); // 👈 read token
//       var response = await apiConfig.dio.get(
//         endpoint,
//         queryParameters: queryParameters,
//         options: Options(
//           headers: {
//             "Authorization": "Bearer $token", 
//           },
//         ),
//       );
//       return response.data;
//     } on DioException catch (e) {
//       debugPrint("Error: ${e.message}");
//       return {}; 
//     }
//   }
//   Future<dynamic> delete({required String endpoint}) async {
//     try {
//       var response = await apiConfig.dio.delete(endpoint);
//       return response.data;
//     } on DioException catch (e) {
//       debugPrint("Error ${e.toString()}");
//     }
//   }

//   Future<dynamic> put({
//     required String endpoint,
//      Map<String, dynamic>? data,
//     // required Map<String, dynamic> data,
//   }) async {
//     try {
//       var response = await ApiConfig().dio.put(endpoint, data: data);
//       return response.data;
//     } on DioException catch (e) {
//       debugPrint("Error : ${e.message}");
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

  Future<Map<String, dynamic>> post({
    required String endpoint,
    required Map<String, dynamic> data,
  }) async {
    try {
      var response = await apiConfig.dio.post(endpoint, data: data);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      debugPrint("error: ${e.message}");
      return {};
    }
  }

  Future<Map<String, dynamic>> get({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      var token = box.read("token");
      var response = await apiConfig.dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      debugPrint("Error: ${e.message}");
      return {};
    }
  }

  Future<Map<String, dynamic>> delete({required String endpoint}) async {
    try {
      var response = await apiConfig.dio.delete(endpoint);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      debugPrint("Error: ${e.toString()}");
      return {}; 
    }
  }

  Future<Map<String, dynamic>> put({
    required String endpoint,
    Map<String, dynamic>? data,
  }) async {
    try {
      var response = await ApiConfig().dio.put(endpoint, data: data);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      debugPrint("Error: ${e.message}");
      return {}; 
    }
  }
}
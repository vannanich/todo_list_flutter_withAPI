import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/core/api/api_config.dart';

class BaseApiService {
  final ApiConfig apiConfig = ApiConfig();

  Future<dynamic> post({
    required String endpoint,
    required Map<String, dynamic> data,
  }) async {
    try {
      var respone = await apiConfig.dio.post(endpoint, data: data);
      return respone.data;
    } on DioException catch (e) {
      debugPrint("error : ${e.message}");
    }
  }
}

// import 'package:dio/dio.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// var box = GetStorage();
// var savedToken = box.read("tpken");

// class ApiConfig {
//   String? token;
//   late Dio dio;
//   // final token = savedToken;
//   // final token =
//   //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiZ0FBQUFBQnFBVkk4TUR1Yllxa0Z4aXctd2tGMmVQU2doYy1HTmZDWXAtdEN1ZW50TXc4U2hDNEJQbWlkX1ZsTkRybzl5X1JZQXNyTFlTRkxJR181bWJ3RVN1NEYzV0g5cEJRMXBDc1h4aVlRRmstdFAzWmNNamZwb21iNGM1eDdhbWhxN1lqS1JSWWl5Mi15enRNaVN6dXlzVmY4YWFYVm9MTDE2MndvMUNqZUVKTmU0ekdpZG5NLVJQV00yUHJqUHJUZkpTaW12TmptIiwiZXhwIjoxODA5NTc1NDg0fQ.Pgtq-S2QGdlDMRWrpWArOcxN9ny5NjWh2gT4ww6lZzU";

//   ApiConfig() {
//     dio = Dio(
//       BaseOptions(
//         baseUrl: "https://pheakdey.tchandalen.com",
//         headers: {"Content-Type": "application/json"},
//         connectTimeout: Duration(seconds: 10),
//         receiveTimeout: Duration(seconds: 10),
//       ),
//     )..interceptors.add(PrettyDioLogger(requestBody: true));
//   }
// }
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiConfig {
  late Dio dio;

  String? token;

  void getToken() {
    var box = GetStorage();
    token = box.read("token");
  }

  ApiConfig() {
    getToken();
    dio = Dio(
      BaseOptions(
        baseUrl: "https://pheakdey.tchandalen.com",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        connectTimeout: Duration(seconds: 50),
        receiveTimeout: Duration(seconds: 10),
      ),
    )..interceptors.add(PrettyDioLogger(requestBody: true));
  }
}

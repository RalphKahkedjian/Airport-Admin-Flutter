import 'package:dio/dio.dart';

class DioClient {
  Dio GetInstance(){
    return Dio(
      BaseOptions(
        baseUrl: "http://127.0.0.1:8000/api/Admin",
        connectTimeout: Duration(seconds: 5),
        receiveTimeout: Duration(seconds: 5),
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      )
    );
  }
} 
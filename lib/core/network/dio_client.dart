// Requirements:
// - Base URL: https://api.github.com
// - Headers: 'Accept': 'application/vnd.github+json'
// - Timeouts and Interceptors

import 'package:dio/dio.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.github.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Accept': 'application/vnd.github+json',
        },
      ),
    );
  }

  void interceptors() {
    _dio.interceptors.addAll([
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: true,
      ),
    ]);
  }

  Dio get dio => _dio;
}

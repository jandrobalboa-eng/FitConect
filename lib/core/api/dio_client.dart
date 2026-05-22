import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';

class DioClient {
  static const String _baseUrl = 'https://web-production-1da2.up.railway.app';
  static Dio getInstance() {
    final dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await SecureStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (DioException e, handler) {
          if (e.response?.statusCode == 403) {
            SecureStorage.clearAll();
          }
          handler.next(e);
        },
      ),
    );

    return dio;
  }
}

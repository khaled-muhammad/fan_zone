import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';
import 'api_exceptions.dart';

class DioClient {
  late final Dio dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          handler.next(error);
        },
      ),
    );
  }

  ApiException _handleError(DioException e) {
    final data = e.response?.data;
    final message =
        data is Map ? data['message'] ?? 'Something went wrong' : 'Something went wrong';

    switch (e.response?.statusCode) {
      case 401:
        return UnauthorizedException(message);
      case 404:
        return NotFoundException(message);
      case 409:
        return ConflictException(message);
      default:
        return ApiException(message, statusCode: e.response?.statusCode);
    }
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await dio.post(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> patch(String path, {dynamic data}) async {
    try {
      return await dio.patch(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete(String path) async {
    try {
      return await dio.delete(path);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
}

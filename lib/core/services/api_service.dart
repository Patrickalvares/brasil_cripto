import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../constants/api_constants.dart';

class ApiService {
  final Dio _dio;

  ApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
          responseType: ResponseType.json,
        ),
      );

  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: queryParams);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(String endpoint, {dynamic data, Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.post(endpoint, data: data, queryParameters: queryParams);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    String errorMessage = "An error occurred";

    if (error.response?.statusCode == 429) {
      errorMessage = "limit_exceeded_aguarde".tr();
      return Exception(errorMessage);
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = "Connection timeout";
        break;
      case DioExceptionType.badResponse:
        errorMessage = "Bad response: ${error.response?.statusCode}";
        break;
      case DioExceptionType.connectionError:
        errorMessage = "No internet connection";
        break;
      default:
        errorMessage = "Unexpected error occurred";
        break;
    }

    return Exception(errorMessage);
  }
}

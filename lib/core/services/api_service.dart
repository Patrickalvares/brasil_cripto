import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../constants/api_constants.dart';
import 'cache_service.dart';

class ApiService {
  final Dio _dio;
  final CacheService _cacheService;

  ApiService()
    : _dio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          connectTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
          responseType: ResponseType.json,
        ),
      ),
      _cacheService = CacheService() {
    // Adiciona interceptor para monitorar respostas
    _dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response, handler) {
          final rateLimitRemaining = response.headers.value('x-ratelimit-remaining');

          if (rateLimitRemaining != null) {
            final remaining = int.tryParse(rateLimitRemaining) ?? 10;
            if (remaining < 5) {
              _cacheService.enforceRateLimit(const Duration(seconds: 50));
            }
          }

          handler.next(response);
        },
        onError: (error, handler) {
          // Se recebermos um erro 429 (limite excedido), ativamos a limitação forçada
          if (error.response?.statusCode == 429) {
            _cacheService.enforceRateLimit(const Duration(seconds: 60));
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParams}) async {
    final Duration endpointCacheDuration = _cacheService.getEndpointCacheDuration(endpoint);

    final response = await _cacheService.getCachedData<Response>(
      endpoint: endpoint,
      queryParams: queryParams,
      expiration: endpointCacheDuration,
      fetchFromApi: () async {
        try {
          return await _dio.get(endpoint, queryParameters: queryParams);
        } on DioException catch (e) {
          throw _handleError(e);
        }
      },
    );
    return response!;
  }

  Future<Response> post(String endpoint, {dynamic data, Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio.post(endpoint, data: data, queryParameters: queryParams);
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  void clearCache(String endpoint, {Map<String, dynamic>? queryParams}) {
    _cacheService.clearCache(endpoint: endpoint, queryParams: queryParams);
  }

  void clearAllCache() {
    _cacheService.clearCache();
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

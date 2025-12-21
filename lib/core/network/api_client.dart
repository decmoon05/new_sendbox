import 'package:dio/dio.dart';
import '../constants/api_constants.dart';

/// API 클라이언트 (Dio 기반)
class ApiClient {
  late final Dio _dio;

  ApiClient({String? baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? ApiConstants.apiBaseUrlDev,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          ApiConstants.headerContentType: ApiConstants.headerContentTypeJson,
        },
      ),
    );
  }

  Dio get dio => _dio;

  /// GET 요청
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// POST 요청
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT 요청
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE 요청
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// 에러 처리
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception('연결 시간이 초과되었습니다.');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.data?['message'] ?? '서버 오류가 발생했습니다.';
          return Exception('[$statusCode] $message');
        case DioExceptionType.cancel:
          return Exception('요청이 취소되었습니다.');
        case DioExceptionType.unknown:
          return Exception('네트워크 연결을 확인해주세요.');
        default:
          return Exception('알 수 없는 오류가 발생했습니다.');
      }
    }
    return Exception('알 수 없는 오류: ${error.toString()}');
  }
}


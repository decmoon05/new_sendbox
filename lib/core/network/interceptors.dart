import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../constants/storage_keys.dart';

/// 인증 인터셉터 (JWT 토큰 추가)
class AuthInterceptor extends Interceptor {
  final Future<String?> Function() getToken;

  AuthInterceptor(this.getToken);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await getToken();
    if (token != null) {
      options.headers[ApiConstants.headerAuthorization] =
          '${ApiConstants.headerBearerPrefix}$token';
    }
    handler.next(options);
  }
}

/// 로깅 인터셉터 (개발 환경용)
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    if (options.data != null) {
      print('DATA: ${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    handler.next(err);
  }
}

/// 에러 인터셉터
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 401 Unauthorized - 토큰 갱신 필요
    if (err.response?.statusCode == 401) {
      // TODO: 토큰 갱신 로직
    }
    
    handler.next(err);
  }
}


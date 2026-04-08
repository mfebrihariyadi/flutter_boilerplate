import 'package:dio/dio.dart';
import 'package:boilerplate/core/logger/app_logger.dart';

class DebugLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.d(
      'HTTP request',
      tag: 'HTTP',
      data: {
        'method': options.method,
        'path': options.path,
        'query': options.queryParameters,
        'headers': Map<String, dynamic>.from(options.headers),
        'body': options.data,
      },
    );

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.d(
      'HTTP response',
      tag: 'HTTP',
      data: {
        'method': response.requestOptions.method,
        'path': response.requestOptions.path,
        'statusCode': response.statusCode,
        'body': response.data,
      },
    );

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.e(
      'HTTP error',
      tag: 'HTTP',
      error: err,
      stackTrace: err.stackTrace,
      data: {
        'method': err.requestOptions.method,
        'path': err.requestOptions.path,
        'statusCode': err.response?.statusCode,
        'response': err.response?.data,
      },
    );

    super.onError(err, handler);
  }
}

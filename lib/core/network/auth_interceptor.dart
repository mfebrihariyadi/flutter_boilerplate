import 'package:dio/dio.dart';
import 'package:boilerplate/app/data/models/auth_tokens_model.dart';
import 'package:boilerplate/core/logger/app_logger.dart';
import 'package:boilerplate/core/constants/api_constant.dart';
import 'package:boilerplate/core/services/storage_service.dart';

class AuthInterceptor extends Interceptor {
  final StorageService _storageService;
  final Dio _refreshClient = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      responseType: ResponseType.json,
    ),
  );

  AuthInterceptor(this._storageService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _storageService.getAccessToken();

    if (_requiresAuthorization(options) && token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      AppLogger.d(
        'Attached authorization header',
        tag: 'AuthInterceptor',
        data: {
          'path': options.path,
          'method': options.method,
          'token': token,
        },
      );
    }

    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_shouldAttemptRefresh(err)) {
      AppLogger.w(
        'Skipping token refresh for request error',
        tag: 'AuthInterceptor',
        data: {
          'path': err.requestOptions.path,
          'statusCode': err.response?.statusCode,
        },
      );
      handler.next(err);
      return;
    }

    try {
      AppLogger.w(
        '401 received, attempting token refresh',
        tag: 'AuthInterceptor',
        data: {'path': err.requestOptions.path},
      );
      final tokens = await _refreshAuthTokens();
      await _storageService.saveAuthTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );
      AppLogger.i(
        'Token refresh succeeded',
        tag: 'AuthInterceptor',
        data: {
          'accessToken': tokens.accessToken,
          'refreshToken': tokens.refreshToken,
        },
      );

      final requestOptions = err.requestOptions;
      requestOptions.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
      requestOptions.extra['retriedWithRefresh'] = true;

      AppLogger.d(
        'Retrying original request after refresh',
        tag: 'AuthInterceptor',
        data: {
          'path': requestOptions.path,
          'method': requestOptions.method,
        },
      );
      final response = await _refreshClient.fetch<dynamic>(requestOptions);
      handler.resolve(response);
    } catch (error, stackTrace) {
      AppLogger.e(
        'Token refresh failed, clearing stored auth tokens',
        tag: 'AuthInterceptor',
        error: error,
        stackTrace: stackTrace,
        data: {'path': err.requestOptions.path},
      );
      await _storageService.removeAuthTokens();
      handler.next(err);
    }
  }

  bool _requiresAuthorization(RequestOptions options) {
    final path = options.path;
    return path != ApiConstants.login && path != ApiConstants.refreshToken;
  }

  bool _shouldAttemptRefresh(DioException err) {
    final refreshToken = _storageService.getRefreshToken();
    final path = err.requestOptions.path;

    return err.response?.statusCode == 401 &&
        refreshToken != null &&
        refreshToken.isNotEmpty &&
        path != ApiConstants.login &&
        path != ApiConstants.refreshToken &&
        err.requestOptions.extra['retriedWithRefresh'] != true;
  }

  Future<AuthTokensModel> _refreshAuthTokens() async {
    final refreshToken = _storageService.getRefreshToken();

    AppLogger.d(
      'Requesting refreshed auth tokens',
      tag: 'AuthInterceptor',
      data: {
        'refreshToken': refreshToken,
        'expiresInMins': 30,
      },
    );

    final response = await _refreshClient.post(
      ApiConstants.refreshToken,
      data: {
        if (refreshToken != null && refreshToken.isNotEmpty)
          'refreshToken': refreshToken,
        'expiresInMins': 30,
      },
    );

    AppLogger.d(
      'Received refresh token response',
      tag: 'AuthInterceptor',
      data: {'statusCode': response.statusCode},
    );

    return AuthTokensModel.fromJson(response.data as Map<String, dynamic>);
  }
}

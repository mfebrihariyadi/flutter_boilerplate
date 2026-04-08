import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:boilerplate/core/constants/api_constant.dart';
import 'package:boilerplate/core/network/auth_interceptor.dart';
import 'package:boilerplate/core/network/debug_log_interceptor.dart';

import '../constants/app_constant.dart';

class DioClient {
  late final Dio _dio;

  DioClient(AuthInterceptor authInterceptor) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: Duration(seconds: AppConstant.connectionTimeout),
        receiveTimeout: Duration(seconds: AppConstant.receiveTimeout),
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.add(authInterceptor);

    if (kDebugMode) {
      _dio.interceptors.add(DebugLogInterceptor());
    }
  }

  Dio get dio => _dio;
}

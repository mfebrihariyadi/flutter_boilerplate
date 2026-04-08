import 'package:dio/dio.dart';
import 'package:boilerplate/app/data/models/auth_tokens_model.dart';
import 'package:boilerplate/app/data/models/user_model.dart';
import 'package:boilerplate/core/logger/app_logger.dart';
import 'package:boilerplate/core/constants/api_constant.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> login(String username, String password);
  Future<UserModel> getCurrentUser();
  Future<AuthTokensModel> refreshToken({String? refreshToken, int? expiresInMins});
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Dio client;

  AuthRemoteDatasourceImpl(this.client);

  @override
  Future<UserModel> login(String username, String password) async {
    AppLogger.d(
      'Calling login endpoint',
      tag: 'AuthDatasource',
      data: {'endpoint': ApiConstants.login, 'username': AppLogger.mask(username)},
    );
    final response = await client.post(
      ApiConstants.login,
      data: {'username': username, 'password': password, 'expiresInMins': 3},
    );

    if (response.statusCode == 200) {
      AppLogger.i('Login endpoint returned success', tag: 'AuthDatasource', data: {'statusCode': response.statusCode});
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    }

    AppLogger.w(
      'Login endpoint returned unexpected status',
      tag: 'AuthDatasource',
      data: {'statusCode': response.statusCode},
    );

    throw DioException(requestOptions: response.requestOptions, response: response, type: DioExceptionType.badResponse);
  }

  @override
  Future<UserModel> getCurrentUser() async {
    AppLogger.d('Calling current user endpoint', tag: 'AuthDatasource', data: {'endpoint': ApiConstants.currentUser});
    final response = await client.get(ApiConstants.currentUser);

    if (response.statusCode == 200) {
      AppLogger.i(
        'Current user endpoint returned success',
        tag: 'AuthDatasource',
        data: {'statusCode': response.statusCode},
      );
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    }

    AppLogger.w(
      'Current user endpoint returned unexpected status',
      tag: 'AuthDatasource',
      data: {'statusCode': response.statusCode},
    );

    throw DioException(requestOptions: response.requestOptions, response: response, type: DioExceptionType.badResponse);
  }

  @override
  Future<AuthTokensModel> refreshToken({String? refreshToken, int? expiresInMins}) async {
    final payload = <String, dynamic>{
      'refreshToken': refreshToken?.isNotEmpty == true ? refreshToken : null,
      'expiresInMins': expiresInMins,
    };
    payload.removeWhere((key, value) => value == null);

    AppLogger.d(
      'Calling refresh token endpoint',
      tag: 'AuthDatasource',
      data: {'endpoint': ApiConstants.refreshToken, 'payload': payload},
    );

    final response = await client.post(ApiConstants.refreshToken, data: payload);

    if (response.statusCode == 200) {
      AppLogger.i(
        'Refresh token endpoint returned success',
        tag: 'AuthDatasource',
        data: {'statusCode': response.statusCode},
      );
      return AuthTokensModel.fromJson(response.data as Map<String, dynamic>);
    }

    AppLogger.w(
      'Refresh token endpoint returned unexpected status',
      tag: 'AuthDatasource',
      data: {'statusCode': response.statusCode},
    );

    throw DioException(requestOptions: response.requestOptions, response: response, type: DioExceptionType.badResponse);
  }
}

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:boilerplate/app/domain/entities/auth_tokens_entity.dart';
import 'package:boilerplate/core/errors/failures.dart';
import 'package:boilerplate/app/domain/entities/user_entity.dart';
import 'package:boilerplate/app/domain/repositories/auth_repository.dart';
import 'package:boilerplate/app/data/datasources/auth_remote_datasource.dart';
import 'package:boilerplate/core/logger/app_logger.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<Failure, UserEntity>> login(
    String username,
    String password,
  ) async {
    try {
      AppLogger.d(
        'Executing login through repository',
        tag: 'AuthRepository',
        data: {'username': AppLogger.mask(username)},
      );
      final userModel = await remoteDatasource.login(username, password);
      AppLogger.i(
        'Repository login completed successfully',
        tag: 'AuthRepository',
        data: {'username': AppLogger.mask(userModel.username)},
      );
      return Right(userModel);
    } on DioException catch (e) {
      AppLogger.w(
        'Repository login failed with DioException',
        tag: 'AuthRepository',
        data: {
          'statusCode': e.response?.statusCode,
          'path': e.requestOptions.path,
        },
      );
      return Left(_mapDioFailure(e));
    } catch (e, stackTrace) {
      AppLogger.e(
        'Repository login failed unexpectedly',
        tag: 'AuthRepository',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      AppLogger.d('Fetching current user from repository', tag: 'AuthRepository');
      final userModel = await remoteDatasource.getCurrentUser();
      AppLogger.i('Fetched current user successfully', tag: 'AuthRepository');
      return Right(userModel);
    } on DioException catch (e) {
      AppLogger.w(
        'Get current user failed with DioException',
        tag: 'AuthRepository',
        data: {
          'statusCode': e.response?.statusCode,
          'path': e.requestOptions.path,
        },
      );
      return Left(_mapDioFailure(e));
    } catch (e, stackTrace) {
      AppLogger.e(
        'Get current user failed unexpectedly',
        tag: 'AuthRepository',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthTokensEntity>> refreshToken({
    String? refreshToken,
    int? expiresInMins,
  }) async {
    try {
      AppLogger.d(
        'Refreshing token through repository',
        tag: 'AuthRepository',
        data: {'refreshToken': refreshToken, 'expiresInMins': expiresInMins},
      );
      final tokens = await remoteDatasource.refreshToken(
        refreshToken: refreshToken,
        expiresInMins: expiresInMins,
      );
      AppLogger.i('Repository token refresh succeeded', tag: 'AuthRepository');
      return Right(tokens);
    } on DioException catch (e) {
      AppLogger.w(
        'Repository token refresh failed with DioException',
        tag: 'AuthRepository',
        data: {
          'statusCode': e.response?.statusCode,
          'path': e.requestOptions.path,
        },
      );
      return Left(_mapDioFailure(e));
    } catch (e, stackTrace) {
      AppLogger.e(
        'Repository token refresh failed unexpectedly',
        tag: 'AuthRepository',
        error: e,
        stackTrace: stackTrace,
      );
      return Left(UnknownFailure(e.toString()));
    }
  }

  Failure _mapDioFailure(DioException exception) {
    AppLogger.d(
      'Mapping DioException to Failure',
      tag: 'AuthRepository',
      data: {
        'statusCode': exception.response?.statusCode,
        'path': exception.requestOptions.path,
        'response': exception.response?.data,
      },
    );

    if (exception.response != null && exception.response?.statusCode != null) {
      final data = exception.response?.data;
      if (data is Map<String, dynamic>) {
        return ServerFailure(data['message']?.toString() ?? 'Server Error');
      }
      return ServerFailure('Server Error');
    }

    return NetworkFailure();
  }
}

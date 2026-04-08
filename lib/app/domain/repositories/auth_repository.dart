import 'package:dartz/dartz.dart';
import 'package:boilerplate/app/domain/entities/auth_tokens_entity.dart';
import 'package:boilerplate/core/errors/failures.dart';
import 'package:boilerplate/app/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String username, String password);
  Future<Either<Failure, UserEntity>> getCurrentUser();
  Future<Either<Failure, AuthTokensEntity>> refreshToken({
    String? refreshToken,
    int? expiresInMins,
  });
}

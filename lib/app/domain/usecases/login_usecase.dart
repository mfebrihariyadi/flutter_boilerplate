import 'package:dartz/dartz.dart';
import 'package:boilerplate/core/errors/failures.dart';
import 'package:boilerplate/app/domain/entities/user_entity.dart';
import 'package:boilerplate/app/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, UserEntity>> execute(String username, String password) {
    return repository.login(username, password);
  }
}

import 'package:dartz/dartz.dart';
import 'package:boilerplate/app/domain/entities/user_entity.dart';
import 'package:boilerplate/app/domain/repositories/auth_repository.dart';
import 'package:boilerplate/core/errors/failures.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<Either<Failure, UserEntity>> execute() {
    return repository.getCurrentUser();
  }
}

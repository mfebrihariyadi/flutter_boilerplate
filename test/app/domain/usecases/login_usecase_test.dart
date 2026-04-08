import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:boilerplate/core/errors/failures.dart';
import 'package:boilerplate/app/domain/entities/user_entity.dart';
import 'package:boilerplate/app/domain/repositories/auth_repository.dart';
import 'package:boilerplate/app/domain/usecases/login_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LoginUseCase(mockRepository);
  });

  final tUsername = 'testuser';
  final tPassword = 'password123';
  final tUser = UserEntity(
    id: 1,
    username: tUsername,
    email: 'test@example.com',
    firstName: 'Test',
    lastName: 'User',
    gender: 'male',
    image: 'https://example.com/avatar.png',
    accessToken: 'access_token',
    refreshToken: 'refresh_token',
  );

  test('should get user from repository when login is successful', () async {
    // arrange
    when(() => mockRepository.login(any(), any()))
        .thenAnswer((_) async => Right(tUser));
    
    // act
    final result = await usecase.execute(tUsername, tPassword);
    
    // assert
    expect(result, Right(tUser));
    verify(() => mockRepository.login(tUsername, tPassword));
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when login is unsuccessful', () async {
    final failure = ServerFailure('Invalid credentials');
    // arrange
    when(() => mockRepository.login(any(), any()))
        .thenAnswer((_) async => Left(failure));
    
    // act
    final result = await usecase.execute(tUsername, tPassword);
    
    // assert
    expect(result, Left(failure));
    verify(() => mockRepository.login(tUsername, tPassword));
    verifyNoMoreInteractions(mockRepository);
  });
}

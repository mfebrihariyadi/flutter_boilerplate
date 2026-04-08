import 'package:flutter_test/flutter_test.dart';
import 'package:boilerplate/app/domain/entities/user_entity.dart';

void main() {
  test('UserEntity should hold correct data', () {
    final user = UserEntity(
      id: 1,
      username: 'testuser',
      email: 'test@example.com',
      firstName: 'Test',
      lastName: 'User',
      gender: 'female',
      image: 'https://example.com/avatar.png',
      accessToken: 'dummy_access_token',
      refreshToken: 'dummy_refresh_token',
    );

    expect(user.id, 1);
    expect(user.username, 'testuser');
    expect(user.email, 'test@example.com');
    expect(user.firstName, 'Test');
    expect(user.lastName, 'User');
    expect(user.gender, 'female');
    expect(user.image, 'https://example.com/avatar.png');
    expect(user.accessToken, 'dummy_access_token');
    expect(user.refreshToken, 'dummy_refresh_token');
  });
}

import 'package:boilerplate/app/domain/entities/auth_tokens_entity.dart';

class AuthTokensModel extends AuthTokensEntity {
  const AuthTokensModel({
    required super.accessToken,
    required super.refreshToken,
  });

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    return AuthTokensModel(
      accessToken: (json['accessToken'] ?? '') as String,
      refreshToken: (json['refreshToken'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}

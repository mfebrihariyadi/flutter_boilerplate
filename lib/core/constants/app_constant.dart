enum AuthTokenType {
  accessTokenOnly,
  accessAndRefreshToken,
  refreshTokenOnly,
}

class AuthConfig {
  static const AuthTokenType tokenType = AuthTokenType.accessAndRefreshToken;

  static bool get supportsRefreshToken =>
      tokenType == AuthTokenType.accessAndRefreshToken ||
      tokenType == AuthTokenType.refreshTokenOnly;

  static bool get requiresAccessTokenInResponse =>
      tokenType == AuthTokenType.accessTokenOnly ||
      tokenType == AuthTokenType.accessAndRefreshToken;
}

class AppConstant {
  static const String appName = "Flutter Boilerplate";
  static const String appCompany = "PT XYZ";
  static const String appTagline = "Enterprise Digital Data Collection";
  static const int connectionTimeout = 30;
  static const int receiveTimeout = 30;
}

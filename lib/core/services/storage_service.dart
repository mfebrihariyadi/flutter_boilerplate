import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:boilerplate/app/data/models/user_model.dart';
import 'package:boilerplate/app/domain/entities/user_entity.dart';
import 'package:boilerplate/core/logger/app_logger.dart';

class StorageService extends GetxService {
  late GetStorage _box;

  static const String _accessTokenKey = 'ACCESS_TOKEN';
  static const String _refreshTokenKey = 'REFRESH_TOKEN';
  static const String _currentUserKey = 'CURRENT_USER';

  Future<StorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    AppLogger.i('Local storage initialized', tag: 'Storage');
    return this;
  }

  Future<void> saveAccessToken(String token) async {
    AppLogger.d('Saving access token', tag: 'Storage', data: {'token': token});
    await _box.write(_accessTokenKey, token);
  }

  Future<void> saveRefreshToken(String token) async {
    AppLogger.d('Saving refresh token', tag: 'Storage', data: {'token': token});
    await _box.write(_refreshTokenKey, token);
  }

  Future<void> saveAuthTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
    ]);
  }

  Future<void> saveCurrentUser(UserEntity user) async {
    final userModel = UserModel.fromEntity(user);
    AppLogger.d(
      'Saving current user',
      tag: 'Storage',
      data: {'username': AppLogger.mask(userModel.username)},
    );
    await _box.write(_currentUserKey, userModel.toJson());
  }

  String? getAccessToken() {
    final token = _box.read(_accessTokenKey);
    AppLogger.d(
      'Reading access token',
      tag: 'Storage',
      data: {'state': AppLogger.tokenState(token)},
    );
    return token;
  }

  String? getRefreshToken() {
    final token = _box.read(_refreshTokenKey);
    AppLogger.d(
      'Reading refresh token',
      tag: 'Storage',
      data: {'state': AppLogger.tokenState(token)},
    );
    return token;
  }

  UserModel? getCurrentUser() {
    final user = _box.read(_currentUserKey);
    if (user is Map) {
      AppLogger.d('Reading current user from storage', tag: 'Storage');
      return UserModel.fromJson(Map<String, dynamic>.from(user));
    }

    return null;
  }

  bool hasAuthSession() {
    final accessToken = getAccessToken();
    final refreshToken = getRefreshToken();
    return accessToken != null &&
        accessToken.isNotEmpty &&
        refreshToken != null &&
        refreshToken.isNotEmpty;
  }

  Future<void> removeAccessToken() async {
    AppLogger.d('Removing access token', tag: 'Storage');
    await _box.remove(_accessTokenKey);
  }

  Future<void> removeRefreshToken() async {
    AppLogger.d('Removing refresh token', tag: 'Storage');
    await _box.remove(_refreshTokenKey);
  }

  Future<void> removeCurrentUser() async {
    AppLogger.d('Removing current user', tag: 'Storage');
    await _box.remove(_currentUserKey);
  }

  Future<void> removeAuthTokens() async {
    await Future.wait([removeAccessToken(), removeRefreshToken()]);
  }

  Future<void> clearSession() async {
    await Future.wait([removeAuthTokens(), removeCurrentUser()]);
  }

  Future<void> clearAll() async {
    AppLogger.w('Clearing all local storage values', tag: 'Storage');
    await _box.erase();
  }
}

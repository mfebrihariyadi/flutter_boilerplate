import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:boilerplate/core/logger/app_logger.dart';

class StorageService extends GetxService {
  late GetStorage _box;

  static const String _accessTokenKey = 'ACCESS_TOKEN';
  static const String _refreshTokenKey = 'REFRESH_TOKEN';

  Future<StorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    AppLogger.i('Local storage initialized', tag: 'Storage');
    return this;
  }

  Future<void> saveAccessToken(String token) async {
    AppLogger.d(
      'Saving access token',
      tag: 'Storage',
      data: {'token': token},
    );
    await _box.write(_accessTokenKey, token);
  }

  Future<void> saveRefreshToken(String token) async {
    AppLogger.d(
      'Saving refresh token',
      tag: 'Storage',
      data: {'token': token},
    );
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

  Future<void> removeAccessToken() async {
    AppLogger.d('Removing access token', tag: 'Storage');
    await _box.remove(_accessTokenKey);
  }

  Future<void> removeRefreshToken() async {
    AppLogger.d('Removing refresh token', tag: 'Storage');
    await _box.remove(_refreshTokenKey);
  }

  Future<void> removeAuthTokens() async {
    await Future.wait([
      removeAccessToken(),
      removeRefreshToken(),
    ]);
  }

  Future<void> clearAll() async {
    AppLogger.w('Clearing all local storage values', tag: 'Storage');
    await _box.erase();
  }
}

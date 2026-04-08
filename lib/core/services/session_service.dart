import 'package:get/get.dart';
import 'package:boilerplate/app/domain/entities/user_entity.dart';
import 'package:boilerplate/app/domain/usecases/get_current_user_usecase.dart';
import 'package:boilerplate/core/logger/app_logger.dart';
import 'package:boilerplate/core/services/storage_service.dart';
import 'package:boilerplate/routes/app_routes.dart';

class SessionService extends GetxService {
  final StorageService _storageService;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  SessionService(this._storageService, this._getCurrentUserUseCase);

  final Rxn<UserEntity> currentUser = Rxn<UserEntity>();
  Future<void>? _redirectFuture;

  SessionService init() {
    currentUser.value = _storageService.getCurrentUser();
    return this;
  }

  bool hasStoredSession() {
    return _storageService.hasAuthSession();
  }

  Future<String> resolveStartupRoute() async {
    final user = await getStoredOrValidatedUser();
    return user == null ? AppRoutes.login : AppRoutes.home;
  }

  Future<UserEntity?> getStoredOrValidatedUser() async {
    if (!hasStoredSession()) {
      AppLogger.i('No stored session found', tag: 'SessionService');
      currentUser.value = null;
      return null;
    }

    final storedUser = _storageService.getCurrentUser();
    if (storedUser != null) {
      currentUser.value = storedUser;
    }

    AppLogger.i('Validating stored session', tag: 'SessionService');
    final result = await _getCurrentUserUseCase.execute();
    return result.fold<Future<UserEntity?>>(
      (failure) async {
        AppLogger.w(
          'Stored session is invalid',
          tag: 'SessionService',
          data: {'message': failure.message},
        );
        await clearSession();
        return null;
      },
      (user) async {
        AppLogger.i(
          'Stored session validated successfully',
          tag: 'SessionService',
          data: {'username': AppLogger.mask(user.username)},
        );
        currentUser.value = user;
        await _storageService.saveCurrentUser(user);
        return user;
      },
    );
  }

  Future<void> redirectFromSplash() {
    return _redirectFuture ??= _handleSplashRedirect().whenComplete(() {
      _redirectFuture = null;
    });
  }

  Future<void> _handleSplashRedirect() async {
    final route = await resolveStartupRoute();
    if (Get.currentRoute != route) {
      await Get.offAllNamed(route);
    }
  }

  void setCurrentUser(UserEntity? user) {
    currentUser.value = user;
  }

  Future<void> clearSession() async {
    currentUser.value = null;
    await _storageService.clearSession();
  }

  Future<void> logout() async {
    AppLogger.i('Logging out current user', tag: 'SessionService');
    await clearSession();
    await Get.offAllNamed(AppRoutes.login);
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:boilerplate/app/domain/usecases/login_usecase.dart';
import 'package:boilerplate/core/helpers/toast_helper.dart';
import 'package:boilerplate/core/logger/app_logger.dart';
import 'package:boilerplate/core/services/session_service.dart';
import 'package:boilerplate/core/services/storage_service.dart';
import 'package:boilerplate/routes/app_routes.dart';

class AuthController extends GetxController {
  final LoginUseCase _loginUseCase;
  final StorageService _storageService;
  final SessionService _sessionService;

  AuthController(this._loginUseCase, this._storageService, this._sessionService);

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      AppLogger.w(
        'Login blocked because credentials are incomplete',
        tag: 'AuthController',
        data: {'username': AppLogger.mask(usernameController.text)},
      );
      await ToastHelper.showError('Please enter username and password');
      return;
    }

    AppLogger.i(
      'Submitting login request',
      tag: 'AuthController',
      data: {'username': AppLogger.mask(usernameController.text)},
    );
    isLoading.value = true;
    final result = await _loginUseCase.execute(usernameController.text, passwordController.text);
    isLoading.value = false;

    result.fold(
      (failure) async {
        AppLogger.w('Login failed', tag: 'AuthController', data: {'message': failure.message});
        await ToastHelper.showError(failure.message);
      },
      (user) async {
        AppLogger.i('Login succeeded', tag: 'AuthController', data: {'username': AppLogger.mask(user.username)});
        
        final hasAccessToken = user.accessToken != null && user.accessToken!.isNotEmpty;
        final hasRefreshToken = user.refreshToken != null && user.refreshToken!.isNotEmpty;
        
        if (hasAccessToken || hasRefreshToken) {
          AppLogger.d('Persisting auth tokens after login', tag: 'AuthController');
          await _storageService.saveAuthTokens(
            accessToken: user.accessToken,
            refreshToken: user.refreshToken,
          );
        }
        await _storageService.saveCurrentUser(user);
        _sessionService.setCurrentUser(user);
        await ToastHelper.showSuccess('Welcome ${user.username}');
        await Get.offAllNamed(AppRoutes.home);
      },
    );
  }
}

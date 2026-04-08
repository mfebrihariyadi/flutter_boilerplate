import 'package:get/get.dart';
import 'package:boilerplate/core/logger/app_logger.dart';
import 'package:boilerplate/core/services/storage_service.dart';

class AppBinding {
  AppBinding._();

  static Future<void> init() async {
    Get.put<AppLogger>(AppLogger(), permanent: true);
    AppLogger.i('Registering application services', tag: 'Binding');
    await Get.putAsync<StorageService>(() async => StorageService().init());
    AppLogger.i('StorageService registered', tag: 'Binding');
  }
}

import 'package:get/get.dart';
import 'package:boilerplate/app/modules/auth/controllers/auth_controller.dart';
import 'package:boilerplate/core/services/session_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => AuthController(Get.find(), Get.find(), Get.find<SessionService>()),
    );
  }
}

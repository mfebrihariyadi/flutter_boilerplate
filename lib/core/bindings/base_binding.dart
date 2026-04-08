import 'package:get/get.dart';
import 'package:boilerplate/core/network/auth_interceptor.dart';
import 'package:boilerplate/core/network/dio_client.dart';

class BaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthInterceptor(Get.find()), fenix: true);
    Get.lazyPut(() => DioClient(Get.find()), fenix: true);
  }
}

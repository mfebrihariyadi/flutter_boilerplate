import 'package:get/get.dart';
import 'package:boilerplate/core/network/dio_client.dart';
import 'package:boilerplate/app/data/datasources/auth_remote_datasource.dart';
import 'package:boilerplate/app/data/repositories/auth_repository_impl.dart';
import 'package:boilerplate/app/domain/repositories/auth_repository.dart';
import 'package:boilerplate/app/domain/usecases/login_usecase.dart';
import 'package:boilerplate/app/modules/auth/controllers/auth_controller.dart';
import 'package:boilerplate/core/services/storage_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRemoteDatasource>(
      () => AuthRemoteDatasourceImpl(Get.find<DioClient>().dio),
    );
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(Get.find()),
    );
    Get.lazyPut(
      () => LoginUseCase(Get.find()),
    );
    Get.lazyPut(
      () => AuthController(Get.find(), Get.find<StorageService>()),
    );
  }
}

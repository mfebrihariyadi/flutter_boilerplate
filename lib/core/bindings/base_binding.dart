import 'package:get/get.dart';
import 'package:boilerplate/app/data/datasources/auth_remote_datasource.dart';
import 'package:boilerplate/app/data/repositories/auth_repository_impl.dart';
import 'package:boilerplate/app/domain/repositories/auth_repository.dart';
import 'package:boilerplate/app/domain/usecases/get_current_user_usecase.dart';
import 'package:boilerplate/app/domain/usecases/login_usecase.dart';
import 'package:boilerplate/core/network/auth_interceptor.dart';
import 'package:boilerplate/core/network/dio_client.dart';
import 'package:boilerplate/core/services/session_service.dart';

class BaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthInterceptor(Get.find()), fenix: true);
    Get.lazyPut(() => DioClient(Get.find()), fenix: true);
    Get.lazyPut<AuthRemoteDatasource>(
      () => AuthRemoteDatasourceImpl(Get.find<DioClient>().dio),
      fenix: true,
    );
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(Get.find()),
      fenix: true,
    );
    Get.lazyPut(() => LoginUseCase(Get.find()), fenix: true);
    Get.lazyPut(() => GetCurrentUserUseCase(Get.find()), fenix: true);
    if (!Get.isRegistered<SessionService>()) {
      Get.put<SessionService>(
        SessionService(Get.find(), Get.find<GetCurrentUserUseCase>()).init(),
        permanent: true,
      );
    }
  }
}

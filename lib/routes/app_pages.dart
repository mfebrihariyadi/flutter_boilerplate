import 'package:get/get.dart';
import 'package:boilerplate/app/modules/auth/bindings/auth_binding.dart';
import 'package:boilerplate/app/modules/auth/views/login_view.dart';
import 'package:boilerplate/routes/app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
  ];
}

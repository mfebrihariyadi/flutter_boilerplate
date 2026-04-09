import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:boilerplate/core/bindings/app_binding.dart';
import 'package:boilerplate/core/bindings/base_binding.dart';
import 'package:boilerplate/core/logger/app_logger.dart';
import 'package:boilerplate/core/theme/app_theme.dart';
import 'package:boilerplate/routes/app_pages.dart';
import 'package:boilerplate/routes/app_routes.dart';

import 'core/constants/app_constant.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.i('Starting application bootstrap', tag: 'Bootstrap');
  await AppBinding.init();
  AppLogger.i('Application services initialized', tag: 'Bootstrap');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstant.appName,
      debugShowCheckedModeBanner: false,
      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      // Routes
      initialBinding: BaseBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      // Default Transitions
      defaultTransition: Transition.cupertino,
      builder: (context, child) {
        child = NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification? overscroll) {
            overscroll!.disallowIndicator();
            return true;
          },
          child: child!,
        );

        return child;
      },
    );
  }
}

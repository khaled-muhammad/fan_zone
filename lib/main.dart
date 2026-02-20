import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/app_pages.dart';
import 'core/network/dio_client.dart';
import 'shared/services/theme_service.dart';
import 'features/auth/presentation/controllers/auth_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _initServices();
  runApp(const FanZoneApp());
}

void _initServices() {
  Get.put(DioClient(), permanent: true);
  Get.put(ThemeService(), permanent: true);
  Get.put(AuthController(), permanent: true);
}

class FanZoneApp extends StatelessWidget {
  const FanZoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();

    return Obx(
      () => GetMaterialApp(
        title: 'FAN ZONE',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeService.themeMode,
        initialRoute: AppRoutes.splash,
        getPages: AppPages.pages,
      ),
    );
  }
}

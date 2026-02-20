import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeService extends GetxService {
  final _isDark = true.obs;

  bool get isDark => _isDark.value;
  ThemeMode get themeMode => _isDark.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDark.value = !_isDark.value;
    Get.changeThemeMode(_isDark.value ? ThemeMode.dark : ThemeMode.light);
  }
}

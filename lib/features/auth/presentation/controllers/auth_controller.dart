import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/models/user_model.dart';
import '../../../../core/utils/storage_service.dart';
import '../../../../core/routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthRemoteDatasource _datasource = AuthRemoteDatasource();

  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  final registerNameController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final registerPhoneController = TextEditingController();

  final selectedRole = 'player'.obs;
  final selectedPosition = ''.obs;
  final isLoading = false.obs;
  final obscurePassword = true.obs;

  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  final positions = [
    'Goalkeeper',
    'Defender',
    'Midfielder',
    'Forward',
  ];

  String get _homeRoute =>
      currentUser.value?.role == 'owner' ? AppRoutes.ownerHome : AppRoutes.home;

  Future<void> checkAuth() async {
    final hasToken = await StorageService.hasToken();
    if (hasToken) {
      final userData = await StorageService.getUserData();
      if (userData != null) {
        currentUser.value = UserModel.fromJson(jsonDecode(userData));
      }
      Get.offAllNamed(_homeRoute);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  Future<void> login() async {
    if (loginEmailController.text.isEmpty || loginPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields',
          backgroundColor: Colors.red.withAlpha(200), colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final data = await _datasource.login(
        loginEmailController.text.trim(),
        loginPasswordController.text,
      );

      await StorageService.saveToken(data['token']);
      final user = UserModel.fromJson(data['user']);
      await StorageService.saveUserData(jsonEncode(user.toJson()));
      currentUser.value = user;

      Get.offAllNamed(_homeRoute);
    } catch (e) {
      Get.snackbar('Login Failed', e.toString(),
          backgroundColor: Colors.red.withAlpha(200), colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    if (registerNameController.text.isEmpty ||
        registerEmailController.text.isEmpty ||
        registerPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all required fields',
          backgroundColor: Colors.red.withAlpha(200), colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final data = await _datasource.register(
        fullName: registerNameController.text.trim(),
        email: registerEmailController.text.trim(),
        password: registerPasswordController.text,
        role: selectedRole.value,
        phone: registerPhoneController.text.trim(),
        position: selectedPosition.value,
      );

      await StorageService.saveToken(data['token']);
      final user = UserModel.fromJson(data['user']);
      await StorageService.saveUserData(jsonEncode(user.toJson()));
      currentUser.value = user;

      Get.offAllNamed(_homeRoute);
    } catch (e) {
      Get.snackbar('Registration Failed', e.toString(),
          backgroundColor: Colors.red.withAlpha(200), colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await StorageService.clearAll();
    currentUser.value = null;
    Get.offAllNamed(AppRoutes.login);
  }

}

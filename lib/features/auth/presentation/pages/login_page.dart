import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/app_icon.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Center(
                child: Text(
                  'Welcome Back',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Sign in to continue',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                ),
              ),
              const SizedBox(height: 40),
              CustomTextField(
                controller: controller.loginEmailController,
                hintText: 'Email address',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              Obx(
                () => CustomTextField(
                  controller: controller.loginPasswordController,
                  hintText: 'Password',
                  prefixIcon: Icons.lock_outlined,
                  obscureText: controller.obscurePassword.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.obscurePassword.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () =>
                        controller.obscurePassword.value = !controller.obscurePassword.value,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Obx(
                () => CustomButton(
                  text: 'Sign In',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.login,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.register),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: AppColors.primaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/auth_controller.dart';

class SplashPage extends GetView<AuthController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () => controller.checkAuth());

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1200),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: 0.5 + (value * 0.5),
                    child: child,
                  ),
                );
              },
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryLight.withAlpha(100),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'assets/app_icon.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1500),
              builder: (context, value, child) {
                return Opacity(opacity: value, child: child);
              },
              child: const Text(
                'FAN ZONE',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 4,
                ),
              ),
            ),
            const SizedBox(height: 8),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1800),
              builder: (context, value, child) {
                return Opacity(opacity: value, child: child);
              },
              child: const Text(
                'Book. Play. Compete.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

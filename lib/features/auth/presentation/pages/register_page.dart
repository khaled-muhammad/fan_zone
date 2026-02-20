import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../controllers/auth_controller.dart';

class RegisterPage extends GetView<AuthController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              CustomTextField(
                controller: controller.registerNameController,
                hintText: 'Full Name',
                prefixIcon: Icons.person_outlined,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: controller.registerEmailController,
                hintText: 'Email address',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              Obx(
                () => CustomTextField(
                  controller: controller.registerPasswordController,
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
              const SizedBox(height: 16),
              CustomTextField(
                controller: controller.registerPhoneController,
                hintText: 'Phone Number',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              const Text('Role', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              const SizedBox(height: 8),
              Obx(
                () => Row(
                  children: [
                    _buildRoleChip('player', 'Player'),
                    const SizedBox(width: 12),
                    _buildRoleChip('owner', 'Pitch Owner'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Obx(() {
                if (controller.selectedRole.value != 'player') {
                  return const SizedBox.shrink();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Position',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: controller.positions
                          .map((pos) => _buildPositionChip(pos))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }),
              const SizedBox(height: 24),
              Obx(
                () => CustomButton(
                  text: 'Create Account',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.register,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleChip(String value, String label) {
    final isSelected = controller.selectedRole.value == value;
    return GestureDetector(
      onTap: () => controller.selectedRole.value = value,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryLight : AppColors.textSecondary,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildPositionChip(String position) {
    final isSelected = controller.selectedPosition.value == position;
    return GestureDetector(
      onTap: () => controller.selectedPosition.value = position,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent.withAlpha(50) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.textSecondary,
          ),
        ),
        child: Text(
          position,
          style: TextStyle(
            color: isSelected ? AppColors.accent : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

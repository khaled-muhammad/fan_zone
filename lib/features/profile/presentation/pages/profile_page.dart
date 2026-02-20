import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../owner/data/datasources/owner_remote_datasource.dart';
import '../../../owner/data/models/owner_stats_model.dart';
import '../controllers/profile_controller.dart';
import '../widgets/player_card.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          Obx(() {
            if (controller.isEditing.value) {
              return IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => controller.isEditing.value = false,
              );
            }
            return IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => controller.isEditing.value = true,
            );
          }),
          Obx(() {
            final user = controller.profile.value;
            if (user != null && user.role == 'owner') {
              return IconButton(
                icon: const Icon(Icons.qr_code_scanner),
                tooltip: 'Scan QR',
                onPressed: () => Get.toNamed(AppRoutes.qrScanner),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.profile.value == null) {
          return const LoadingWidget(message: 'Loading profile...');
        }

        final user = controller.profile.value;
        if (user == null)
          return const Center(child: Text('Failed to load profile'));

        if (controller.isEditing.value) {
          return _buildEditForm(user);
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              PlayerCard(user: user),
              const SizedBox(height: 24),
              if (user.role == 'owner')
                _OwnerStatsSection()
              else
                _buildPlayerStats(user),
              const SizedBox(height: 24),
              _buildInfoTile(Icons.email_outlined, 'Email', user.email),
              _buildInfoTile(
                Icons.phone_outlined,
                'Phone',
                user.phone ?? 'Not set',
              ),
              _buildInfoTile(
                Icons.shield_outlined,
                'Role',
                user.role.capitalize!,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Logout',
                backgroundColor: AppColors.booked,
                icon: Icons.logout,
                onPressed: () => Get.find<AuthController>().logout(),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPlayerStats(UserModel user) {
    return Row(
      children: [
        _statCard('Goals', user.goals.toString(), Icons.sports_soccer),
        const SizedBox(width: 12),
        _statCard('Assists', user.assists.toString(), Icons.handshake),
        const SizedBox(width: 12),
        _statCard('Matches', user.matchesPlayed.toString(), Icons.emoji_events),
      ],
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primaryLight, size: 28),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryLight),
      title: Text(
        label,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
      ),
      subtitle: Text(value, style: const TextStyle(fontSize: 16)),
    );
  }

  Widget _buildEditForm(UserModel user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Edit Profile',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          CustomTextField(
            controller: controller.nameController,
            hintText: 'Full Name',
            prefixIcon: Icons.person_outlined,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: controller.phoneController,
            hintText: 'Phone',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          if (user.role == 'player') ...[
            const SizedBox(height: 16),
            CustomTextField(
              controller: controller.positionController,
              hintText: 'Position',
              prefixIcon: Icons.sports_soccer,
            ),
          ],
          const SizedBox(height: 32),
          Obx(
            () => CustomButton(
              text: 'Save Changes',
              isLoading: controller.isLoading.value,
              onPressed: controller.updateProfile,
            ),
          ),
        ],
      ),
    );
  }
}

class _OwnerStatsSection extends StatefulWidget {
  @override
  State<_OwnerStatsSection> createState() => _OwnerStatsSectionState();
}

class _OwnerStatsSectionState extends State<_OwnerStatsSection> {
  OwnerStatsModel? _stats;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final data = await OwnerRemoteDatasource().getOwnerStats();
      if (mounted) {
        setState(() {
          _stats = OwnerStatsModel.fromJson(data);
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final s = _stats;
    if (s == null) return const SizedBox.shrink();

    return Column(
      children: [
        Row(
          children: [
            _ownerStat('Pitches', '${s.totalPitches}', Icons.stadium),
            const SizedBox(width: 12),
            _ownerStat('Bookings', '${s.totalBookings}', Icons.calendar_month),
            const SizedBox(width: 12),
            _ownerStat('Completed', '${s.completed}', Icons.check_circle),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _ownerStat('Today', '${s.todayBookings}', Icons.today),
            const SizedBox(width: 12),
            _ownerStat('Checked In', '${s.checkedIn}', Icons.qr_code_scanner),
            const SizedBox(width: 12),
            const Expanded(child: SizedBox.shrink()),
          ],
        ),
      ],
    );
  }

  Widget _ownerStat(String label, String value, IconData icon) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: AppColors.checkedIn, size: 28),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              FittedBox(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

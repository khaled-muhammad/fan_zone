import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/services/theme_service.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../booking/data/models/booking_model.dart';
import '../controllers/owner_controller.dart';

class OwnerHomePage extends GetView<OwnerController> {
  const OwnerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset('assets/app_icon.png', width: 32, height: 32),
            ),
            const SizedBox(width: 8),
            const Text('FAN ZONE'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => Get.find<ThemeService>().toggleTheme(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.loadDashboard,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Dashboard',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildStatsGrid(),
              const SizedBox(height: 24),
              _buildQuickActions(),
              const SizedBox(height: 24),
              const Text("Today's Bookings",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildTodayBookings(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.stadium), label: 'My Pitches'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Scan QR'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          switch (index) {
            case 1:
              Get.toNamed(AppRoutes.myPitches);
              break;
            case 2:
              Get.toNamed(AppRoutes.qrScanner);
              break;
            case 3:
              Get.toNamed(AppRoutes.profile);
              break;
          }
        },
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Obx(() {
      if (controller.isStatsLoading.value && controller.stats.value == null) {
        return const SizedBox(height: 120, child: LoadingWidget());
      }
      final s = controller.stats.value;
      if (s == null) return const SizedBox.shrink();

      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.6,
        children: [
          _statCard('My Pitches', '${s.totalPitches}', Icons.stadium, AppColors.primaryLight),
          _statCard('Total Bookings', '${s.totalBookings}', Icons.calendar_month, AppColors.checkedIn),
          _statCard('Today', '${s.todayBookings}', Icons.today, AppColors.accent),
          _statCard('Checked In', '${s.checkedIn}', Icons.qr_code_scanner, AppColors.gold),
        ],
      );
    });
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 24),
                Text(value,
                    style: TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold, color: color)),
              ],
            ),
            Text(label,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _actionButton(
            icon: Icons.add_business,
            label: 'Add Pitch',
            color: AppColors.primaryLight,
            onTap: controller.prepareCreatePitch,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _actionButton(
            icon: Icons.qr_code_scanner,
            label: 'Scan QR',
            color: AppColors.gold,
            onTap: () => Get.toNamed(AppRoutes.qrScanner),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _actionButton(
            icon: Icons.stadium,
            label: 'My Pitches',
            color: AppColors.checkedIn,
            onTap: () => Get.toNamed(AppRoutes.myPitches),
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(label,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodayBookings() {
    return Obx(() {
      if (controller.todayBookings.isEmpty) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.event_available, size: 48,
                      color: AppColors.textSecondary.withAlpha(100)),
                  const SizedBox(height: 12),
                  const Text('No bookings today',
                      style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
        );
      }

      return Column(
        children: controller.todayBookings
            .map((b) => _bookingTile(b))
            .toList(),
      );
    });
  }

  Widget _bookingTile(BookingModel booking) {
    final statusColor = _statusColor(booking.status);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 50,
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.userName ?? 'Player',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${booking.startTime} - ${booking.endTime}  •  ${booking.pitchName ?? "Pitch"}',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withAlpha(30),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(booking.status,
                  style: TextStyle(
                      color: statusColor, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
            if (booking.status == 'Checked-In')
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: IconButton(
                  icon: const Icon(Icons.check_circle_outline, color: AppColors.available),
                  tooltip: 'Mark Complete',
                  onPressed: () => controller.completeBooking(booking.id),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Reserved':
        return AppColors.primaryLight;
      case 'Checked-In':
        return AppColors.checkedIn;
      case 'Completed':
        return AppColors.available;
      case 'Cancelled':
        return AppColors.booked;
      default:
        return AppColors.pending;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../pitches/data/models/pitch_model.dart';
import '../controllers/owner_controller.dart';

class MyPitchesPage extends GetView<OwnerController> {
  const MyPitchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Pitches')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryLight,
        onPressed: controller.prepareCreatePitch,
        child: const Icon(Icons.add),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.myPitches.isEmpty) {
          return const LoadingWidget(message: 'Loading your pitches...');
        }
        if (controller.myPitches.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.stadium, size: 64,
                    color: AppColors.textSecondary.withAlpha(100)),
                const SizedBox(height: 16),
                const Text('No pitches yet', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                const Text('Tap + to add your first pitch',
                    style: TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchMyPitches,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.myPitches.length,
            itemBuilder: (context, index) => _pitchCard(controller.myPitches[index]),
          ),
        );
      }),
    );
  }

  Widget _pitchCard(PitchModel pitch) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primaryLight.withAlpha(40),
                  child: const Icon(Icons.stadium, color: AppColors.primaryLight),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pitch.name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text(pitch.locationName,
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 13)),
                    ],
                  ),
                ),
                Text('${pitch.pricePerHour.toStringAsFixed(0)} EGP',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.primaryLight)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _chipInfo(Icons.access_time,
                    '${pitch.workingHoursStart}:00 - ${pitch.workingHoursEnd}:00'),
                const SizedBox(width: 8),
                _chipInfo(Icons.star, pitch.rating.toStringAsFixed(1)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => controller.prepareEditPitch(pitch),
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => controller.openPitchBookings(pitch),
                    icon: const Icon(Icons.list_alt, size: 18),
                    label: const Text('Bookings'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chipInfo(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(text, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

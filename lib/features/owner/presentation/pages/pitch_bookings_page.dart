import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../booking/data/models/booking_model.dart';
import '../controllers/owner_controller.dart';

class PitchBookingsPage extends GetView<OwnerController> {
  const PitchBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
            controller.selectedPitchForBookings.value?.name ?? 'Pitch Bookings')),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.pitchBookings.isEmpty) {
          return const LoadingWidget(message: 'Loading bookings...');
        }
        if (controller.pitchBookings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_busy, size: 64,
                    color: AppColors.textSecondary.withAlpha(100)),
                const SizedBox(height: 16),
                const Text('No bookings for this pitch',
                    style: TextStyle(fontSize: 18)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchPitchBookings(
              controller.selectedPitchForBookings.value!.id),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.pitchBookings.length,
            itemBuilder: (context, index) =>
                _bookingCard(controller.pitchBookings[index]),
          ),
        );
      }),
    );
  }

  Widget _bookingCard(BookingModel booking) {
    final statusColor = _statusColor(booking.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    booking.userName ?? 'Player',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    booking.status,
                    style: TextStyle(
                        color: statusColor, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text(booking.date,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                const SizedBox(width: 16),
                const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text('${booking.startTime} - ${booking.endTime}',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
            if (booking.status == 'Checked-In') ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => controller.completeBooking(booking.id),
                  icon: const Icon(Icons.check_circle, size: 18),
                  label: const Text('Mark as Completed'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.available,
                  ),
                ),
              ),
            ],
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../controllers/booking_controller.dart';
import '../../data/models/booking_model.dart';

class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookingController());
    controller.fetchMyBookings();

    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'Loading bookings...');
        }
        if (controller.myBookings.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today, size: 64, color: AppColors.textSecondary),
                SizedBox(height: 16),
                Text('No bookings yet', style: TextStyle(fontSize: 18)),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: controller.fetchMyBookings,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.myBookings.length,
            itemBuilder: (context, index) {
              return _buildBookingCard(controller.myBookings[index], controller);
            },
          ),
        );
      }),
    );
  }

  Widget _buildBookingCard(BookingModel booking, BookingController controller) {
    final statusColor = _statusColor(booking.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (booking.status == 'Reserved') {
            controller.lastCreatedBooking.value = booking;
            Get.toNamed(AppRoutes.qrCode);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    booking.pitchName ?? 'Pitch',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Text(booking.date, style: const TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(width: 16),
                  const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 6),
                  Text('${booking.startTime} - ${booking.endTime}',
                      style: const TextStyle(color: AppColors.textSecondary)),
                ],
              ),
              if (booking.status == 'Reserved') ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => controller.cancelBooking(booking.id),
                      child: const Text('Cancel', style: TextStyle(color: AppColors.booked)),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () {
                        controller.lastCreatedBooking.value = booking;
                        Get.toNamed(AppRoutes.qrCode);
                      },
                      icon: const Icon(Icons.qr_code, size: 18),
                      label: const Text('Show QR'),
                    ),
                  ],
                ),
              ],
            ],
          ),
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

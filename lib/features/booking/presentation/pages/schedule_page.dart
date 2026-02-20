import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../pitches/presentation/controllers/pitch_controller.dart';
import '../controllers/booking_controller.dart';

class SchedulePage extends GetView<BookingController> {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    final pitchController = Get.find<PitchController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final pitch = pitchController.selectedPitch.value;
          return Text(pitch?.name ?? 'Schedule');
        }),
      ),
      body: Column(
        children: [
          _buildDateSelector(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const LoadingWidget(message: 'Loading schedule...');
              }
              if (controller.timeSlots.isEmpty) {
                return const Center(child: Text('No time slots available'));
              }
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.8,
                ),
                itemCount: controller.timeSlots.length,
                itemBuilder: (context, index) {
                  final slot = controller.timeSlots[index];
                  return _buildSlotTile(slot);
                },
              );
            }),
          ),
          Obx(() {
            final slot = controller.selectedSlot.value;
            if (slot == null) return const SizedBox.shrink();
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(30),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('EEEE, MMM d').format(controller.selectedDate.value),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${slot.time} - ${_endTime(slot.time)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryLight,
                            ),
                          ),
                        ],
                      ),
                      Obx(() {
                        final pitch = pitchController.selectedPitch.value;
                        return Text(
                          '${pitch?.pricePerHour.toStringAsFixed(0) ?? '0'} EGP',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: 'Confirm Booking',
                    onPressed: () => Get.toNamed(AppRoutes.bookingConfirmation),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(12),
        itemCount: 14,
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index));
          return Obx(() {
            final isSelected = DateFormat('yyyy-MM-dd').format(date) ==
                DateFormat('yyyy-MM-dd').format(controller.selectedDate.value);
            return GestureDetector(
              onTap: () => controller.selectDate(date),
              child: Container(
                width: 60,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryLight : AppColors.darkCard,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('EEE').format(date),
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('d').format(date),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildSlotTile(dynamic slot) {
    return Obx(() {
      final isSelected = controller.selectedSlot.value?.time == slot.time;
      return GestureDetector(
        onTap: () => controller.selectSlot(slot),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: !slot.available
                ? AppColors.booked.withAlpha(40)
                : isSelected
                    ? AppColors.primaryLight
                    : AppColors.available.withAlpha(40),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: !slot.available
                  ? AppColors.booked
                  : isSelected
                      ? AppColors.primaryLight
                      : AppColors.available,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Center(
            child: Text(
              slot.time,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: !slot.available
                    ? AppColors.booked
                    : isSelected
                        ? Colors.white
                        : AppColors.available,
              ),
            ),
          ),
        ),
      );
    });
  }

  String _endTime(String startTime) {
    final hour = int.parse(startTime.split(':')[0]) + 1;
    return '${hour.toString().padLeft(2, '0')}:00';
  }
}

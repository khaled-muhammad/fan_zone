import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../pitches/presentation/controllers/pitch_controller.dart';
import '../controllers/booking_controller.dart';

class BookingConfirmationPage extends GetView<BookingController> {
  const BookingConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pitchController = Get.find<PitchController>();
    final pitch = pitchController.selectedPitch.value;
    final slot = controller.selectedSlot.value;

    if (pitch == null || slot == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Confirm Booking')),
        body: const Center(child: Text('Missing booking details')),
      );
    }

    final startHour = int.parse(slot.time.split(':')[0]);
    final endTime = '${(startHour + 1).toString().padLeft(2, '0')}:00';

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Booking')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withAlpha(30),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.sports_soccer,
                              size: 36, color: AppColors.primaryLight),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Center(
                        child: Text(
                          'Booking Summary',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      _infoRow('Pitch', pitch.name),
                      _infoRow('Location', pitch.locationName),
                      _infoRow('Date',
                          DateFormat('EEEE, MMM d, yyyy').format(controller.selectedDate.value)),
                      _infoRow('Time', '${slot.time} - $endTime'),
                      _infoRow('Price', '${pitch.pricePerHour.toStringAsFixed(0)} EGP'),
                      _infoRow('Payment', 'Cash'),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.pending.withAlpha(30),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline, color: AppColors.pending),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Payment is collected in cash at the pitch.',
                                style: TextStyle(color: AppColors.pending, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => CustomButton(
                text: 'Confirm & Get QR Code',
                isLoading: controller.isBooking.value,
                onPressed: controller.createBooking,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

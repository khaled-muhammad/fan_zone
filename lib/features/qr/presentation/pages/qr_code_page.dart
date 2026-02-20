import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../booking/presentation/controllers/booking_controller.dart';

class QrCodePage extends StatelessWidget {
  const QrCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingController = Get.find<BookingController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Your QR Code')),
      body: Obx(() {
        final booking = bookingController.lastCreatedBooking.value;
        if (booking == null) {
          return const Center(child: Text('No booking found'));
        }

        final qrData = jsonEncode({
          'bookingId': booking.id,
          'qrCodeToken': booking.qrCodeToken,
        });

        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryLight.withAlpha(40),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 250,
                    backgroundColor: Colors.white,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: AppColors.primaryDark,
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Show this to the pitch owner',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  'They will scan it to check you in',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _detailRow('Pitch', booking.pitchName ?? 'N/A'),
                        _detailRow('Date', booking.date),
                        _detailRow('Time', '${booking.startTime} - ${booking.endTime}'),
                        _detailRow('Status', booking.status),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
